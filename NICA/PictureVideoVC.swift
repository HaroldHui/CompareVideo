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
        
//        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 250, height: 50))
//        backButton.setTitle("Back to Skills", forState: UIControlState.Normal)
//        backButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
//        backButton.addTarget(self, action: #selector(backToSkills), forControlEvents: UIControlEvents.TouchUpInside)
//        let leftBarButton = UIBarButtonItem()
//        leftBarButton.customView = backButton
//        self.navigationItem.leftBarButtonItem = leftBarButton
        
        self.title = "Pictures and Videos"
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    // Go back to folder view
    func backToFolders(sender: UIButton!) {
        let vc = FolderVC()
        vc.dashboard = dashboard
        vc.category = category
        vc.act = act
        vc.folders = folders
        
        let nc = UINavigationController()
        nc.viewControllers = [vc]
        
        self.showDetailViewController(nc, sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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
            let vc = ViewController()
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
            let vc = ViewController()
            vc.dashboard = dashboard
            vc.category = category
            vc.act = act
            vc.picture = pictures[indexPath.row - videos.count]

            let nc = UINavigationController()
            nc.viewControllers = [vc]
//
//            self.showDetailViewController(nc, sender: self)
            
            sDelegate!.showImage(self, path: vc.picture.dir)
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
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
