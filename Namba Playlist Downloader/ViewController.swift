//
//  ViewController.swift
//  Namba Playlist Downloader
//
//  Created by Sultanbek Baibagyshev on 4/20/16.
//  Copyright © 2016 Sultanbek Baibagyshev. All rights reserved.
//



import Cocoa
import AVFoundation

class ViewController: NSViewController{
    

   var player = AVPlayer()
    
    @IBOutlet weak var showSongsButton: NSButton!

    @IBOutlet weak var totalLabel: NSTextField!
    
    @IBOutlet weak var tableView: NSTableView!
    
    @IBOutlet weak var albumImg: NSImageView!
    
    @IBOutlet weak var playlistURL: NSTextField!
    
    @IBOutlet weak var progressBar: NSProgressIndicator!
    
    @IBOutlet weak var progressBarNew: NSProgressIndicator!
    
    @IBOutlet weak var progressLabel: NSTextField!
    var songs = [Song]()
    var path2:NSURL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
    // it doesn't work for now.
    @IBAction func playMusic(sender: NSButtonCell) {
        
        sender
        let url = songs[Int(sender.tag)].getLink()
        let playerItem = AVPlayerItem( URL:NSURL( string:url )! )
        player = AVPlayer(playerItem:playerItem)
        player.rate = 1.0
        player.volume = 1.0
        player.play()
    
    }
    
    @IBOutlet weak var downloadButton: NSButton!
    
    @IBAction func getSongs(sender: AnyObject) {
        
        
        songs = [Song]()
        var myID=""
        var new1 = playlistURL.stringValue.componentsSeparatedByString("/")
        
            myID =  new1[new1.count-1].stringByTrimmingCharactersInSet(NSCharacterSet.init(charactersInString: "la t, \n \" ':"))
        
            if myID == ""
            {
                if (new1.count-2>=0){
                myID = new1[new1.count-2].stringByTrimmingCharactersInSet(NSCharacterSet.init(charactersInString: "la t, \n \" ':"))
                }
                else{
                    progressLabel.stringValue = ("Неверно введен URL")
                    return
                }
            }
        
            // converting to json
            let jsonURL = convertToJSONUrl(myID)
      
            parseJSON(jsonURL)
        
            totalLabel.stringValue = String(songs.count)
        
        
            tableView.reloadData()
        
            downloadButton.enabled = true

        
    }
    
    func convertToJSONUrl(myID:String) -> String {
        return "http://namba.kg/api/?service=music&action=playlist_page&id="+myID
    }
    
    @IBOutlet weak var text: NSTextField!
    
    @IBAction func openDir(sender: AnyObject) {
            let myOpenDialog: NSOpenPanel = NSOpenPanel()
            myOpenDialog.canChooseFiles = false
            myOpenDialog.canChooseDirectories = true
            myOpenDialog.runModal()
        
            let path = myOpenDialog.URL?.path

            path2 = (myOpenDialog.URL)!
            // Make sure that a path was chosen
            if (path != nil) {
                text.stringValue = String(path!)
            }
        }

    @IBAction func downloadSongs(sender: AnyObject) {
        downloadButton.enabled = false
        if (text.stringValue == "")
        {
        openDir(downloadButton)
        }
        
        
        for song in songs{
            //  First you need to create your audio url
            
            if let audioUrl = NSURL(string: song.getLink()) {
                
                // then lets create your document folder url
                let documentsDirectoryURL =  path2
                
                // lets create your destination file url
                let destinationUrl = documentsDirectoryURL!.URLByAppendingPathComponent(song.songTitle+".mp3")
                
                if NSFileManager().fileExistsAtPath(destinationUrl.path!) {
                    print("Файл \(song.songTitle) уже существует")
                    
                    // if the file doesn't exist
                } else {
                    
                    
                    
                    song.startDownloading(audioUrl,path2: path2!)
                    
                    
                }
            
            
        }
        
        }
        
    }
    func parseJSON(playlistURL:String)
    {
        if let myURL = NSURL(string: playlistURL){
        if let myURLData = NSData(contentsOfURL:myURL) {
        
        
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(myURLData, options: .AllowFragments)
            
            if let mp3s = json["mp3Files"] as? [[String: AnyObject]] {
                
                for mp3 in mp3s {
                    if let name = mp3["filename"] as? String {
                        songs.append(Song(songTitle: name,songID:(mp3["id"] as? String)!))
                    }
                    
                }
            }
            // getting album img file.
            do  {
            var str12 = try String(contentsOfURL: myURL, encoding: NSUTF8StringEncoding)
         
                let replaced = (str12 as NSString).stringByReplacingOccurrencesOfString("\\", withString: "")
                
                let start1 = replaced.rangeOfString("cover_url\":\"")
                
                str12 = replaced.substringFromIndex(start1!.endIndex)
                
                let end1 = str12.rangeOfString("\",\"login")
                
                str12 = str12.substringToIndex(end1!.startIndex)
                
                albumImg.image = NSImage(contentsOfURL: NSURL(string: str12)!)
           
            }
            
            catch
            {
            return
            }
            
        } catch {
            progressLabel.stringValue = ("Ошибка чтения JSON: \(error)")
        }
    
        }
        
        else {
            progressLabel.stringValue = ( "Что-то пошло не так или плейлист не существует =( ")
            return
            }}
        
    }

    
    
}



extension ViewController: NSTableViewDataSource {
    func numberOfRowsInTableView(aTableView: NSTableView) -> Int {
        return self.songs.count
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        // 1
        let cellView: myCell = tableView.makeViewWithIdentifier(tableColumn!.identifier, owner: self) as! myCell
        
        // 2
        if tableColumn!.identifier == "songsColumn" {
            // 3
            let song = self.songs[row]
            cellView.imageView!.image = song.imageFile
            cellView.textField!.stringValue = song.songTitle
            cellView.checkButton.state = 0
            song.cell = cellView
            return cellView
        }
        
        return cellView
    }
}

// MARK: - NSTableViewDelegate
extension ViewController: NSTableViewDelegate {
}




