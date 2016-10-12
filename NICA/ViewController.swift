//
//  ViewController.swift
//  NICA
//
//  Created by Johan Albert on 18/05/2016.
//  Copyright © 2016 Johan Albert. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var userDefaults = NSUserDefaults.standardUserDefaults()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        if userDefaults.boolForKey("login") {
            let viewcontroller = WelcomeVC()
            self.navigationController!.pushViewController(viewcontroller, animated: true)
        } else {
            let viewcontroller = LoginVC()
            self.navigationController!.pushViewController(viewcontroller, animated: true)

        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
