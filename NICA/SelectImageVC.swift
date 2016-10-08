//
//  SelectImageVC.swift
//  NICA
//
//  Created by Johan Albert on 6/08/2016.
//  Copyright © 2016 Johan Albert. All rights reserved.
//

import UIKit

// a protocol for any classes to conform
// any class that conform to this protocol must have these functions
protocol SelectImageDelegate {
    func showImage(controller:SelectImageVC, path:String)
}

class SelectImageVC: UIViewController {
    var delegate:SelectImageDelegate? = nil
    var path = ""
    
    // NS file manager
    let fm = NSFileManager.defaultManager()
    
    @IBAction func selectImage(sender: UIButton) {
        delegate?.showImage(self, path: path)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // looking at the bundle path
        path = NSBundle.mainBundle().resourcePath!
        let items = try! fm.contentsOfDirectoryAtPath(path)
        
        // iterating through all contents in the given path
        var buttonX: CGFloat = 40
        for item in items {
            // only selects the "png" type of file
            if item.hasSuffix(".png") {
                
                // the image itself will show as the button
                let imageButton = UIImage(named: item)
                let ibutton = UIButton(frame: CGRect(x: buttonX, y: 100, width: 250, height: 250))
                ibutton.setImage(imageButton, forState: UIControlState.Normal)
                
                let itemArr = item.characters.split{$0 == "."}.map(String.init)
                
                // set the title and the label
                ibutton.setTitle("\(itemArr[0])", forState: UIControlState.Normal) // We are going to use the item name as the Button Title here.
                ibutton.titleLabel?.text = "\(itemArr[0])"
                
                // set the action
                ibutton.addTarget(self, action: #selector(SelectImageVC.imageSelected(_:)), forControlEvents: .TouchUpInside)
                
                self.view.addSubview(ibutton)
                
                let ilabel = UILabel(frame: CGRect(x: buttonX, y: 350, width: 250, height: 30))
                ilabel.text = itemArr[0]
                
                self.view.addSubview(ilabel)
                
                buttonX = buttonX + 300
                
                // need to apply constraints instead of CGRect with magic numbers
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    func imageSelected(sender: UIButton!) {
        path = NSBundle.mainBundle().pathForResource(sender.titleLabel!.text!, ofType:"png")!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
