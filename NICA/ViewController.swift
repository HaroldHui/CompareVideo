//
//  ViewController.swift
//  NICA
//
//  Created by Johan Albert on 18/05/2016.
//  Copyright © 2016 Johan Albert. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let viewcontroller = LoginVC()
        self.presentViewController(viewcontroller, animated: true, completion: nil)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
