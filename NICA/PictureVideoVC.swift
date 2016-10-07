//
//  LevelVC.swift
//  NICA
//
//  Created by Johan Albert on 12/08/2016.
//  Copyright © 2016 Johan Albert. All rights reserved.
//

import UIKit

class PictureVideoVC: UITableViewController {
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
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count + pictures.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.row < videos.count) {
            let video = videos[indexPath.row]
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
            cell.textLabel?.text = video.name
            return cell
        } else {
            let picture = pictures[indexPath.row - videos.count]
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
            cell.textLabel?.text = picture.name
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row < videos.count) {
            let vc = WatchVideoVC()
            vc.dashboard = dashboard
            vc.category = category
            vc.act = act
            vc.video = videos[indexPath.row]
            
            let nc = UINavigationController()
            nc.viewControllers = [vc]
            //
            //            self.showDetailViewController(nc, sender: self)
            
            sDelegate!.showVideo(self, path: vc.video.dir)
            
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            showSpinner(tableView)
            NSOperationQueue.mainQueue().addOperationWithBlock {
            let urlPath = NSURL(string: self.pictures[indexPath.row - self.videos.count].dir.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)
            let data = NSData(contentsOfURL: urlPath!)
            self.hideSpinner(tableView)
            
            let modalVC = ModalImageVC(data: data, svc: self.splitViewController!)
            modalVC.modalPresentationStyle = .OverCurrentContext
            self.splitViewController!.presentViewController(modalVC, animated: true, completion: nil)
            self.splitViewController!.view.alpha = 0.2
            }
            
        }
    }
    
    var activityIndicator:UIActivityIndicatorView?
    var activityIndicatorView: UIView?
    
    func showSpinner (tableView: UITableView) {
        tableView.userInteractionEnabled = false
        
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
    
    func hideSpinner (tableView: UITableView) {
        self.activityIndicator?.stopAnimating()
        self.activityIndicator?.removeFromSuperview()
        self.activityIndicatorView?.removeFromSuperview()
        tableView.userInteractionEnabled = true
    }
    
    // back
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
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
