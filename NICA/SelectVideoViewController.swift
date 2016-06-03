//
//  SelectVideoViewController.swift
//  NICA
//
//  Created by Johan Albert on 18/05/2016.
//  Copyright © 2016 Johan Albert. All rights reserved.
//

import UIKit

protocol SelectVideoViewControllerDelegate {
    func myVCDidFinish(controller:SelectVideoViewController,text:String)
}

class SelectVideoViewController: UIViewController {
    var delegate:SelectVideoViewControllerDelegate? = nil
    var path = ""
    
    @IBOutlet weak var urlPath: UILabel!
    @IBAction func videoSelectionButton(sender: UIButton) {
        path = NSBundle.mainBundle().pathForResource(sender.titleLabel!.text!, ofType:"MOV")!
        urlPath.text = path
    }
    
    @IBAction func selectVideo(sender: UIButton) {
        if (delegate != nil) {
            delegate!.myVCDidFinish(self, text: urlPath.text!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
