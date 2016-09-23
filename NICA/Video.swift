//
//  Video.swift
//  NICA
//
//  Created by Johan Albert on 8/08/2016.
//  Copyright © 2016 Johan Albert. All rights reserved.
//

import Foundation

class Video {
    
    var name : String = ""
    var dir : String = ""
    
    init() {
        
    }
    
    init(name: String, path: String) {
        self.name = name
        self.dir = URLOFSERVER + path
    }
}
