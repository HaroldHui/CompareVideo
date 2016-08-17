//
//  Level.swift
//  NICA
//
//  Created by Johan Albert on 8/08/2016.
//  Copyright © 2016 Johan Albert. All rights reserved.
//

import Foundation

class Level {
    
    var name : String
    //var video : Video
    var skills : [Skill]
    
    init(name: String) {
        self.name = name
        skills = [
            Skill(name: "Skill 1"),
            Skill(name: "Skill 2"),
            Skill(name: "Skill 3")
        ]
    }
}