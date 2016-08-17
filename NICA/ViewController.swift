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

class ViewController: UIViewController, SelectVideoViewControllerDelegate, SelectImageDelegate, UIScrollViewDelegate {
    
    var dashboard: Dashboard = Dashboard()
    var category: Category = Category()
    var act: Act = Act()
    var level: Level = Level()
    var skill: Skill = Skill()
    var video: Video = Video()
    var picture: Picture = Picture()
    
    // URL path for any video or image
    var path = ""
    
    // use the scroll view to enable the zoom in and zoom out feature
    var scrollView = UIScrollView()
    var playerController = AVPlayerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clearColor()
        scrollView.delegate = self
        scrollView.frame = CGRect(x: 10, y: 150, width: self.view.frame.width/2, height: self.view.frame.width/2)
        scrollView.backgroundColor = UIColor.darkGrayColor()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.flashScrollIndicators()
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 10.0
        
        let videoImageUrl = UILabel(frame: CGRect(x: 10, y: 100, width: 150, height: 50))
        videoImageUrl.text = video.dir
        self.view.addSubview(videoImageUrl)
        
        let player = AVPlayer(URL: NSURL(fileURLWithPath: video.dir))
        
        playerController.view.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: scrollView.frame.width)
        playerController.player = player
        // DISABLE ALL THE USER INTERACITON, INCLUDING THE PINCH GESTURE
        // THIS WAY, THE VIDEO CAN BE ZOOMED LIKE AN IMAGE
        // HOWEVER NEED TO IMPLEMENT ALL THE BUTTONS OUTSIDE
        // THE VIDEO PLAYER
        playerController.view.userInteractionEnabled = false
        playerController.showsPlaybackControls = false
        
        self.addChildViewController(playerController)
        
        self.view.addSubview(scrollView)
        scrollView.addSubview(playerController.view)
        
        // BUTTONS FOR CONTROLLING THE VIDEO
        // PLAY, PAUSE, SLOW MOTION
        let button1 = UIButton(frame: CGRect(x: 10, y: 175 + self.view.frame.width/2, width: 100, height: 50))
        button1.setTitle("Play", forState: UIControlState.Normal)
        button1.titleLabel?.text = "Play"
        button1.backgroundColor = UIColor.blackColor()
        
        button1.addTarget(self, action: #selector(self.play(_:)), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(button1)
        
        let button2 = UIButton(frame: CGRect(x: 120, y: 175 + self.view.frame.width/2, width: 100, height: 50))
        button2.setTitle("Pause", forState: UIControlState.Normal)
        button2.titleLabel?.text = "Pause"
        button2.backgroundColor = UIColor.blackColor()
        
        button2.addTarget(self, action: #selector(self.pause(_:)), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(button2)
        
        let button3 = UIButton(frame: CGRect(x: 230, y: 175 + self.view.frame.width/2, width: 100, height: 50))
        button3.setTitle("Slow-Mo", forState: UIControlState.Normal)
        button3.titleLabel?.text = "Slow-Mo"
        button3.backgroundColor = UIColor.blackColor()
        
        button3.addTarget(self, action: #selector(self.slowmo(_:)), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(button3)
    }
    
    func play(sender: UIButton) {
        playerController.player?.play()
    }
    
    func pause(sender: UIButton) {
        playerController.player?.pause()
    }
    
    func slowmo(sender: UIButton) {
        playerController.player!.rate = 0.5
    }
    
    // when the SelectVideoViewController finished selecting the path, it sends the url path
    // to this ViewController then play the video
    func myVCDidFinish(controller: SelectVideoViewController, text: String) {
        self.path = text
        
        let player = AVPlayer(URL: NSURL(fileURLWithPath: path))
        
        playerController.view.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: scrollView.frame.width)
        playerController.player = player
        // DISABLE ALL THE USER INTERACITON, INCLUDING THE PINCH GESTURE
        // THIS WAY, THE VIDEO CAN BE ZOOMED LIKE AN IMAGE
        // HOWEVER NEED TO IMPLEMENT ALL THE BUTTONS OUTSIDE
        // THE VIDEO PLAYER
        playerController.view.userInteractionEnabled = false
        playerController.showsPlaybackControls = false
        
        self.addChildViewController(playerController)
        
        self.view.addSubview(scrollView)
        scrollView.addSubview(playerController.view)
        
        controller.navigationController?.popViewControllerAnimated(true)
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.scrollView.subviews[0]
    }
    
    func showImage(controller: SelectImageVC, path: String) {
        self.path = path
        
        let image = UIImage(contentsOfFile: path)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 0, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.width)
        
        self.view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        
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

    @IBAction func goToSelectImage(sender: UIButton) {
        let vc = SelectImageSVC()
        //vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
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