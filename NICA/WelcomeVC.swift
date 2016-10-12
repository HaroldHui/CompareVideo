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

class WelcomeVC: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
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
        print(123123)
        let viewcontroller = WatchVideoVC()
        viewcontroller.enterFlg = 1
        self.navigationController!.pushViewController(viewcontroller, animated: true)
        
    }
    
    @IBAction func goTakeVideo(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        if (UIImagePickerController.isSourceTypeAvailable(.Camera)) {
            if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
                imagePicker.sourceType = .Camera
                imagePicker.mediaTypes = [kUTTypeMovie as String]
                imagePicker.allowsEditing = false
                imagePicker.delegate = self
                
                presentViewController(imagePicker, animated: true, completion: {})
            } else {
                postAlert("Rear camera doesn't exist", message: "Application cannot access the camera.")
            }
        } else {
            postAlert("Camera inaccessable", message: "Application cannot access the camera.")
        }
        

    }
    
    @IBAction func goToLocal(sender: AnyObject) {
//        // 1
//        if UIImagePickerController.isSourceTypeAvailable(.SavedPhotosAlbum) == false {
//            return false
//        }
        
        // 2
        let mediaUI = LandscapePickerController()
        mediaUI.sourceType = .SavedPhotosAlbum
        
        mediaUI.mediaTypes = [kUTTypeMovie as NSString as String]
        mediaUI.allowsEditing = true
        mediaUI.delegate = self
        
        // 3
        presentViewController(mediaUI, animated: true, completion: nil)
    }
    
    func postAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Cancel) { _ in }
        alert.addAction(action)
        self.navigationController!.presentViewController(alert, animated: true){}
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
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // 1
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        
        // 2
        dismissViewControllerAnimated(true) {
            // 3
            if mediaType == kUTTypeMovie {
                let path = info[UIImagePickerControllerMediaURL]
                let vc = WatchVideoVC()
                vc.showLocalVideo(path!)
                self.navigationController!.pushViewController(vc, animated: true)
               
                
            }
        }
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
