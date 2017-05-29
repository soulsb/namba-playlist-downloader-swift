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
    var path2:URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
    // it doesn't work for now.
    @IBAction func playMusic(_ sender: NSButtonCell) {
        
        let url = songs[Int(sender.tag)].getLink()
        let playerItem = AVPlayerItem( url:URL( string:url )! )
        player = AVPlayer(playerItem:playerItem)
        player.rate = 1.0
        player.volume = 1.0
        player.play()
    
    }
    
    @IBOutlet weak var downloadButton: NSButton!
    
    @IBAction func getSongs(_ sender: AnyObject) {
        
        
        songs = [Song]()
        var myID=""
        var new1 = playlistURL.stringValue.components(separatedBy: "/")
        
            myID =  new1[new1.count-1].trimmingCharacters(in: CharacterSet.init(charactersIn: "la t, \n \" ':"))
        
            if myID == ""
            {
                if (new1.count-2>=0){
                myID = new1[new1.count-2].trimmingCharacters(in: CharacterSet.init(charactersIn: "la t, \n \" ':"))
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
        
            downloadButton.isEnabled = true

        
    }
    
    func convertToJSONUrl(_ myID:String) -> String {
        return "http://namba.kg/api/?service=music&action=playlist_page&id="+myID
    }
    
    @IBOutlet weak var text: NSTextField!
    
    @IBAction func openDir(_ sender: AnyObject) {
            let myOpenDialog: NSOpenPanel = NSOpenPanel()
            myOpenDialog.canChooseFiles = false
            myOpenDialog.canChooseDirectories = true
            myOpenDialog.runModal()
        
            let path = myOpenDialog.url?.path

            path2 = (myOpenDialog.url)!
            // Make sure that a path was chosen
            if (path != nil) {
                text.stringValue = String(path!)
            }
        }

    @IBAction func downloadSongs(_ sender: AnyObject) {
        downloadButton.isEnabled = false
        if (text.stringValue == "")
        {
        openDir(downloadButton)
        }
        
        
        for song in songs{
            //  First you need to create your audio url
            
            if let audioUrl = URL(string: song.getLink()) {
                
                // then lets create your document folder url
                let documentsDirectoryURL =  path2
                
                // lets create your destination file url
                let destinationUrl = documentsDirectoryURL!.appendingPathComponent(song.songTitle+".mp3")
                
                if FileManager().fileExists(atPath: destinationUrl.path) {
                    print("Файл \(song.songTitle) уже существует")
                    
                    // if the file doesn't exist
                } else {
                    
                    
                    
                    song.startDownloading(audioUrl,path2: path2!)
                    
                    
                }
            
            
        }
        
        }
        
    }
    func parseJSON(_ playlistURL:String)
    {
        if let myURL = URL(string: playlistURL){
        if let myURLData = try? Data(contentsOf: myURL) {
        
        
        do {
            let json = try JSONSerialization.jsonObject(with: myURLData, options: .allowFragments) as! [String:Any]
            
            if let mp3s = json["mp3Files"] as? [[String: Any]] {
                
                for mp3 in mp3s {
                    if let name = mp3["filename"] as? String {
                        songs.append(Song(songTitle: name,songID:(mp3["id"] as? String)!))
                    }
                    
                }
            }
            // getting album img file.
            do  {
            var str12 = try String(contentsOf: myURL, encoding: String.Encoding.utf8)
         
                let replaced = (str12 as NSString).replacingOccurrences(of: "\\", with: "")
                
                let start1 = replaced.range(of: "cover_url\":\"")
                
                str12 = replaced.substring(from: start1!.upperBound)
                
                let end1 = str12.range(of: "\",\"login")
                
                str12 = str12.substring(to: end1!.lowerBound)
                
                albumImg.image = NSImage(contentsOf: URL(string: str12)!)
           
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
    func numberOfRows(in aTableView: NSTableView) -> Int {
        return self.songs.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        // 1
        let cellView: myCell = tableView.make(withIdentifier: tableColumn!.identifier, owner: self) as! myCell
        
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




