//
//  Song.swift
//  Namba Playlist Downloader
//
//  Created by Sultanbek Baibagyshev on 4/21/16.
//  Copyright © 2016 Sultanbek Baibagyshev. All rights reserved.
//

import Foundation
import AppKit
import AVFoundation


var myPath2:URL?

class Song: NSObject, URLSessionDelegate,URLSessionDataDelegate,URLSessionDownloadDelegate  {
    
    
    var session:Foundation.URLSession?
    var dataTask:URLSessionDataTask?
    var infoDic = NSMutableDictionary()
    
    
    fileprivate var _songTitle:String = ""
    
    fileprivate var _checked:Bool?
    
    var isChecked:Bool {
        
        get
        
        {
            return _checked!
        }
        
        set
        
        {
            _checked = newValue
        }
    }
    
    fileprivate var _cell:myCell?
    
    var cell:myCell {
        get
        {
            return _cell!
        }
        
        set
        {
            _cell = newValue
        }
    }
    
    var songTitle:String {
        get
        {
               return _songTitle
        }
        
        set
        {
                _songTitle = newValue
        }
        
    }
    
    fileprivate var _imageFile:NSImage?
    
    var imageFile:NSImage {
        get
        {
            if let img = _imageFile
            {
                return img
            }
            else
        
            {
                return NSImage(named:"default")!}
            }
        
        set
        {
        _imageFile = newValue
        }
    }
    
    fileprivate var _songID:String
    
    var songID: String {
        get
        {
                return _songID
        }
        set
        {
                _songID = newValue
        }
    }
    
    init (songTitle:String,songID:String, image:String="default.jpg")

    {
        self._songTitle = songTitle
        self._songID = songID
    }
    
   
    func getLink() -> String
    {
        // The code for generating Namba Link was removed. 
        
        // You can generate on your own and return String value.
        return "No link is here"
    }
    

    func md5(_ s:String) -> String {
        
        
        let context = UnsafeMutablePointer<CC_MD5_CTX>.allocate(capacity: 1)
        var digest = Array<UInt8>(repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5_Init(context)
        CC_MD5_Update(context, s,
                      CC_LONG(s.lengthOfBytes(using: String.Encoding.utf8)))
        CC_MD5_Final(&digest, context)
        context.deallocate(capacity: 1)
        var hexString = ""
        for byte in digest {
            hexString += String(format:"%02x", byte)
        }
        return hexString
        
    }
    
    func startDownloading(_ audioUrl:URL,path2:URL)
    {
        
        let configuration = URLSessionConfiguration.default
        let manqueue = OperationQueue.main
        session = Foundation.URLSession(configuration: configuration, delegate:self, delegateQueue: manqueue)
        myPath2 = path2
        dataTask = session?.dataTask(with: URLRequest(url: audioUrl))
        dataTask?.resume()
        
        
        
    }

    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        //NSLog("%@",response.description)
        completionHandler(Foundation.URLSession.ResponseDisposition.becomeDownload)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        cell.myProgress.doubleValue = Double(totalBytesWritten)/Double(totalBytesExpectedToWrite)*100;
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome downloadTask: URLSessionDownloadTask) {
        
        downloadTask.resume()
        
        
        
    }
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        do{
            try FileManager().moveItem(at: location, to: myPath2!.appendingPathComponent(String(cell.textField!.stringValue)+".mp3"))
            
            cell.checkButton.state = 1
            
            cell.textField!.stringValue = cell.textField!.stringValue + "   Закачано!"
            
        }
            
        catch _ {
            print("error")
            
        }
        //NSLog("%@",location);
        //Get response
        //NSLog("%@", downloadTask.response!.description)
        
    }
    
    }


