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
    var description : String = ""
    var trainer : String = ""
    var equipments : String = ""
    
    var prerequisites : [Folder] = []
    var foundation : [Folder] = []
    var intermediate : [Folder] = []
    var advanced : [Folder] = []
    var professional : [Folder] = []
    
    init() {
        
    }
    
    init(name: String) {
        self.name = name
        self.prerequisites = [
            Folder(name: "Folder 1"),
            Folder(name: "FOlder 2")
        ]
        self.foundation = [
            Folder(name: "Folder 1"),
            Folder(name: "FOlder 2")
        ]
        self.intermediate = [
            Folder(name: "Folder 1"),
            Folder(name: "FOlder 2")
        ]
        self.advanced = [
            Folder(name: "Folder 1"),
            Folder(name: "FOlder 2")
        ]
        self.professional = [
            Folder(name: "Folder 1"),
            Folder(name: "FOlder 2")
        ]
    }
    
    init(name: String, aid: String) {
        self.name = name
        self.aid = aid
    }
    
}