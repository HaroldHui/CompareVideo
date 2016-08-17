//
//  Skill.swift
//  NICA
//
//  Created by Johan Albert on 8/08/2016.
//  Copyright © 2016 Johan Albert. All rights reserved.
//

import Foundation

class Skill {
    
    var name : String
    //var introduction : String
    var video : Video
    var pictures : [Picture]
    
    init(name: String) {
        self.name = name
        self.pictures = [
            Picture(name: "Picture 1"),
            Picture(name: "Picture 2")
        ]
        self.video = Video(name: "Video 1")
    }
}