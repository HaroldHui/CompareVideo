//
//  Act.swift
//  NICA
//
//  Created by Johan Albert on 8/08/2016.
//  Copyright © 2016 Johan Albert. All rights reserved.
//

import Foundation

class Act {
    
    var aid : String = ""
    var name : String = ""
    //var introduction : String
    //var trainer : String
    //var equipments : String
    //var prerequisites : [Prerequisite]
    var levels : [Level] = []
    
    init() {
        
    }
    
    init(name: String) {
        self.name = name
        levels = [
            Level(name: "Elementary"),
            Level(name: "Preliminary"),
            Level(name: "Foundation"),
            Level(name: "Intermediate"),
            Level(name: "Advanced")
        ]
    }
}