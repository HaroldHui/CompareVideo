//
//  Folder.swift
//  NICA
//
//  Created by Johan Albert on 8/08/2016.
//  Copyright © 2016 Johan Albert. All rights reserved.
//

import Foundation

class Folder {
    
    var fid : String = ""
    var name : String = ""
    var description : String = ""

    var videos : [Video] = []
    var pictures : [Picture] = []
    
    init() {
        
    }
    
    init (name: String, fid: String) {
        self.name = name
        self.fid = fid
    }
    
    init(name: String) {
        self.name = name
        self.videos = [
            Video(name: "Vid 1", path: "")
        ]
        self.pictures = [
            Picture(name: "Pic 1", path: "")
        ]
    }
}
