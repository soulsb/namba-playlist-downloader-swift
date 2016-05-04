//
//  AlbumImageView.swift
//  Namba Playlist Downloader
//
//  Created by Sultanbek Baibagyshev on 4/22/16.
//  Copyright © 2016 Sultanbek Baibagyshev. All rights reserved.
//

import Cocoa

class AlbumImageView: NSImageView {
    
    override func awakeFromNib() {
        self.layer?.cornerRadius = 5.0
        
    }

}
