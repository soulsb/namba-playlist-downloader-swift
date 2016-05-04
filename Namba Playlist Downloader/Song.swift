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


var myPath2:NSURL?

class Song: NSObject, NSURLSessionDelegate,NSURLSessionDataDelegate,NSURLSessionDownloadDelegate  {
    
    
    var session:NSURLSession?
    var dataTask:NSURLSessionDataTask?
    var infoDic = NSMutableDictionary()
    
    
    private var _songTitle:String = ""
    
    private var _checked:Bool?
    
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
    
    private var _cell:myCell?
    
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
    
    private var _imageFile:NSImage?
    
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
    
    private var _songID:String
    
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
    

    func md5(s:String) -> String {
        
        
        let context = UnsafeMutablePointer<CC_MD5_CTX>.alloc(1)
        var digest = Array<UInt8>(count:Int(CC_MD5_DIGEST_LENGTH), repeatedValue:0)
        CC_MD5_Init(context)
        CC_MD5_Update(context, s,
                      CC_LONG(s.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)))
        CC_MD5_Final(&digest, context)
        context.dealloc(1)
        var hexString = ""
        for byte in digest {
            hexString += String(format:"%02x", byte)
        }
        return hexString
        
    }
    
    func startDownloading(audioUrl:NSURL,path2:NSURL)
    {
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let manqueue = NSOperationQueue.mainQueue()
        session = NSURLSession(configuration: configuration, delegate:self, delegateQueue: manqueue)
        myPath2 = path2
        dataTask = session?.dataTaskWithRequest(NSURLRequest(URL: audioUrl))
        dataTask?.resume()
        
        
        
    }

    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveResponse response: NSURLResponse, completionHandler: (NSURLSessionResponseDisposition) -> Void) {
        //NSLog("%@",response.description)
        completionHandler(NSURLSessionResponseDisposition.BecomeDownload)
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        cell.myProgress.doubleValue = Double(totalBytesWritten)/Double(totalBytesExpectedToWrite)*100;
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didBecomeDownloadTask downloadTask: NSURLSessionDownloadTask) {
        
        downloadTask.resume()
        
        
        
    }
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        do{
            try NSFileManager().moveItemAtURL(location, toURL: myPath2!.URLByAppendingPathComponent(String(cell.textField!.stringValue)+".mp3"))
            
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


