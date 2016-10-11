//
//  WelcomeVC.swift
//  NICA
//
//  Created by lyx_xuan on 16/10/10o.
//  Copyright © 2016年 Johan Albert. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import MobileCoreServices

class WelcomeVC: UIViewController,UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    /**
     Goes to Selection Page for the Cloud library.
     
     - Parameters:
     - sender: The UIButton that calls this function
     */
    @IBAction func goToSelectionPage(sender: AnyObject) {
        let viewcontroller = WatchVideoVC()
        viewcontroller.enterFlg = 1
        self.navigationController!.pushViewController(viewcontroller, animated: true)

    }
    @IBAction func goTakeVideo(sender: AnyObject) {
        let viewcontroller = WatchVideoVC()
        viewcontroller.enterFlg = 2
        self.navigationController!.pushViewController(viewcontroller, animated: true)
    }
    
    @IBAction func goToLocal(sender: AnyObject) {
        let viewcontroller = WatchVideoVC()
        viewcontroller.enterFlg = 3
        self.navigationController!.pushViewController(viewcontroller, animated: true)
    }
    /**
     Goes to Selection Page for the Local library.
     
     - Parameters:
     - sender: The UIButton that calls this function
     */
    func selectLocalVideo(sender: UIButton) {
//        startMediaBrowserFromViewController(self, usingDelegate: self)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
