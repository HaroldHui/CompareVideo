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

class ViewController: UIViewController, SelectionDelegate, UIScrollViewDelegate {
    
    // ------------------- VARIABLES FOR INIT --------------------
    var dashboard: Dashboard = Dashboard()
    var category: Category = Category()
    var act: Act = Act()
    var level: Level = Level()
    var video: Video = Video()
    var picture: Picture = Picture()
    
    // URL path for any video or image
    var path = ""
    
    // Scroll View for two videos' view
    var sview1 = UIScrollView()
    var sview2 = UIScrollView()
    
    // two video view controllers
    var player1vc = AVPlayerViewController?()
    var player2vc = AVPlayerViewController?()
    
    // two video players
    var player1 = AVPlayer?()
    var player2 = AVPlayer?()
    
    // -------------------- FUNCTIONS --------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // loading the ui scroll views
        self.sview1.delegate = self
        self.sview1.minimumZoomScale = 1.0
        self.sview1.maximumZoomScale = 10.0
        
        self.view.addSubview(self.sview1)
        
        self.sview2.delegate = self
        self.sview2.minimumZoomScale = 1.0
        self.sview2.maximumZoomScale = 10.0
        
        self.view.addSubview(self.sview2)
        
        displaySelectionButtons()
    }
    
    // this function adds the a new UIScrollView and a new video controller
    // based on the given path (URL) from the selection page
    // also, it removes the previous UIScrollView and video controller if there existed
    func myVCDidFinish(controller: UIViewController, path: String) {
        self.path = path
        
        // if a uiscrollview already exists, remove it first
        // then add a new one
        self.sview1.removeFromSuperview()
        
        self.sview1 = UIScrollView()
        
        self.sview1.delegate = self
        self.sview1.minimumZoomScale = 1.0
        self.sview1.maximumZoomScale = 10.0

        self.view.addSubview(self.sview1)
        
        // rect for draw tools
        var rect1: CGRect
        
        // if there is no video on the right side, show it wide
        // otherwise, divie the view
        if player2vc == nil {
            self.sview1.frame = CGRect(x: 10, y: 125, width: self.view.frame.width-20, height: self.view.frame.width/2)
            if let viewWithTag = self.view.viewWithTag(101) {
                viewWithTag.removeFromSuperview()
            }
            rect1 = CGRect(x: 10, y: 125, width: self.view.frame.width-20, height: self.view.frame.width/2)
        } else {
            self.sview1.frame = CGRect(x: 10, y: 125, width: (self.view.frame.width/2)-15, height: self.view.frame.width/2)
            // update the frame of the ui scroll view, labels, and ui slider
            self.sview2.frame = CGRect(x: (self.view.frame.width/2)+5, y: 125, width: (self.view.frame.width/2)-15, height: self.view.frame.width/2)
            self.timeElapsedLabel2.frame = CGRect(x: self.sview2.frame.origin.x, y: 650, width: self.labelWidth, height: 30)
            self.seekSlider2.frame = CGRect(x: self.timeElapsedLabel2.frame.origin.x + self.labelWidth,
                                            y: 650, width: self.sview2.bounds.size.width - self.labelWidth - self.labelWidth, height: 30)
            self.timeRemainingLabel2.frame = CGRect(x: self.seekSlider2.frame.origin.x + self.seekSlider2.bounds.size.width, y: 650, width: self.labelWidth, height: 30)

            rect1 = CGRect(x: 10, y: 125, width: (self.view.frame.width/2)-15, height: self.view.frame.width/2)
            self.displayPlayBothButton()
        }
        
        // draw start
        
        if let viewWithTag = self.view.viewWithTag(101) {
            viewWithTag.removeFromSuperview()
        }
        createImageView1(rect1)
        self.view.addSubview(imageView1)
//        self.sview1.userInteractionEnabled = false

        if player2vc != nil  {
          let rect2 = CGRect(x: (self.view.frame.width/2)+5, y: 125, width: (self.view.frame.width/2)-15, height: self.view.frame.width/2)
          if let viewWithTag = self.view.viewWithTag(102) {
                viewWithTag.removeFromSuperview()
            }
            createImageView2(rect2)
            self.view.addSubview(imageView2)
//            self.sview2.userInteractionEnabled = false

        }
        
        // draw end
        
        // if a video view controller already exists, remove it first
        player1vc?.removeFromParentViewController()
        player1vc?.view.removeFromSuperview()
        
        self.player1 = AVPlayer(URL: NSURL(fileURLWithPath: path))
        
        // player's time
        let timeInterval: CMTime = CMTimeMakeWithSeconds(1.0, 10)
        timeObserver1 = self.player1!.addPeriodicTimeObserverForInterval(timeInterval,
                                                                   queue: dispatch_get_main_queue()) { (elapsedTime: CMTime) -> Void in
                                                                    
                                                                    //print("elapsedTime now:", CMTimeGetSeconds(elapsedTime))
                                                                    self.observeTime(elapsedTime, player: self.player1!, timeElapsedLabel: self.timeElapsedLabel1, timeRemainingLabel: self.timeRemainingLabel1)
        }
        
        // notification when the video has ended
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.player1DidFinishPlaying(_:)),
                                                         name: AVPlayerItemDidPlayToEndTimeNotification, object: player1!.currentItem)
        
        self.player1vc = AVPlayerViewController()
        
        self.player1vc!.player = self.player1!
        self.player1vc!.view.frame = CGRect(x: 0, y: 0, width: self.sview1.frame.width, height: self.sview1.frame.height)
        
        // disable user interaction for enabling the zoom in/out feature
        self.player1vc!.view.userInteractionEnabled = false
        self.player1vc!.showsPlaybackControls = false
        
        self.addChildViewController(self.player1vc!)
        self.sview1.addSubview(self.player1vc!.view)
        
        self.displayVideo1Buttons()

    }
    
//    func showImage(controller: SelectImageVC, path: String) {
//        self.path = path
//        
//        let image = UIImage(contentsOfFile: path)
//        let imageView = UIImageView(image: image!)
//        imageView.frame = CGRect(x: 0, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.width)
//        
//        self.view.addSubview(scrollView)
//        scrollView.addSubview(imageView)
//        
//        controller.navigationController?.popViewControllerAnimated(true)
//    }
    
    // when video 1 has finished playing to end
    func player1DidFinishPlaying(note: NSNotification) {
        video1State = 2
        playButton1.setTitle("Replay", forState: .Normal)
        playButton1.titleLabel!.text = "Replay"
    }
    
    // when video 2 has finished playing to end
    func player2DidFinishPlaying(note: NSNotification) {
        video2State = 2
        playButton2.setTitle("Replay", forState: .Normal)
        playButton2.titleLabel!.text = "Replay"
    }
    
    // zooming video
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return scrollView.subviews[0]
    }
    
    // "Select from Cloud" button leading to Selection Page
    func goToSelectionPage(sender: UIButton) {
        let svc = SelectImageSVC();
        svc.sDelegate = self
        self.navigationController?.presentViewController(svc, animated: true, completion: nil)
    }
    
    // "Select from Local" button leading to local video library
    func selectLocalVideo(sender: UIButton) {
        startMediaBrowserFromViewController(self, usingDelegate: self)
    }
    
    // browsing local videos
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
                // if a uiscrollview already exists, remove it first
                // then add a new one
                self.sview2.removeFromSuperview()
                
                self.sview2 = UIScrollView()
                
                self.sview2.delegate = self
                self.sview2.minimumZoomScale = 1.0
                self.sview2.maximumZoomScale = 10.0
                
                self.view.addSubview(self.sview2)

                // rect for draw tools
                var rect1: CGRect

                // if there is no video on the left side, show it wide
                // otherwise, divide the view
                if self.player1vc == nil {
                    self.sview2.frame = CGRect(x: 10, y: 125, width: self.view.frame.width-20, height: self.view.frame.width/2)
                    rect1 = CGRect(x: 10, y: 125, width: self.view.frame.width-20, height: self.view.frame.width/2)
                } else {
                    // update the frame of the ui scroll view, labels, and ui slider
                    self.sview1.frame = CGRect(x: 10, y: 125, width: (self.view.frame.width/2)-15, height: self.view.frame.width/2)
                    self.timeElapsedLabel1.frame = CGRect(x: self.sview1.frame.origin.x, y: 650, width: self.labelWidth, height: 30)
                    self.seekSlider1.frame = CGRect(x: self.timeElapsedLabel1.frame.origin.x + self.labelWidth,
                                               y: 650, width: self.sview1.bounds.size.width - self.labelWidth - self.labelWidth, height: 30)
                    self.timeRemainingLabel1.frame = CGRect(x: self.seekSlider1.frame.origin.x + self.seekSlider1.bounds.size.width, y: 650, width: self.labelWidth, height: 30)
                    self.sview2.frame = CGRect(x: (self.view.frame.width/2)+5, y: 125, width: (self.view.frame.width/2)-15, height: self.view.frame.width/2)
                    self.displayPlayBothButton()
                    rect1 = CGRect(x: 10, y: 125, width: (self.view.frame.width/2)-15, height: self.view.frame.width/2)
                }
                
                // draw start
                
                if let viewWithTag = self.view.viewWithTag(101) {
                    viewWithTag.removeFromSuperview()
                }
                self.createImageView1(rect1)
                self.view.addSubview(self.imageView1)
//                self.sview2.userInteractionEnabled = false
                
                if self.player1vc != nil  {
                    let rect2 = CGRect(x: (self.view.frame.width/2)+5, y: 125, width: (self.view.frame.width/2)-15, height: self.view.frame.width/2)
                    if let viewWithTag = self.view.viewWithTag(102) {
                        viewWithTag.removeFromSuperview()
                    }
                    self.createImageView2(rect2)
                    self.view.addSubview(self.imageView2)
//                    self.sview1.userInteractionEnabled = false
                    
                }
                
                // draw end
                
                // if a video view controller already exists, remove it first
                self.player2vc?.removeFromParentViewController()
                self.player2vc?.view.removeFromSuperview()
                
                self.player2 = AVPlayer(URL: info[UIImagePickerControllerMediaURL] as! NSURL)
                
                // player's time
                let timeInterval: CMTime = CMTimeMakeWithSeconds(1.0, 10)
                self.timeObserver2 = self.player2!.addPeriodicTimeObserverForInterval(timeInterval,
                                                                                queue: dispatch_get_main_queue()) { (elapsedTime: CMTime) -> Void in
                                                                                    
                                                                                    //print("elapsedTime now:", CMTimeGetSeconds(elapsedTime))
                                                                                    self.observeTime(elapsedTime, player: self.player2!, timeElapsedLabel: self.timeElapsedLabel2, timeRemainingLabel: self.timeRemainingLabel2)
                }
                
                // notification when the video has ended
                NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.player2DidFinishPlaying(_:)),
                                                                 name: AVPlayerItemDidPlayToEndTimeNotification, object: self.player2!.currentItem)
                
                self.player2vc = AVPlayerViewController()
                
                self.player2vc!.player = self.player2!
                self.player2vc!.view.frame = CGRect(x: 0, y: 0, width: self.sview2.frame.width, height: self.sview2.frame.height)
                
                // disable user interaction for enabling the zoom in/out feature
                self.player2vc!.view.userInteractionEnabled = false
                self.player2vc!.showsPlaybackControls = false
                
                self.addChildViewController(self.player2vc!)
                self.sview2.addSubview(self.player2vc!.view)
                
                self.displayVideo2Buttons()

            }
        }
    }
    
    // Functions for updating the time for the videos
    func updateTimeLabel(elapsedTime elapsedTime: Float64, duration: Float64, player: AVPlayer, timeElapsedLabel: UILabel, timeRemainingLabel: UILabel) {
        let timeRemaining: Float64 = CMTimeGetSeconds(player.currentItem!.duration) - elapsedTime
        timeElapsedLabel.text = String(format: "%02d:%02d", ((lround(elapsedTime) / 60) % 60), lround(elapsedTime) % 60)
        timeRemainingLabel.text = String(format: "%02d:%02d", ((lround(timeRemaining) / 60) % 60), lround(timeRemaining) % 60)
        
        // also updating the slider value to follow the elapsed time
        let sliderValue = elapsedTime/CMTimeGetSeconds(player.currentItem!.duration)
        let floatValue = Float(sliderValue)
        if player == player1 {
            seekSlider1.setValue(floatValue, animated: true)
        } else if player == player2 {
            seekSlider2.setValue(floatValue, animated: true)
        }
    }
    
    // Function to observe the video time
    func observeTime(elapsedTime: CMTime, player: AVPlayer, timeElapsedLabel: UILabel, timeRemainingLabel: UILabel) {
        let duration = CMTimeGetSeconds(player.currentItem!.duration)
        if isfinite(duration) {
            let elapsedTime = CMTimeGetSeconds(elapsedTime)
            updateTimeLabel(elapsedTime: elapsedTime, duration: duration, player: player, timeElapsedLabel: timeElapsedLabel, timeRemainingLabel: timeRemainingLabel)
        }
    }
    
    // Functions for the slider 1 tracking
    // when the user starts to touch slider 1 to seek the preferred time
    func slider1BeganTracking(slider: UISlider) {
        player1RateBeforeSeek = player1!.rate
        player1?.pause()
    }
    
    // when the user has decided on the preferred time and release the finger
    func slider1EndedTracking(slider: UISlider) {
        let videoDuration = CMTimeGetSeconds(player1!.currentItem!.duration)
        let elapsedTime: Float64 = videoDuration * Float64(seekSlider1.value)
        updateTimeLabel(elapsedTime: elapsedTime, duration: videoDuration, player: self.player1!, timeElapsedLabel: self.timeElapsedLabel1, timeRemainingLabel: self.timeRemainingLabel1)
        
        player1!.seekToTime(CMTimeMakeWithSeconds(elapsedTime, 100)) { (completed: Bool) -> Void in
            if self.player1RateBeforeSeek > 0 {
                self.player1?.play()
            }
        }
    }
    
    // when the value of the slider gets changed, video 1 will follow accordingly
    func slider1ValueChanged(slider: UISlider) {
        let videoDuration = CMTimeGetSeconds(player1!.currentItem!.duration)
        let elapsedTime: Float64 = videoDuration * Float64(seekSlider1.value)
        updateTimeLabel(elapsedTime: elapsedTime, duration: videoDuration, player: self.player1!, timeElapsedLabel: self.timeElapsedLabel1, timeRemainingLabel: self.timeRemainingLabel1)
    }
    
    // Functions for the slider 2 tracking
    // when the user starts to touch slider 2 to seek the preferred time
    func slider2BeganTracking(slider: UISlider) {
        player2RateBeforeSeek = player2!.rate
        player2?.pause()
    }
    
    // when the user has decided on the preferred time and release the finger
    func slider2EndedTracking(slider: UISlider) {
        let videoDuration = CMTimeGetSeconds(player2!.currentItem!.duration)
        let elapsedTime: Float64 = videoDuration * Float64(seekSlider2.value)
        updateTimeLabel(elapsedTime: elapsedTime, duration: videoDuration, player: self.player2!, timeElapsedLabel: self.timeElapsedLabel2, timeRemainingLabel: self.timeRemainingLabel2)
        
        player2!.seekToTime(CMTimeMakeWithSeconds(elapsedTime, 100)) { (completed: Bool) -> Void in
            if self.player2RateBeforeSeek > 0 {
                self.player2?.play()
            }
        }
    }
    
    // when the value of slider 2 gets changed, video 2 will follow accordingly
    func slider2ValueChanged(slider: UISlider) {
        let videoDuration = CMTimeGetSeconds(player2!.currentItem!.duration)
        let elapsedTime: Float64 = videoDuration * Float64(seekSlider2.value)
        updateTimeLabel(elapsedTime: elapsedTime, duration: videoDuration, player: self.player2!, timeElapsedLabel: self.timeElapsedLabel2, timeRemainingLabel: self.timeRemainingLabel2)
    }
    
    // Video States
    // 0 : the video is paused
    // 1 : the video is played
    // 2 : the video has ended
    var video1State = 0
    var video2State = 0
    
    // Function for playing, pausing, and replaying a video
    func play(sender: UIButton) {
        // updating the state and the button text according to which video calls this function
        if sender.tag == 1 {
            if video1State == 0 {
                player1vc?.player?.play()
                video1State = 1
                sender.setTitle("Pause", forState: UIControlState.Normal)
                sender.titleLabel!.text = "Pause"
            } else if video1State == 1 {
                player1vc?.player?.pause()
                video1State = 0
                sender.setTitle("Play", forState: UIControlState.Normal)
                sender.titleLabel!.text = "Play"
            } else if video1State == 2 {
                player1vc?.player?.seekToTime(kCMTimeZero)
                player1vc?.player?.play()
                video1State = 1
                sender.setTitle("Pause", forState: UIControlState.Normal)
                sender.titleLabel!.text = "Pause"
            }
        } else if sender.tag == 2 {
            if video2State == 0 {
                player2vc?.player?.play()
                video2State = 1
                sender.setTitle("Pause", forState: UIControlState.Normal)
                sender.titleLabel!.text = "Pause"
            } else if video2State == 1 {
                player2vc?.player?.pause()
                video2State = 0
                sender.setTitle("Play", forState: UIControlState.Normal)
                sender.titleLabel!.text = "Play"
            } else if video2State == 2 {
                player2vc?.player?.seekToTime(kCMTimeZero)
                player2vc?.player?.play()
                video2State = 1
                sender.setTitle("Pause", forState: UIControlState.Normal)
                sender.titleLabel!.text = "Pause"
            }
        }
        
        
    }
    
    // Function for making the video slow motion (half rate)
    func slowmo(sender: UIButton) {
        if sender.tag == 1 {
            player1vc?.player!.rate = 0.5
        } else if sender.tag == 2 {
            player2vc?.player!.rate = 0.5
        }
    }
    
    func playBothVideo(sender: UIButton) {
        if (video1State == 0 || video2State == 0) {
            player1vc?.player?.play()
            player2vc?.player?.play()
            video1State = 1
            video2State = 1
            playButton1.setTitle("Pause", forState: UIControlState.Normal)
            playButton1.titleLabel!.text = "Pause"
            playButton2.setTitle("Pause", forState: UIControlState.Normal)
            playButton2.titleLabel!.text = "Pause"
            sender.setTitle("Pause Both", forState: UIControlState.Normal)
            sender.titleLabel!.text = "Pause Both"
        } else if (video1State == 1 || video2State == 1) {
            player1vc?.player?.pause()
            player2vc?.player?.pause()
            video1State = 0
            video2State = 0
            playButton1.setTitle("Play", forState: UIControlState.Normal)
            playButton1.titleLabel!.text = "Play"
            playButton2.setTitle("Play", forState: UIControlState.Normal)
            playButton2.titleLabel!.text = "Play"
            sender.setTitle("Play Both", forState: UIControlState.Normal)
            sender.titleLabel!.text = "Play Both"
        }
    }
    
    
    // -------------------- UI --------------------
    let labelWidth: CGFloat = 60
    let buttonWidth: CGFloat = 100
    
    var timeObserver1 : AnyObject!
    var player1RateBeforeSeek: Float = 0
    var timeElapsedLabel1 = UILabel()
    var timeRemainingLabel1 = UILabel()
    let seekSlider1 = UISlider()
    let playButton1 = UIButton()
    let slowmoButton1 = UIButton()
    let clearButton1 = UIButton()
    let enableButton1 = UIButton()
    
    
    var timeObserver2 : AnyObject!
    var player2RateBeforeSeek: Float = 0
    var timeElapsedLabel2 = UILabel()
    var timeRemainingLabel2 = UILabel()
    let seekSlider2 = UISlider()
    let playButton2 = UIButton()
    let slowmoButton2 = UIButton()
    let clearButton2 = UIButton()
    let enableButton2 = UIButton()

    
    let playBothButton = UIButton()
    
    func displaySelectionButtons() {
        // Button for Select Cloud Video or Image
        let selectCloudButton = UIButton(frame: CGRect(x: 10, y: 75, width: 150, height: 25))
        selectCloudButton.setTitle("Select from Cloud", forState: UIControlState.Normal)
        selectCloudButton.titleLabel!.text = "Select from Cloud"
        selectCloudButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        selectCloudButton.addTarget(self, action: #selector(ViewController.goToSelectionPage(_:)), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(selectCloudButton)
        
        // Button for Select Local Video
        let selectLocalButton = UIButton(frame: CGRect(x: 10+self.view.frame.size.width/2, y: 75, width: 150, height: 25))
        selectLocalButton.setTitle("Select from Local", forState: UIControlState.Normal)
        selectLocalButton.titleLabel!.text = "Select from Local"
        selectLocalButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        selectLocalButton.addTarget(self, action: #selector(ViewController.selectLocalVideo(_:)), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(selectLocalButton)
    }
    
    // Displaying buttons and controller for video 1
    func displayVideo1Buttons() {
        // time elapsed label
        timeElapsedLabel1.frame = CGRect(x: self.sview1.frame.origin.x, y: 650, width: labelWidth, height: 30)
        timeElapsedLabel1.textColor = UIColor.blackColor()
        if !timeElapsedLabel1.isDescendantOfView(self.view) {
            self.view.addSubview(timeElapsedLabel1)
        }
        
        // UI slider for tracking video time
        if !seekSlider1.isDescendantOfView(self.view) {
            self.view.addSubview(seekSlider1)
        }
        seekSlider1.addTarget(self, action: #selector(slider1BeganTracking),
                             forControlEvents: .TouchDown)
        seekSlider1.addTarget(self, action: #selector(slider1EndedTracking),
                             forControlEvents: [.TouchUpInside, .TouchUpOutside])
        seekSlider1.addTarget(self, action: #selector(slider1ValueChanged),
                             forControlEvents: .ValueChanged)
        seekSlider1.frame = CGRect(x: timeElapsedLabel1.frame.origin.x + labelWidth,
                                  y: 650, width: sview1.bounds.size.width - labelWidth - labelWidth, height: 30)
        
        // time remaining label
        timeRemainingLabel1.frame = CGRect(x: seekSlider1.frame.origin.x + seekSlider1.bounds.size.width, y: 650, width: labelWidth, height: 30)
        timeRemainingLabel1.textColor = UIColor.blackColor()
        if !timeRemainingLabel1.isDescendantOfView(self.view) {
            self.view.addSubview(timeRemainingLabel1)
        }
        
        // play/pause/replay button
        playButton1.frame = CGRect(x: 10, y: 700, width: buttonWidth, height: 50)
        playButton1.setTitle("Play", forState: UIControlState.Normal)
        playButton1.titleLabel?.text = "Play"
        playButton1.setTitleColor(UIColor.blackColor(), forState: .Normal)
        playButton1.tag = 1
        playButton1.addTarget(self, action: #selector(self.play(_:)), forControlEvents: .TouchUpInside)
        if !playButton1.isDescendantOfView(self.view) {
            self.view.addSubview(playButton1)
        }
        
        // slow-mo button
        slowmoButton1.frame = CGRect(x: 120, y: 700, width: buttonWidth, height: 50)
        slowmoButton1.setTitle("Slow-Mo", forState: UIControlState.Normal)
        slowmoButton1.titleLabel?.text = "Slow-Mo"
        slowmoButton1.setTitleColor(UIColor.blackColor(), forState: .Normal)
        slowmoButton1.tag = 1
        slowmoButton1.addTarget(self, action: #selector(self.slowmo(_:)), forControlEvents: .TouchUpInside)
        if !slowmoButton1.isDescendantOfView(self.view) {
            self.view.addSubview(slowmoButton1)
        }
        // clear button
        clearButton1.frame = CGRect(x: 230, y: 700, width: buttonWidth, height: 50)
        clearButton1.setTitle("Clear", forState: UIControlState.Normal)
        clearButton1.titleLabel?.text = "Clear"
        clearButton1.setTitleColor(UIColor.blackColor(), forState: .Normal)
        clearButton1.tag = 1
        clearButton1.addTarget(self, action: #selector(clearImage1), forControlEvents: .TouchUpInside)
        if !clearButton1.isDescendantOfView(self.view) {
            self.view.addSubview(clearButton1)
        }
        // enable button
        enableButton1.frame = CGRect(x: 330, y: 700, width: buttonWidth, height: 50)
        enableButton1.setTitle("Draw", forState: UIControlState.Normal)
        enableButton1.titleLabel?.text = "Draw"
        enableButton1.setTitleColor(UIColor.blackColor(), forState: .Normal)
        enableButton1.tag = 1
        enableButton1.addTarget(self, action: #selector(enableImage1), forControlEvents: .TouchUpInside)
        if !enableButton1.isDescendantOfView(self.view) {
            self.view.addSubview(enableButton1)
        }

    }
    
    func clearImage1(sender: UIButton!){
        self.imageView1.image = nil
    }
    func enableImage1(sender: UIButton!){
        if  sender.currentTitle == "Draw" {
            sender.setTitle("Zoom", forState: .Normal)
            self.sview1.userInteractionEnabled = false
        }else{
            sender.setTitle("Draw", forState: .Normal)
            self.sview1.userInteractionEnabled = true
        }
    }
    
    // Displaying buttons and controller for video 2
    func displayVideo2Buttons() {
        // time elapsed label
        timeElapsedLabel2.frame = CGRect(x: self.sview2.frame.origin.x, y: 650, width: labelWidth, height: 30)
        timeElapsedLabel2.textColor = UIColor.blackColor()
        if !timeElapsedLabel2.isDescendantOfView(self.view) {
            self.view.addSubview(timeElapsedLabel2)
        }
        
        // UI slider
        if !seekSlider2.isDescendantOfView(self.view) {
            self.view.addSubview(seekSlider2)
        }
        seekSlider2.addTarget(self, action: #selector(slider2BeganTracking),
                              forControlEvents: .TouchDown)
        seekSlider2.addTarget(self, action: #selector(slider2EndedTracking),
                              forControlEvents: [.TouchUpInside, .TouchUpOutside])
        seekSlider2.addTarget(self, action: #selector(slider2ValueChanged),
                              forControlEvents: .ValueChanged)
        seekSlider2.frame = CGRect(x: timeElapsedLabel2.frame.origin.x + labelWidth,
                                   y: 650, width: sview2.bounds.size.width - labelWidth - labelWidth, height: 30)
        
        //  time remaining label
        timeRemainingLabel2.frame = CGRect(x: seekSlider2.frame.origin.x + seekSlider2.bounds.size.width, y: 650, width: labelWidth, height: 30)
        timeRemainingLabel2.textColor = UIColor.blackColor()
        if !timeRemainingLabel2.isDescendantOfView(self.view){
            self.view.addSubview(timeRemainingLabel2)
        }
        
        // play/pause/replay button
        playButton2.frame = CGRect(x: 580, y: 700, width: buttonWidth, height: 50)
        playButton2.setTitle("Play", forState: UIControlState.Normal)
        playButton2.titleLabel?.text = "Play"
        playButton2.setTitleColor(UIColor.blackColor(), forState: .Normal)
        playButton2.tag = 2
        playButton2.addTarget(self, action: #selector(self.play(_:)), forControlEvents: .TouchUpInside)
        if !playButton2.isDescendantOfView(self.view) {
            self.view.addSubview(playButton2)
        }
        
        // slow-mo button
        slowmoButton2.frame = CGRect(x: 690, y: 700, width: buttonWidth, height: 50)
        slowmoButton2.setTitle("Slow-Mo", forState: UIControlState.Normal)
        slowmoButton2.titleLabel?.text = "Slow-Mo"
        slowmoButton2.setTitleColor(UIColor.blackColor(), forState: .Normal)
        slowmoButton2.tag = 2
        slowmoButton2.addTarget(self, action: #selector(self.slowmo(_:)), forControlEvents: .TouchUpInside)
        if !slowmoButton2.isDescendantOfView(self.view) {
            self.view.addSubview(slowmoButton2)
        }
        
        // clear button
        clearButton2.frame = CGRect(x: 800, y: 700, width: buttonWidth, height: 50)
        clearButton2.setTitle("Clear", forState: UIControlState.Normal)
        clearButton2.titleLabel?.text = "Clear"
        clearButton2.setTitleColor(UIColor.blackColor(), forState: .Normal)
        clearButton2.tag = 1
        clearButton2.addTarget(self, action: #selector(clearImage2), forControlEvents: .TouchUpInside)
        if !clearButton2.isDescendantOfView(self.view) {
            self.view.addSubview(clearButton2)
        }
        // enable button
        enableButton2.frame = CGRect(x: 910, y: 700, width: buttonWidth, height: 50)
        enableButton2.setTitle("Draw", forState: UIControlState.Normal)
        enableButton2.titleLabel?.text = "Draw"
        enableButton2.setTitleColor(UIColor.blackColor(), forState: .Normal)
        enableButton2.tag = 1
        enableButton2.addTarget(self, action: #selector(enableImage2), forControlEvents: .TouchUpInside)
        if !enableButton2.isDescendantOfView(self.view) {
            self.view.addSubview(enableButton2)
        }

    }
    
    // Displaying button for playing/pausing both videos at the same time
    func displayPlayBothButton() {
        playBothButton.frame = CGRect(x: 450, y: 700, width: buttonWidth, height: 50)
        playBothButton.setTitle("Play Both", forState: UIControlState.Normal)
        playBothButton.titleLabel?.text = "Play Both"
        playBothButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        playBothButton.addTarget(self, action: #selector(self.playBothVideo(_:)), forControlEvents: .TouchUpInside)
        if !playBothButton.isDescendantOfView(self.view) {
            self.view.addSubview(playBothButton)
        }
        
    }
    func clearImage2(sender: UIButton!){
        if player1vc == nil{
            self.imageView1.image = nil
        }else{
            self.imageView2.image = nil
        }
    }
    func enableImage2(sender: UIButton!){
//        if player1vc == nil{
//            print(1)
            if  sender.currentTitle == "Draw" {
                sender.setTitle("Zoom", forState: .Normal)
                self.sview2.userInteractionEnabled = false
            }else{
                sender.setTitle("Draw", forState: .Normal)
                self.sview2.userInteractionEnabled = true
            }
//        }else{
//            print(2)
//            if  sender.currentTitle == "Enable" {
//                sender.setTitle("Disable", forState: .Normal)
//                self.sview1.userInteractionEnabled = false
//            }else{
//                sender.setTitle("Enable", forState: .Normal)
//                self.sview1.userInteractionEnabled = true
//            }
//        }

    }
    
    
    // draw
    var finalPoint1: CGPoint!
    var finalPoint2: CGPoint!
    var isDrawing: Bool!
    var lineWidth: CGFloat = 4.0
    
    let red: CGFloat = 50.0/255.0
    let green: CGFloat = 50.0/255.0
    let blue: CGFloat = 50.0/255.0
    
    private var imageView1: UIImageView!
    private var imageView2: UIImageView!
    

    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        isDrawing = false
        if let touch = touches.first {
            finalPoint1 = touch.preciseLocationInView(imageView1)
            finalPoint2 = touch.preciseLocationInView(imageView2)
        }
    }
    
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        isDrawing = true
        if let touch = touches.first{
            if let boardImageView = imageView1 {
                let currentCoordinate = touch.preciseLocationInView(boardImageView)
                UIGraphicsBeginImageContext(boardImageView.frame.size)
                boardImageView.image?.drawInRect(CGRectMake(0, 0, boardImageView.frame.size.width, boardImageView.frame.size.height))
                CGContextMoveToPoint(UIGraphicsGetCurrentContext()!, finalPoint1.x, finalPoint1.y)
                CGContextAddLineToPoint(UIGraphicsGetCurrentContext()!, currentCoordinate.x,currentCoordinate.y)
                CGContextSetLineCap(UIGraphicsGetCurrentContext()!, CGLineCap.Round)
                CGContextSetLineWidth(UIGraphicsGetCurrentContext()!, lineWidth)
                CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext()!, red, green, blue, 1.0)
                CGContextStrokePath(UIGraphicsGetCurrentContext()!)
                boardImageView.image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                finalPoint1 = currentCoordinate
            }
            if let boardImageView = imageView2 {
                let currentCoordinate = touch.preciseLocationInView(boardImageView)
                UIGraphicsBeginImageContext(boardImageView.frame.size)
                boardImageView.image?.drawInRect(CGRectMake(0, 0, boardImageView.frame.size.width, boardImageView.frame.size.height))
                CGContextMoveToPoint(UIGraphicsGetCurrentContext()!, finalPoint2.x, finalPoint2.y)
                CGContextAddLineToPoint(UIGraphicsGetCurrentContext()!, currentCoordinate.x,currentCoordinate.y)
                CGContextSetLineCap(UIGraphicsGetCurrentContext()!, CGLineCap.Round)
                CGContextSetLineWidth(UIGraphicsGetCurrentContext()!, lineWidth)
                CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext()!, red, green, blue, 1.0)
                CGContextStrokePath(UIGraphicsGetCurrentContext()!)
                boardImageView.image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                finalPoint2 = currentCoordinate
            }

        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if(!isDrawing){
            if let boardImageView = imageView1 {
                UIGraphicsBeginImageContext(boardImageView.frame.size)
                boardImageView.image?.drawInRect(CGRectMake(0, 0, boardImageView.frame.size.width, boardImageView.frame.size.height))
                CGContextMoveToPoint(UIGraphicsGetCurrentContext()!, finalPoint1.x, finalPoint1.y)
                CGContextAddLineToPoint(UIGraphicsGetCurrentContext()!, finalPoint1.x,finalPoint1.y)
                CGContextSetLineCap(UIGraphicsGetCurrentContext()!, CGLineCap.Round)
                CGContextSetLineWidth(UIGraphicsGetCurrentContext()!, lineWidth)
                CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext()!, red, green, blue, 1.0)
                CGContextStrokePath(UIGraphicsGetCurrentContext()!)
                boardImageView.image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
            }
            if let boardImageView = imageView2 {
                UIGraphicsBeginImageContext(boardImageView.frame.size)
                boardImageView.image?.drawInRect(CGRectMake(0, 0, boardImageView.frame.size.width, boardImageView.frame.size.height))
                CGContextMoveToPoint(UIGraphicsGetCurrentContext()!, finalPoint2.x, finalPoint2.y)
                CGContextAddLineToPoint(UIGraphicsGetCurrentContext()!, finalPoint2.x,finalPoint2.y)
                CGContextSetLineCap(UIGraphicsGetCurrentContext()!, CGLineCap.Round)
                CGContextSetLineWidth(UIGraphicsGetCurrentContext()!, lineWidth)
                CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext()!, red, green, blue, 1.0)
                CGContextStrokePath(UIGraphicsGetCurrentContext()!)
                boardImageView.image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
            }

        }
    }
    
    private func createImageView1(rect: CGRect){
        imageView1 = UIImageView()
        imageView1.frame = rect
        imageView1.tag = 101
    }
    private func createImageView2(rect: CGRect){
        imageView2 = UIImageView()
        imageView2.frame = rect
        imageView2.tag = 102
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
