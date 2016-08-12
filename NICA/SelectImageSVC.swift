//
//  SelectImageSVC.swift
//  NICA
//
//  Created by Johan Albert on 8/08/2016.
//  Copyright © 2016 Johan Albert. All rights reserved.
//

import UIKit

class SelectImageSVC: UISplitViewController, UISplitViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        // make two navigation controllers
        let master = UINavigationController()
        let detail = UINavigationController()
        
        // make a view controller for each navigation controller
        master.viewControllers = [MasterVC()]
        detail.viewControllers = [DetailVC()]
        
        // the split view controller has those two controllers
        self.viewControllers = [master, detail]
    }

    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        
        //        if let nc = secondaryViewController as? UINavigationController {
        //            if let topVc = nc.topViewController {
        //                if let dc = topVc as? DetailVC {
        //                    let hasDetail = Thing.noThing !== dc.thing
        //                    return !hasDetail
        //                }
        //            }
        //        }
        
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
