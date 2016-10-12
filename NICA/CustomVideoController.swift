//
//  CustomVideoController.swift
//  NICA
//
//  Created by Johan Albert on 28/09/2016.
//  Copyright © 2016 Johan Albert. All rights reserved.
//

import UIKit
import AVFoundation

class CustomVideoController: UIViewController, UIScrollViewDelegate {
    
    // constants
    let BUTTON_WIDTH: CGFloat = 40
    let BUTTON_HEIGHT: CGFloat = 40
    
    // images
    let playButtonImage = UIImage(named: "play_button.png")
    let pauseButtonImage = UIImage(named: "pause_button.png")
    let replayButtonImage = UIImage(named: "replay_button.png")
    let eraserButtonImage = UIImage(named: "eraser_button.png")
    let drawButtonImage = UIImage(named: "pencil_icon.png")
    let drawButtonImage2 = UIImage(named: "pencil_icon_gray.png")
    
    var urlPath: NSURL!
    var container: UIView?
    
    // the video player
    let player = AVPlayer()
    var playerLayer: AVPlayerLayer!
    let playerContainer = UIView()
    let controllerContainer = UIView()
    let drawContainer = UIView()
    
    // the video controller
    // views
    let sView = UIScrollView()
    var dView: UIImageView!
    // buttons
    let playButton = UIButton()
    let slowmoButton = UIButton()
    let drawButton = UIButton()
    let clearButton = UIButton()
    let seekSlider = UISlider()
    let volumeSlider = UISlider()
    // variables
    let timeElapLabel = UILabel()
    let timeRemLabel = UILabel()
    var timeObserver: AnyObject!
    var playerRateTemp: Float = 0
    /* Video States
     * 0 : the video is paused
     * 1 : the video is played
     * 2 : the video has ended
     */
    var videoState = 0
    // slow motion value
    var slowmotion = false
    // drawing tool
    var drawenabled = false
    
    // Initialization function
    init(urlPath: NSURL?, container: UIView?) {
        self.urlPath = urlPath
        self.container = container
        self.dView = UIImageView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.dView = UIImageView()
        super.init(coder: aDecoder)
    }
    
    // This function is called when whe view successfully loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(sView)
        sView.frame = CGRect(x: 0,
                             y: 0,
                             width: container!.frame.width,
                             height: container!.frame.height)
        sView.delegate = self
        sView.minimumZoomScale = 1.0
        sView.maximumZoomScale = 10.0
        sView.showsVerticalScrollIndicator = false
        sView.showsHorizontalScrollIndicator = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleControllers))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.cancelsTouchesInView = false
        
        sView.addGestureRecognizer(tapGesture)
        
        sView.addSubview(playerContainer)
        playerContainer.frame = CGRect(x: 0,
                                       y: 0,
                                       width: sView.frame.width,
                                       height: sView.frame.height)
        
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = CGRect(x: 0,
                                   y: 0,
                                   width: sView.frame.width,
                                   height: sView.frame.height)
        playerContainer.layer.insertSublayer(playerLayer, atIndex: 0)
        
        let playerItem = AVPlayerItem(URL: urlPath!)
        player.replaceCurrentItemWithPlayerItem(playerItem)
        
        // Controlling video player's timer
        let timeInterval: CMTime = CMTimeMakeWithSeconds(1.0, 10)
        timeObserver = player.addPeriodicTimeObserverForInterval(timeInterval,
                                                                 queue: dispatch_get_main_queue()) { (elapsedTime: CMTime) -> Void in
                                                                    self.observeTime(elapsedTime)
        }
        
        // Notification when the video has ended
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.playerDidFinishPlaying(_:)),
                                                         name: AVPlayerItemDidPlayToEndTimeNotification, object: player.currentItem)
        
        view.addSubview(dView!)
        dView!.frame = CGRect(x: 0,
                              y: 0,
                              width: sView.frame.width,
                              height: sView.frame.height)
        
        // controller view
        // it can be hidden and displayed
        view.addSubview(controllerContainer)
        controllerContainer.hidden = false
        controllerContainer.frame = CGRect(x: 0,
                                           y: sView.frame.height-BUTTON_HEIGHT,
                                           width: sView.frame.width,
                                           height: BUTTON_HEIGHT)
        controllerContainer.backgroundColor = UIColor(white: 1, alpha: 0.7)
        
        // Play/pause/replay button
        controllerContainer.addSubview(playButton)
        playButton.setImage(playButtonImage, forState: .Normal)
        playButton.frame = CGRect(x: 0,
                                  y: 0,
                                  width: BUTTON_WIDTH,
                                  height: BUTTON_HEIGHT)
        playButton.addTarget(self, action: #selector(self.play(_:)), forControlEvents: .TouchUpInside)
        
        // Slow motion button
        controllerContainer.addSubview(slowmoButton)
        slowmoButton.setTitle("0.5x", forState: .Normal)
        slowmoButton.titleLabel!.text = "0.5x"
        slowmoButton.backgroundColor = .whiteColor()
        slowmoButton.setTitleColor(.blackColor(), forState: .Normal)
        slowmoButton.layer.cornerRadius = 5
        slowmoButton.layer.borderWidth = 1
        slowmoButton.layer.borderColor = UIColor.blackColor().CGColor
        slowmoButton.frame = CGRect(x: playButton.frame.width + 5,
                                    y: 0,
                                    width: BUTTON_WIDTH,
                                    height: BUTTON_HEIGHT)
        slowmoButton.addTarget(self, action: #selector(slowmo(_:)), forControlEvents: .TouchUpInside)
        
        // Time elapsed label
        controllerContainer.addSubview(timeElapLabel)
        timeElapLabel.frame = CGRect(x: playButton.frame.width + slowmoButton.frame.width + 5,
                                     y: 0,
                                     width: BUTTON_WIDTH,
                                     height: BUTTON_HEIGHT)
        timeElapLabel.adjustsFontSizeToFitWidth = true
        timeElapLabel.numberOfLines = 1
        timeElapLabel.text = String(format: "%02d:%02d", 0, 0)
        timeElapLabel.textColor = .blackColor()
        // Volume adjuster
       // controllerContainer.addSubview(volumeSlider)
        volumeSlider.frame = CGRect(x: UIScreen.mainScreen().bounds.width-playButton.frame.width - (controllerContainer.frame.width - 4*BUTTON_WIDTH - 5)/3,
                                  y: 20,
                                  width: (controllerContainer.frame.width - 4*BUTTON_WIDTH - 5)/3,
                                  height: BUTTON_HEIGHT)

        // Time seeker
        controllerContainer.addSubview(seekSlider)
        seekSlider.frame = CGRect(x: playButton.frame.width + slowmoButton.frame.width + timeElapLabel.frame.width + 5,
                                  y: 0,
                                  width: controllerContainer.frame.width - 4*BUTTON_WIDTH - 5,
                                  height: BUTTON_HEIGHT)
        seekSlider.addTarget(self, action: #selector(sliderBeganTracking),
                             forControlEvents: .TouchDown)
        seekSlider.addTarget(self, action: #selector(sliderEndedTracking),
                             forControlEvents: [.TouchUpInside, .TouchUpOutside])
        seekSlider.addTarget(self, action: #selector(sliderValueChanged),
                             forControlEvents: .ValueChanged)
        
        // Time remaining label
        controllerContainer.addSubview(timeRemLabel)
        timeRemLabel.frame = CGRect(x: playButton.frame.width + slowmoButton.frame.width + timeElapLabel.frame.width + seekSlider.frame.width + 5,
                                    y: 0,
                                    width: BUTTON_WIDTH,
                                    height: BUTTON_HEIGHT)
        timeRemLabel.adjustsFontSizeToFitWidth = true
        timeRemLabel.numberOfLines = 1
        timeRemLabel.text = String(format: "%02d:%02d", 0, 0)
//        timeRemLabel.textColor = .blackColor()
        
        // drawing tools view
        // it can be hidden and displayed
        view.addSubview(drawContainer)
        drawContainer.hidden = false
        drawContainer.frame = CGRect(x: sView.frame.width-BUTTON_WIDTH,
                                     y: 0,
                                     width: BUTTON_WIDTH,
                                     height: sView.frame.height-BUTTON_HEIGHT)
        drawContainer.backgroundColor = UIColor(white: 1, alpha: 0.7)
        
        // Drawing Tool button
        drawContainer.addSubview(drawButton)
        drawButton.setImage(drawButtonImage, forState: .Normal)
       // drawButton.layer.borderWidth = 1
       //    drawButton.layer.borderColor = UIColor.blackColor().CGColor
        drawButton.frame = CGRect(x: 0,
                                  y: 0,
                                  width: BUTTON_WIDTH,
                                  height: BUTTON_HEIGHT)
        drawButton.addTarget(self, action: #selector(enableDraw(_:)), forControlEvents: .TouchUpInside)
        
        drawContainer.addSubview(clearButton)
       
       
    
        clearButton.setImage(eraserButtonImage, forState: .Normal)
        //clearButton.layer.borderWidth = 1
        //clearButton.layer.borderColor = UIColor.blackColor().CGColor
        clearButton.frame = CGRect(x: 0,
                                   y: BUTTON_HEIGHT+5,
                                   width: BUTTON_WIDTH,
                                   height: BUTTON_HEIGHT)
        clearButton.addTarget(self, action: #selector(clearDrawing(_:)), forControlEvents: .TouchUpInside)
    }
    
    // Zooming method
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return scrollView.subviews[0]
    }
    
    // This function always updates the video's timer while the video is being played
    func updateTimer(elapsedTime: Float64, duration: Float64) {
        let timeRemaining: Float64 = CMTimeGetSeconds(player.currentItem!.duration) - elapsedTime
        timeElapLabel.text = String(format: "%02d:%02d", ((lround(elapsedTime) / 60) % 60), lround(elapsedTime) % 60)
        timeRemLabel.text = String(format: "%02d:%02d", ((lround(timeRemaining) / 60) % 60), lround(timeRemaining) % 60)
        
        // also updating the slider value to follow the elapsed time
        let sliderValue = elapsedTime/CMTimeGetSeconds(player.currentItem!.duration)
        let floatValue = Float(sliderValue)
        seekSlider.setValue(floatValue, animated: true)
    }
    
    // This function observes the elapsed time from the video
    func observeTime(elapsedTime: CMTime) {
        let duration = CMTimeGetSeconds(player.currentItem!.duration)
        if isfinite(duration) {
            let elapsedTime = CMTimeGetSeconds(elapsedTime)
            updateTimer(elapsedTime, duration: duration)
        }
    }
    
    // This function handles when the video has finished playing to end
    func playerDidFinishPlaying(note: NSNotification) {
        videoState = 2
        playButton.setImage(replayButtonImage, forState: .Normal)
    }
    
    // Function for playing, pausing, and replaying a video
    func play(sender: UIButton) {
        if videoState == 0 {
            player.play()
            if slowmotion == true {
                player.rate = 0.5
            } else {
                player.rate = 1.0
            }
            videoState = 1
            sender.setImage(pauseButtonImage, forState: .Normal)
        } else if videoState == 1 {
            player.pause()
            videoState = 0
            sender.setImage(playButtonImage, forState: .Normal)
        } else if videoState == 2 {
            player.seekToTime(kCMTimeZero)
            player.play()
            if slowmotion == true {
                player.rate = 0.5
            } else {
                player.rate = 1.0
            }
            videoState = 1
            sender.setImage(pauseButtonImage, forState: .Normal)
        }
    }
    
    // Slow motion controller
    func slowmo(sender: UIButton) {
        if videoState == 0 || videoState == 2 {
            if slowmotion == true {
                slowmotion = false
                slowmoButton.backgroundColor = .whiteColor()
            } else {
                slowmotion = true;
                slowmoButton.backgroundColor = .grayColor()
            }
        } else if videoState == 1 {
            if slowmotion == true {
                slowmotion = false
                player.rate = 1.0
                slowmoButton.backgroundColor = .whiteColor()
            } else {
                slowmotion = true;
                player.rate = 0.5
                slowmoButton.backgroundColor = .grayColor()
            }
        }
    }
    
    func enableDraw(sender: UIButton) {
        if drawenabled == true {
            sender.setImage(drawButtonImage, forState: .Normal)
            drawenabled = false
            self.sView.userInteractionEnabled = true
        } else {
            sender.setImage(drawButtonImage2, forState: .Normal)
            drawenabled = true
            self.sView.userInteractionEnabled = false
        }
    }
    
    // This function is called when the user starts to touch the slider
    func sliderBeganTracking(slider: UISlider) {
        playerRateTemp = player.rate
        player.pause()
    }
    
    // This function is called when the user has selected the desired timer from the slider
    func sliderEndedTracking(slider: UISlider) {
        let videoDuration = CMTimeGetSeconds(player.currentItem!.duration)
        let elapsedTime: Float64 = videoDuration * Float64(seekSlider.value)
        updateTimer(elapsedTime, duration: videoDuration)
        
        player.seekToTime(CMTimeMakeWithSeconds(elapsedTime, 100)) { (completed: Bool) -> Void in
            if self.playerRateTemp > 0 {
                self.player.play()
            }
        }
    }
    
    // This function is called when the slider value is changed
    func sliderValueChanged(slider: UISlider) {
        let videoDuration = CMTimeGetSeconds(player.currentItem!.duration)
        let elapsedTime: Float64 = videoDuration * Float64(seekSlider.value)
        updateTimer(elapsedTime, duration: videoDuration)
        if seekSlider.value == 1.0 {
            playButton.setImage(replayButtonImage, forState: .Normal)
        } else {
            if videoState == 0 {
                playButton.setImage(playButtonImage, forState: .Normal)
            } else if videoState == 1 {
                playButton.setImage(pauseButtonImage, forState: .Normal)
            } else if videoState == 2 {
                videoState = 0
                playButton.setImage(playButtonImage, forState: .Normal)
            }
        }
    }
    
    // This function displays and hides the controllers view
    func toggleControllers() {
        // if the controller's view is hidden, tapping the screen will display it
        if (controllerContainer.hidden == true && drawContainer.hidden == true) {
            controllerContainer.hidden = false
            drawContainer.hidden = false
        } else {
            controllerContainer.hidden = true
            drawContainer.hidden = true
        }
    }
    
    // Drawing funtions
    var finalPoint: CGPoint!
    var isDrawing: Bool!
    var lineWidth: CGFloat = 4.0

    
    let red: CGFloat = 255.0/255.0
    let green: CGFloat = 0.0/255.0
    let blue: CGFloat = 0.0/255.0
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        isDrawing = false
        if let touch = touches.first {
            finalPoint = touch.preciseLocationInView(dView)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        isDrawing = true
        if let touch = touches.first {
            if let boardImageView = dView {
                let currentCoordinate = touch.preciseLocationInView(boardImageView)
                UIGraphicsBeginImageContext(boardImageView.frame.size)
                boardImageView.image?.drawInRect(CGRectMake(0, 0, boardImageView.frame.size.width, boardImageView.frame.size.height))
                CGContextMoveToPoint(UIGraphicsGetCurrentContext()!, finalPoint.x, finalPoint.y)
                CGContextAddLineToPoint(UIGraphicsGetCurrentContext()!, currentCoordinate.x,currentCoordinate.y)
                CGContextSetLineCap(UIGraphicsGetCurrentContext()!, CGLineCap.Round)
                CGContextSetLineWidth(UIGraphicsGetCurrentContext()!, lineWidth)
                CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext()!, red, green, blue, 1.0)
                CGContextStrokePath(UIGraphicsGetCurrentContext()!)
                boardImageView.image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                finalPoint = currentCoordinate
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if(!isDrawing){
            if let boardImageView = dView {
                UIGraphicsBeginImageContext(boardImageView.frame.size)
                boardImageView.image?.drawInRect(CGRectMake(0, 0, boardImageView.frame.size.width, boardImageView.frame.size.height))
                CGContextMoveToPoint(UIGraphicsGetCurrentContext()!, finalPoint.x, finalPoint.y)
                CGContextAddLineToPoint(UIGraphicsGetCurrentContext()!, finalPoint.x,finalPoint.y)
                CGContextSetLineCap(UIGraphicsGetCurrentContext()!, CGLineCap.Round)
                CGContextSetLineWidth(UIGraphicsGetCurrentContext()!, lineWidth)
                CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext()!, red, green, blue, 1.0)
                CGContextStrokePath(UIGraphicsGetCurrentContext()!)
                boardImageView.image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
            }
        }
    }
    
    func clearDrawing(sender: UIButton!) {
        self.dView.image = nil
    }
    
    // Update frames
    func updateFrames(container: UIView!) {
        sView.frame = CGRect(x: 0,
                             y: 0,
                             width: container!.frame.width,
                             height: container!.frame.height)
        
        playerContainer.frame = CGRect(x: 0,
                                       y: 0,
                                       width: sView.frame.width,
                                       height: sView.frame.height)
        
        playerLayer.frame = CGRect(x: 0,
                                   y: 0,
                                   width: sView.frame.width,
                                   height: sView.frame.height)
        
        dView!.frame = CGRect(x: 0,
                              y: 0,
                              width: sView.frame.width,
                              height: sView.frame.height)
        
        controllerContainer.frame = CGRect(x: 0,
                                           y: sView.frame.height-BUTTON_HEIGHT,
                                           width: sView.frame.width,
                                           height: BUTTON_HEIGHT)
        
        playButton.frame = CGRect(x: 0,
                                  y: 0,
                                  width: BUTTON_WIDTH,
                                  height: BUTTON_HEIGHT)
        
        slowmoButton.frame = CGRect(x: playButton.frame.width + 5,
                                    y: 0,
                                    width: BUTTON_WIDTH,
                                    height: BUTTON_HEIGHT)
        
        timeElapLabel.frame = CGRect(x: playButton.frame.width + slowmoButton.frame.width + 5,
                                     y: 0,
                                     width: BUTTON_WIDTH,
                                     height: BUTTON_HEIGHT)
        timeElapLabel.textColor = .blackColor()
        volumeSlider.frame = CGRect(x: UIScreen.mainScreen().bounds.width-playButton.frame.width - (controllerContainer.frame.width - 4*BUTTON_WIDTH - 5)/3,
                                    y: 20,
                                    width: (controllerContainer.frame.width - 4*BUTTON_WIDTH - 5)/3,
                                    height: BUTTON_HEIGHT)
        

        
        seekSlider.frame = CGRect(x: playButton.frame.width + slowmoButton.frame.width + timeElapLabel.frame.width + 5,
                                  y: 0,
                                  width: controllerContainer.frame.width - 4*BUTTON_WIDTH - 5,
                                  height: BUTTON_HEIGHT)
        
        timeRemLabel.frame = CGRect(x: playButton.frame.width + slowmoButton.frame.width + timeElapLabel.frame.width + seekSlider.frame.width + 5,
                                    y: 0,
                                    width: BUTTON_WIDTH,
                                    height: BUTTON_HEIGHT)
//        timeRemLabel.textColor = .blackColor()
        
        drawContainer.frame = CGRect(x: sView.frame.width-BUTTON_WIDTH,
                                     y: 0,
                                     width: BUTTON_WIDTH,
                                     height: sView.frame.height)
        
        drawButton.frame = CGRect(x: 0,
                                  y: 0,
                                  width: BUTTON_WIDTH,
                                  height: BUTTON_HEIGHT)
        
        clearButton.frame = CGRect(x: 0,
                                   y: BUTTON_HEIGHT+5,
                                   width: BUTTON_WIDTH,
                                   height: BUTTON_HEIGHT)
    }
}
