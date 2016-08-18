//
//  Root.swift
//  NICA
//
//  Created by Johan Albert on 8/08/2016.
//  Copyright © 2016 Johan Albert. All rights reserved.
//

import Foundation

class Root {
    
    var dashboard : [Dashboard] = []
    
    class var rootInstance : Root {
        struct Static {
            static let instance  = Root()
        }
        return Static.instance
    }
    
    init() {
        dashboard = [
            Dashboard(name: "Basics", categories: []),
            Dashboard(name: "Specialties", categories: []),
            Dashboard(name: "Group Acts", categories: [])
        ]
    }
}