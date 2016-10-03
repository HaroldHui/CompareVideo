//
//  SelectImageSVC.swift
//  NICA
//
//  Created by Johan Albert on 8/08/2016.
//  Copyright © 2016 Johan Albert. All rights reserved.
//

import UIKit

protocol SelectionDelegate {
    func showVideo(controller:UIViewController, path:String)
    func showImage(controller:UIViewController, path:String)
}

class SelectImageSVC: UISplitViewController, UISplitViewControllerDelegate {
    
    var sDelegate:SelectionDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        // make two navigation controllers
        let master = UINavigationController()
        let detail = UINavigationController()
        
        let masterVC = MasterVC()
        masterVC.sDelegate = self.sDelegate
        
        // make a view controller for each navigation controller
        master.viewControllers = [masterVC]
        detail.viewControllers = [CategoryVC()]
        
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
