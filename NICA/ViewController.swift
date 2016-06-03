//
//  ViewController.swift
//  NICA
//
//  Created by Johan Albert on 18/05/2016.
//  Copyright © 2016 Johan Albert. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import MobileCoreServices

class ViewController: UIViewController, SelectVideoViewControllerDelegate {
    
    var path = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // when the SelectVideoViewController finished selecting the path, it sends the url path
    // to this ViewController then play the video
    func myVCDidFinish(controller: SelectVideoViewController, text: String) {
        self.path = text
        let player = AVPlayer(URL: NSURL(fileURLWithPath: path))
        let playerController = AVPlayerViewController()
        playerController.view.frame = CGRect(x: 10, y: 150, width: self.view.frame.size.width/2, height: self.view.frame.size.height/2)
        playerController.player = player
        self.addChildViewController(playerController)
        self.view.addSubview(playerController.view)
        controller.navigationController?.popViewControllerAnimated(true)
    }
    
    // prepare for segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "mySegue"{
            let vc = segue.destinationViewController as! SelectVideoViewController
            vc.path = self.path
            vc.delegate = self
        }
    }

    // "Select A Local Video" button leading to local video library
    @IBAction func selectLocalVideo() {
        startMediaBrowserFromViewController(self, usingDelegate: self)
    }
    
    func startMediaBrowserFromViewController(viewController: UIViewController, usingDelegate delegate: protocol<UINavigationControllerDelegate, UIImagePickerControllerDelegate>) -> Bool {
        // 1
        if UIImagePickerController.isSourceTypeAvailable(.SavedPhotosAlbum) == false {
            return false
        }
        
        // 2
        let mediaUI = UIImagePickerController()
        mediaUI.sourceType = .SavedPhotosAlbum
        mediaUI.mediaTypes = [kUTTypeMovie as NSString as String]
        mediaUI.allowsEditing = true
        mediaUI.delegate = delegate
        
        // 3
        presentViewController(mediaUI, animated: true, completion: nil)
        return true
    }
    
    // when a video is chosen, the video will be played in this page
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // 1
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        
        // 2
        dismissViewControllerAnimated(true) {
            // 3
            if mediaType == kUTTypeMovie {
                let player2 = AVPlayer(URL: info[UIImagePickerControllerMediaURL] as! NSURL)
                let playerController2 = AVPlayerViewController()
                playerController2.view.frame = CGRect(x: 20+self.view.frame.size.width/2, y: 150, width: self.view.frame.size.width/2, height: self.view.frame.size.height/2)
                playerController2.player = player2
                self.addChildViewController(playerController2)
                self.view.addSubview(playerController2.view)
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: - UIImagePickerControllerDelegate
extension ViewController: UIImagePickerControllerDelegate {
}

// MARK: - UINavigationControllerDelegate
extension ViewController: UINavigationControllerDelegate {
}