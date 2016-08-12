//
//  Category.swift
//  NICA
//
//  Created by Johan Albert on 8/08/2016.
//  Copyright © 2016 Johan Albert. All rights reserved.
//

import Foundation

class Category {
    
    var name : String
    //var tag : String
    var acts : [Act]
    
    init(name: String) {
        self.name = name
        acts = [
            Act(name: "Act 1"),
            Act(name: "Act 2"),
            Act(name: "Act 3")
        ]
    }
}