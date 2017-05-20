//
//  Song.swift
//  mp3zing
//
//  Created by Quang Vu on 5/17/17.
//  Copyright © 2017 com.quangvt. All rights reserved.
//

import UIKit

struct Song {
    var title = ""
    var artistName = ""
    var thumbnail: UIImage
    var sourceOnline = ""
    var sourceLocal = ""
    var localThumbnail = ""
    var baseThumbnail = "http://image.mp3.zdn.vn//thumb/240_240/"
    
    init (title: String, artistName: String, thumbnail: String, source: String) {
        self.title = title
        self.artistName = artistName
        let thumbnailURL = baseThumbnail + thumbnail
        let dataImage = try? Data(contentsOf: URL(string: thumbnailURL)!)
        self.thumbnail = UIImage(data: dataImage!)!
        self.sourceOnline = source
    }
    
    init (title: String, artistName: String, localThumbnail: String, localSource: String) {
        self.title = title
        self.artistName = artistName
        self.localThumbnail = localThumbnail
        let dataImage = try? Data(contentsOf: URL(fileURLWithPath: self.localThumbnail))
        self.thumbnail = UIImage(data: dataImage!)!
        self.sourceLocal = localSource
    }
    
}
