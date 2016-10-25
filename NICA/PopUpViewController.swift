//
//  PopUpViewController.swift
//  NICA
//
//  Created by HUIShu on 25/10/16.
//  Copyright © 2016 Johan Albert. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {
    
    var userDefaults = NSUserDefaults.standardUserDefaults()

    override func viewDidLoad() {

        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blueColor().colorWithAlphaComponent(0.5)
        self.showAnimate()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var ipAddress: UITextField!
    @IBAction func submitAction(sender: UIButton) {
        userDefaults.setValue(ipAddress.text, forKey: "ipAddress")
        URLOFSERVER = ipAddress.text!
        self.removeAnimate()
    }

    @IBAction func cancelAction(sender: UIButton) {
        self.removeAnimate()
    }
    
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
        self.view.alpha = 0.0;
        UIView.animateWithDuration(0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animateWithDuration(0.25, animations: {
            self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
            self.view.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished)
                {
                    self.view.removeFromSuperview()
                }
        });
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
