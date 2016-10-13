//
//  PictureVideoCVC.swift
//  NICA
//
//  Created by Roger Li on 7/10/2016.
//  Copyright © 2016 Johan Albert. All rights reserved.
//

import UIKit
import AVFoundation

class PictureVideoCVC: UICollectionViewController {
    var sDelegate: SelectionDelegate?
    
    var dashboard: Dashboard = Dashboard()
    var category: Category = Category()
    var act: Act = Act()
    var folders : [Folder] = []
    var videos: [Video] = []
    var pictures: [Picture] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Pictures and Videos"
        
        // Ensure that scrolling is enabled
        self.collectionView!.userInteractionEnabled = true
        self.collectionView!.scrollEnabled = true
        self.collectionView!.bounces = true
        self.collectionView!.alwaysBounceVertical = true
        self.collectionView!.backgroundColor = UIColor.whiteColor()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 4
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (section == 1) {
            return videos.count
        } else if (section == 3) {
            return pictures.count
        } else {
            // Return 1 for a header section
            return 1
        }
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        if (indexPath.section == 1) {
            let video = videos[indexPath.row]
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
            let title = UILabel(frame: CGRectMake(0, 125, cell.bounds.size.width - 25, 30))
            title.text = video.name
            cell.contentView.addSubview(title)
            NSOperationQueue.mainQueue().addOperationWithBlock {
                let urlPath = NSURL(string: video.dir.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)
                var image = self.thumbnailForVideo(urlPath!)
                
                image = self.resizeImage(image!, newWidth: 125)
                
                // Set the size of the image
                let frame = CGRectMake(0, 0, 125, 125)
                let backgroundImage = UIImageView(frame: frame)
                backgroundImage.image = image
                
                cell.contentView.addSubview(backgroundImage)
            }
            
            return cell
        } else if (indexPath.section == 3) {
            let picture = pictures[indexPath.row]
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
            let title = UILabel(frame: CGRectMake(0, 125, cell.bounds.size.width - 25, 30))
            title.text = picture.name
            cell.contentView.addSubview(title)
            NSOperationQueue.mainQueue().addOperationWithBlock {
                let urlPath = NSURL(string: picture.dir.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)
                let data = NSData(contentsOfURL: urlPath!)
                var image = UIImage(data: data!)
                
                image = self.resizeImage(image!, newWidth: 125)
                
                // Set the size of the image
                let frame = CGRectMake(0, 0, 125, 125)
                let backgroundImage = UIImageView(frame: frame)
                backgroundImage.image = image
                
                cell.contentView.addSubview(backgroundImage)
            }
            
            return cell
        } else if (indexPath.section == 0) {
            // Generate header section for videos
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
            let header = UILabel(frame: CGRectMake(50, 0, 300, 75))
            
            if (videos.count > 0) {
                header.text = "Videos"
                header.font = UIFont(name: header.font.fontName, size: 30)
            } else {
                header.frame = CGRectMake(0, 0, 0, 0)
            }
            
            cell.contentView.addSubview(header)

            return cell
        } else {
            // Generate header section for pictures
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
            let header = UILabel(frame: CGRectMake(50, 0, 300, 75))
            
            if (pictures.count > 0) {
                header.text = "Pictures"
                header.font = UIFont(name: header.font.fontName, size: 30)
            } else {
                header.frame = CGRectMake(0, 0, 0, 0)
            }
            
            cell.contentView.addSubview(header)
            
            return cell
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if (indexPath.section == 0 || indexPath.section == 2) {
            // Cell size for pictures and videos
            return CGSizeMake(300, 75)
        } else {
            // Cell size for section headers
            return CGSizeMake(125, 190)
        }
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 1) {
            // Navigate to watch video view
            let vc = WatchVideoVC()
            vc.dashboard = dashboard
            vc.category = category
            vc.act = act
            vc.video = videos[indexPath.row]
            
            let nc = UINavigationController()
            nc.viewControllers = [vc]
            
            sDelegate!.showVideo(self, path: vc.video.dir)
            
            self.dismissViewControllerAnimated(true, completion: nil)
        } else if (indexPath.section == 3) {
            // Navigate to show picture view
            showSpinner(collectionView)
            NSOperationQueue.mainQueue().addOperationWithBlock {
                let urlPath = NSURL(string: self.pictures[indexPath.row].dir.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)
                let data = NSData(contentsOfURL: urlPath!)
                self.hideSpinner(collectionView)
                let vc = WatchVideoVC()
                vc.dashboard = self.dashboard
                vc.category = self.category
                vc.act = self.act
                vc.picture = self.pictures[indexPath.row]
                
                let nc = UINavigationController()
                nc.viewControllers = [vc]
                
                let modalVC = ModalImageVC(data: data, svc: self.splitViewController!)
                modalVC.modalPresentationStyle = .OverCurrentContext
                self.splitViewController!.presentViewController(modalVC, animated: true, completion: nil)
                self.splitViewController!.view.alpha = 0.2
            }
        }
    }
    
    // Generates a thumbnail of a video given an NSURL
    func thumbnailForVideo(url: NSURL) -> UIImage? {
        do {
            let asset = AVURLAsset(URL: url, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImageAtTime(CMTimeMake(0, 1), actualTime: nil)
            return UIImage(CGImage: cgImage)
        } catch {
            print("Error creating thumbnail")
            return nil
        }
    }

    var activityIndicator:UIActivityIndicatorView?
    var activityIndicatorView: UIView?
    
    func showSpinner (collectionView: UICollectionView) {
        collectionView.userInteractionEnabled = false
        
        self.activityIndicatorView = UIView(frame: CGRectMake( (self.view.bounds.size.width/2 - self.view.bounds.size.width/8), (self.view.bounds.size.height/2 - self.view.bounds.size.width/8), self.view.bounds.size.width/4, self.view.bounds.size.width/4))
        self.activityIndicatorView?.backgroundColor = UIColor.blackColor()
        self.activityIndicatorView?.alpha = 0.7
        self.activityIndicatorView?.layer.cornerRadius = 10
        self.activityIndicatorView?.clipsToBounds = true
        self.view.addSubview(self.activityIndicatorView!)
        
        self.activityIndicator = UIActivityIndicatorView (activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        self.activityIndicator?.color = UIColor.whiteColor()
        self.activityIndicator?.center = self.view.center
        self.view.addSubview(self.activityIndicator!)
        self.activityIndicator?.startAnimating()
    }
    
    func hideSpinner (collectionView: UICollectionView) {
        self.activityIndicator?.stopAnimating()
        self.activityIndicator?.removeFromSuperview()
        self.activityIndicatorView?.removeFromSuperview()
        collectionView.userInteractionEnabled = true
    }
    
    
    // Back button
    override func viewDidAppear(animated: Bool) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: #selector(backToWatchVideo))
    }
    
    func backToWatchVideo(){
        let vc = WatchVideoVC()
        vc.dashboard = dashboard
        vc.category = category
        
        let nc = UINavigationController()
        nc.viewControllers = [vc]
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Resizes a given image
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
