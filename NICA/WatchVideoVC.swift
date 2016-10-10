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


class WatchVideoVC: UIViewController, SelectionDelegate, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // enter flag
    var enterFlg = 0
    
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
        if enterFlg == 1 {
            enterFlg = 0
            let svc = SelectImageSVC();
            svc.sDelegate = self
            self.navigationController?.presentViewController(svc, animated: true, completion: nil)
        }else if enterFlg == 2{
            
        }else if enterFlg == 3{
            
        }
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = "Watch Video Pape"
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        displayToolbar()
//        displaySelectionButtons()
        
        view.addSubview(container1)
        view.addSubview(container2)
        
    }
    
    /**
     Shows the cloud video using the given path.
     
     - Parameters:
     - controller: The controller who calls this function
     - path: The urlPath of the video from cloud
     */
    func showVideo(controller: UIViewController, path: String) {
        self.path = path
        let urlPath = NSURL(string: path.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)
        
        // if video1 already exists, remove it first from the superview
        video1?.removeFromParentViewController()
        video1?.view.removeFromSuperview()
        
        video1 = CustomVideoController(urlPath: urlPath, container: container1)
        
        // if video from local does not exist, show the cloud video with wide screen
        if video2 == nil {
            container1.frame = CGRect(x: gap,
                                      y: 75,
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
                                      y: 75,
                                      width: view.frame.width/2-3*gap,
                                      height: view.frame.width/2+80)
            video1!.view.frame = CGRect(x: 0,
                                        y: 0,
                                        width: view.frame.width/2-3*gap,
                                        height: view.frame.width/2+80)
            container2.frame = CGRect(x: self.view.frame.width/2+2*self.gap,
                                      y: 75,
                                      width: self.view.frame.width/2-3*self.gap,
                                      height: self.view.frame.width/2+80)
            video2!.view.frame = CGRect(x: 0,
                                        y: 0,
                                        width: self.view.frame.width/2-3*self.gap,
                                        height: self.view.frame.width/2+80)
            self.video2!.updateFrames(self.container2)
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
        container1.frame = CGRect(x: gap,
                                  y: 100,
                                  width: UIScreen.mainScreen().bounds.size.width-2*gap,
                                  height: UIScreen.mainScreen().bounds.size.height*3/4)
        container1.backgroundColor = .blackColor()
        let scrollView = UIScrollView()
        scrollView.frame = CGRect(x:0,y:0,width: container1.frame.size.width, height: container1.frame.size.height)
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 10.0
        
        
        let imageView = UIImageView()
        if let url = NSURL(string: path) {
            if let data = NSData(contentsOfURL: url) {
                imageView.image = UIImage(data: data)
            }        
        }
        
        imageView.frame = CGRect(x: 0, y: 0, width: container1.frame.size.width, height: container1.frame.size.width)

        scrollView.addSubview(imageView)
        container1.addSubview(scrollView)
        
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
        let refreshAlert = UIAlertController(title: "Logout", message: "Are you sure?", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            let userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setBool(false, forKey: "login")
            let viewcontroller = LoginVC()
            self.navigationController!.pushViewController(viewcontroller, animated: true)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction!) in
            
        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)
        
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
        let mediaUI = LandscapePickerController()
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
                                                   y: 75,
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
                                                   y: 75,
                                                   width: self.view.frame.width/2-3*self.gap,
                                                   height: self.view.frame.width/2+80)
                    self.video2!.view.frame = CGRect(x: 0,
                                                     y: 0,
                                                     width: self.view.frame.width/2-3*self.gap,
                                                     height: self.view.frame.width/2+80)
                    self.container1.frame = CGRect(x: self.gap,
                                                   y: 75,
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
        
    }
    
    /**
     Displays "Play/Pause Both" button.
     */
    func displayPlayBothButton() {
        if playBothButton == nil {
            let playBothButton = UIButton(frame: CGRect(x: 450, y: 670, width: 150, height: 40))
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
        if video1!.videoState == 2 {
            video1!.player.seekToTime(kCMTimeZero)
        }
        if video2!.videoState == 2 {
            video2!.player.seekToTime(kCMTimeZero)
        }
        
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
        // Button logout
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: #selector(logout(_:)))
        super.viewDidAppear(animated)
        
    }
    
    
    private func displayToolbar(){
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)

        let cloudButton = UIBarButtonItem(title: "Cloud", style: .Plain, target: self, action: #selector(WatchVideoVC.goToSelectionPage(_:)))
        let localButton = UIBarButtonItem(title: "Local", style: .Plain, target: self, action: #selector(WatchVideoVC.selectLocalVideo(_:)))
        let takeVideoButton = UIBarButtonItem(title: "Video", style: .Plain, target: self, action: #selector(WatchVideoVC.takeVideo(_:)))
 
        let toolbarButtons = [flexibleSpace,cloudButton,flexibleSpace,takeVideoButton,flexibleSpace,localButton,flexibleSpace]
        let toolbar = UIToolbar()
        toolbar.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height-46, self.view.frame.size.width, 47)
        toolbar.sizeToFit()
        toolbar.setItems(toolbarButtons, animated: true)
        toolbar.backgroundColor = UIColor.grayColor()
        self.view.addSubview(toolbar)
    }
    
    
    
    func takeVideo(sender: UIButton){
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
    
    func postAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Cancel) { _ in }
        alert.addAction(action)
        self.navigationController!.presentViewController(alert, animated: true){}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
