//
//  Dashboard.swift
//  NICA
//
//  Created by Johan Albert on 8/08/2016.
//  Copyright © 2016 Johan Albert. All rights reserved.
//

import Foundation

class Dashboard {
    
    var name : String = ""
    var categories : [Category] = []
    
    init() {
        
    }
    
    init(name: String) {
        self.name = name
        categories = [
            Category(name: "Category 1"),
            Category(name: "Category 2"),
            Category(name: "Category 3")
        ]
    }
    
    class var none : Dashboard {
        struct Static {
            static let instance = Dashboard(name: "Home")
        }
        return Static.instance
    }
}