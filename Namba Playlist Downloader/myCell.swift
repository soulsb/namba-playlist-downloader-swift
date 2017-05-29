//
//  myCell.swift
//  Namba Playlist Downloader
//
//  Created by Sultanbek Baibagyshev on 4/22/16.
//  Copyright © 2016 Sultanbek Baibagyshev. All rights reserved.
//

import Cocoa
import AVFoundation

class myCell: NSTableCellView {
    
    
    @IBOutlet weak var myProgress: NSProgressIndicator!
    
    @IBOutlet weak var checkButton: NSButton!
    var myObject: Song?
  
    override func draw(_ dirtyRect: NSRect) {
        self.imageView?.layer?.cornerRadius = 5
        
        // Drawing code here.
    }
    
        
}
