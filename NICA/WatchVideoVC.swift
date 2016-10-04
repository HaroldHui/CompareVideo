//
//  WatchVideoVC.swift
//  NICA
//
//  Created by HUIShu on 3/10/16.
//  Copyright © 2016 Johan Albert. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import MobileCoreServices


class WatchVideoVC: UIViewController, SelectionDelegate, UIScrollViewDelegate {
    
    
    
    // CONSTANTS
    let gap: CGFloat = 5
    
    // ------------------- VARIABLES FOR INIT --------------------
    var dashboard: Dashboard = Dashboard()
    var category: Category = Category()
    var act: Act = Act()
    var level: Level = Level()
    var video: Video = Video()
    var picture: Picture = Picture()
    
    // URL path for any video or image
    var path = ""
    
    // Container for each video
    let container1 = UIView()
    let container2 = UIView()
    
    // Two video controllers
    var video1: CustomVideoController? = nil
    var video2: CustomVideoController? = nil
    
    // -------------------- FUNCTIONS --------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        displaySelectionButtons()
        
        view.addSubview(container1)
        view.addSubview(container2)
        
//        let sPath = NSBundle.mainBundle().pathForResource("Elbow low and push up", ofType: "MOV")!
//        let urlPath = NSURL(fileURLWithPath: sPath)
//        
//        video1 = CustomVideoController(urlPath: urlPath, container: container1)
//        
//        container1.frame = CGRect(x: gap, y: 100, width: view.frame.width-2*gap, height: view.frame.width/2+80)
//        video1!.view.frame = CGRect(x: 0, y: 0, width: view.frame.width-2*gap, height: view.frame.width/2+80)
//        container1.addSubview(video1!.view)
    }
    
    /**
     Shows the cloud video using the given path.
     
     - Parameters:
     - controller: The controller who calls this function
     - path: The urlPath of the video from cloud
     */
    func showVideo(controller: UIViewController, path: String) {
        self.path = path
        let urlPath = NSURL(string: path)
        
        // if video1 already exists, remove it first from the superview
        video1?.removeFromParentViewController()
        video1?.view.removeFromSuperview()
        
        video1 = CustomVideoController(urlPath: urlPath, container: container1)
        
        // if video from local does not exist, show the cloud video with wide screen
        if video2 == nil {
            container1.frame = CGRect(x: gap,
                                      y: 120,
                                      width: view.frame.width-2*gap,
                                      height: view.frame.width/2+80)
            video1!.view.frame = CGRect(x: 0,
                                        y: 0,
                                        width: view.frame.width-2*gap,
                                        height: view.frame.width/2+80)
        }
            // if video from local exists, split the view for both videos
        else {
            container1.frame = CGRect(x: gap,
                                      y: 120,
                                      width: view.frame.width/2-3*gap,
                                      height: view.frame.width/2+80)
            video1!.view.frame = CGRect(x: 0,
                                        y: 0,
                                        width: view.frame.width/2-3*gap,
                                        height: view.frame.width/2+80)
            container2.frame = CGRect(x: self.view.frame.width/2+2*self.gap,
                                      y: 120,
                                      width: self.view.frame.width/2-3*self.gap,
                                      height: self.view.frame.width/2+80)
            video2!.view.frame = CGRect(x: 0,
                                        y: 0,
                                        width: self.view.frame.width/2-3*self.gap,
                                        height: self.view.frame.width/2+80)
            displayPlayBothButton()
        }
        container1.addSubview(video1!.view)
        
    }
    
    /**
     Shows the cloud image using the given path.
     
     - Parameters:
     - controller: The controller who calls this function
     - path: The urlPath of the iamge from cloud
     */
    func showImage(controller: UIViewController, path: String) {
        self.path = path
        
        //let scrollView = UIScrollView()
        //scrollView.frame = container1.frame
        
        let imageView = UIImageView()
        if let url = NSURL(string: path) {
            if let data = NSData(contentsOfURL: url) {
                imageView.image = UIImage(data: data)
            }        
        }
        
//        let url:NSURL = NSURL(string: path)!
//        let data:NSData = NSData(contentsOfURL: url)!
//        let image = UIImage(data: data)
        
        imageView.frame = CGRect(x: 0, y: 0, width: container1.frame.size.width, height: container1.frame.size.width)
        
        container1.addSubview(imageView)
        //scrollView.addSubview(imageView)
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return scrollView.subviews[0];
    }
    
    /**
     Goes to Selection Page for the Cloud library.
     
     - Parameters:
     - sender: The UIButton that calls this function
     */
    func goToSelectionPage(sender: UIButton) {
        let svc = SelectImageSVC();
        svc.sDelegate = self
        self.navigationController?.presentViewController(svc, animated: true, completion: nil)
    }
    
    /**
     Goes to Selection Page for the Local library.
     
     - Parameters:
     - sender: The UIButton that calls this function
     */
    func selectLocalVideo(sender: UIButton) {
        startMediaBrowserFromViewController(self, usingDelegate: self)
    }
    
    func logout(sender: UIButton) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setBool(false, forKey: "login")
        let viewcontroller = LoginVC()
        self.navigationController!.pushViewController(viewcontroller, animated: true)
    }
    
    /**
     Displays the built-in media browser.
     
     - Parameters:
     - viewController: The controller who calls this function
     - delegate: The delegate controller
     - Returns: a boolean
     */
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
    
    /**
     Shows the cloud video using the selected media.
     
     - Parameters:
     - picker: The controller who calls this function
     - info: The information that contains the type and path for the media
     */
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // 1
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        
        // 2
        dismissViewControllerAnimated(true) {
            // 3
            if mediaType == kUTTypeMovie {
                // if video2 already exists, remove it first from the superview
                self.video2?.removeFromParentViewController()
                self.video2?.view.removeFromSuperview()
                
                self.video2 = CustomVideoController(urlPath: info[UIImagePickerControllerMediaURL] as? NSURL, container: self.container2)
                
                // if video from cloud does not exist, show the local video with wide screen
                if self.video1 == nil {
                    self.container2.frame = CGRect(x: self.gap,
                                                   y: 120,
                                                   width: self.view.frame.width-2*self.gap,
                                                   height: self.view.frame.width/2+80)
                    self.video2!.view.frame = CGRect(x: 0,
                                                     y: 0,
                                                     width: self.view.frame.width-2*self.gap,
                                                     height: self.view.frame.width/2+80)
                }
                    // if video from cloud exists, split the view for both videos
                else {
                    self.container2.frame = CGRect(x: self.view.frame.width/2+2*self.gap,
                                                   y: 120,
                                                   width: self.view.frame.width/2-3*self.gap,
                                                   height: self.view.frame.width/2+80)
                    self.video2!.view.frame = CGRect(x: 0,
                                                     y: 0,
                                                     width: self.view.frame.width/2-3*self.gap,
                                                     height: self.view.frame.width/2+80)
                    self.container1.frame = CGRect(x: self.gap,
                                                   y: 120,
                                                   width: self.view.frame.width/2-3*self.gap,
                                                   height: self.view.frame.width/2+80)
                    self.video1!.view.frame = CGRect(x: 0,
                                                     y: 0,
                                                     width: self.view.frame.width/2-3*self.gap,
                                                     height: self.view.frame.width/2+80)
                    self.video1!.updateFrames(self.container1)
                    self.displayPlayBothButton()
                }
                self.container2.addSubview(self.video2!.view)
                
            }
        }
    }
    
    // ------------------- UI --------------------
    
    // Buttons
    let selectCloudButton = UIButton()
    let selectLocalButton = UIButton()
    let logoutButton = UIButton()
    let playBothButton: UIButton? = nil
    
    /**
     Displays "Select from Cloud" and "Select from Local" buttons.
     */
    func displaySelectionButtons() {
        // Button for Select Cloud Video or Image
        selectCloudButton.frame = CGRect(x: 10, y: 75, width: 150, height: 25)
        selectCloudButton.setTitle("Select from Cloud", forState: UIControlState.Normal)
        selectCloudButton.titleLabel!.text = "Select from Cloud"
        selectCloudButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        selectCloudButton.addTarget(self, action: #selector(WatchVideoVC.goToSelectionPage(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(selectCloudButton)
        
        // Button for Select Local Video
        selectLocalButton.frame = CGRect(x: UIScreen.mainScreen().bounds.size.width-160, y: 75, width: 150, height: 25)
        selectLocalButton.setTitle("Select from Local", forState: UIControlState.Normal)
        selectLocalButton.titleLabel!.text = "Select from Local"
        selectLocalButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        selectLocalButton.addTarget(self, action: #selector(WatchVideoVC.selectLocalVideo(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(selectLocalButton)
        
        // Button logout
        logoutButton.frame = CGRect(x: self.view.frame.size.width, y: 75, width: 60, height: 25)
        logoutButton.setTitle("logout", forState: UIControlState.Normal)
        logoutButton.titleLabel!.text = "logout"
        logoutButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        logoutButton.addTarget(self, action: #selector(WatchVideoVC.logout(_:)), forControlEvents: .TouchUpInside)
        //self.view.addSubview(logoutButton)
    }
    
    /**
     Displays "Play/Pause Both" button.
     */
    func displayPlayBothButton() {
        if playBothButton == nil {
            let playBothButton = UIButton(frame: CGRect(x: 450, y: 720, width: 150, height: 40))
            playBothButton.setTitle("Play/Pause Both", forState: .Normal)
            playBothButton.titleLabel!.text = "Play/Pause Both"
            playBothButton.backgroundColor = .blackColor()
            playBothButton.layer.cornerRadius = 5
            playBothButton.layer.borderWidth = 1
            playBothButton.layer.borderColor = UIColor.blackColor().CGColor
            self.view.addSubview(playBothButton)
            playBothButton.addTarget(self, action: #selector(playBoth(_:)), forControlEvents: .TouchUpInside)
        }
    }
    
    /**
     Play or Pause both videos at the same time.
     
     - Parameters:
     - sender: The UIButton that calls this function
     */
    func playBoth(sender: UIButton) {
        // If at least one of the videos is paused
        if video1!.videoState == 0 || video2!.videoState == 0 {
            video1!.player.play()
            video2!.player.play()
            if video1!.slowmotion == true {
                video1!.player.rate = 0.5
            }
            if video2!.slowmotion == true {
                video2!.player.rate = 0.5
            }
            video1!.videoState = 1
            video1!.playButton.setImage(video1!.pauseButtonImage, forState: .Normal)
            video2!.videoState = 1
            video2!.playButton.setImage(video1!.pauseButtonImage, forState: .Normal)
        }
            // If at least one of the video is playing
        else if video1!.videoState == 1 || video2!.videoState == 1 {
            video1!.player.pause()
            video2!.player.pause()
            video1!.videoState = 0
            video1!.playButton.setImage(video1!.playButtonImage, forState: .Normal)
            video2!.videoState = 0
            video2!.playButton.setImage(video1!.playButtonImage, forState: .Normal)
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
extension WatchVideoVC: UIImagePickerControllerDelegate {
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Landscape
    }
}

// MARK: - UINavigationControllerDelegate
extension WatchVideoVC: UINavigationControllerDelegate {
}