//
//  ModalImageVC.swift
//  NICA
//
//  Created by Johan Albert on 4/10/16.
//  Copyright © 2016 Johan Albert. All rights reserved.
//

import UIKit

class ModalImageVC: UIViewController, UIScrollViewDelegate {

    let screenWidth = UIScreen.mainScreen().bounds.size.width
    let screenHeight = UIScreen.mainScreen().bounds.size.height
    
    var data: NSData?
    var svc: UISplitViewController?
    
    let sView = UIScrollView()
    let closeButton = UIButton()
    
    // Initialization function
    init(data: NSData?, svc: UISplitViewController?) {
        self.data = data
        self.svc = svc
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // the background needs to be clear so that it does not obstruct the view behind it
        view.backgroundColor = .clearColor()
        
        let imageWidth: CGFloat = screenWidth/2
        let imageHeight: CGFloat = screenWidth/2
        
        // setting up the scroll view's properties
        sView.frame = CGRect(x: (screenWidth/2)-(imageWidth/2),
                             y: (screenHeight/2)-(imageHeight/2),
                             width: imageWidth,
                             height: imageHeight)
        sView.delegate = self
        sView.minimumZoomScale = 1.0
        sView.maximumZoomScale = 10.0
        sView.showsVerticalScrollIndicator = false
        sView.showsHorizontalScrollIndicator = false
        
        // creating the image view
        let imageView = UIImageView()
        imageView.image = UIImage(data: data!)
        imageView.frame = CGRect(x: 0, y: 0, width: sView.frame.size.width, height: sView.frame.size.width)
        
        sView.addSubview(imageView)
        view.addSubview(sView)
        
        // setting up the close button for closing this view
        closeButton.setTitle("X", forState: .Normal)
        closeButton.titleLabel!.text = "X"
        closeButton.setTitleColor(.blackColor(), forState: .Normal)
        closeButton.backgroundColor = .whiteColor()
        closeButton.frame = CGRectMake(screenWidth-50, 20, 25, 25)
        closeButton.layer.cornerRadius = 0.5 * closeButton.bounds.size.width
        closeButton.addTarget(self, action: #selector(self.close(_:)), forControlEvents: .TouchUpInside)
        
        view.addSubview(closeButton)
        // Do any additional setup after loading the view.
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return scrollView.subviews[0];
    }
    
    func close(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
        svc!.view.alpha = 1.0
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
