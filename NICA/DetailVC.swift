//
//  DetailVC.swift
//  NICA
//
//  Created by Johan Albert on 8/08/2016.
//  Copyright © 2016 Johan Albert. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {

    var dashboard : Dashboard = Dashboard.none
    
    override func viewWillAppear(animated: Bool) {
        self.title = dashboard.name
        
        if let svc = self.splitViewController {
            let ni = self.navigationItem
            ni.setLeftBarButtonItem(svc.displayModeButtonItem(), animated: false)
            ni.leftItemsSupplementBackButton = true;
        }
        
        super.viewWillAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
