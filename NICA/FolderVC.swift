//
//  FolderVC.swift
//  NICA
//
//  Created by Johan Albert on 12/08/2016.
//  Copyright © 2016 Johan Albert. All rights reserved.
//

import UIKit

class FolderVC: UITableViewController {
    var sDelegate: SelectionDelegate?
    var dashboard: Dashboard = Dashboard()
    var category: Category = Category()
    var act: Act = Act()
    var level: String = ""
    var folders : [Folder] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Folders"
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
        return folders.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let folder = folders[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.text = folder.name
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let folder = folders[indexPath.row]
        folder.videos = []
        folder.pictures = []
        
        let path : String = "category/" + category.cid + "/act/" + act.aid + "/level/" + level + "/folder/" + folder.fid
        
        API.callAPI(path, completionHandler: {(folderdetail) -> Void in
            // Get folder details from retrieved data
            folder.description = folderdetail["description"] as! String
            folder.name = folderdetail["name"] as! String
            
            // Create videos and pictures for folder from retrieved data
            if let videos = folderdetail["videos"] as? [[String: AnyObject]] {
                for v in videos {
                    let video = Video(name: v["name"] as! String, path: v["path"] as! String)
                    folder.videos += [video]
                }
            }
            if let pictures = folderdetail["pictures"] as? [[String: AnyObject]] {
                for p in pictures {
                    let picture = Picture(name: p["name"] as! String, path: p["path"] as! String)
                    folder.pictures += [picture]
                }
            }

            // Navigate to the picture and video view
            let vc = PictureVideoVC()
            vc.sDelegate = self.sDelegate
            vc.dashboard = self.dashboard
            vc.category = self.category
            vc.act = self.act
            vc.folders = self.folders
            vc.videos = folder.videos
            vc.pictures = folder.pictures
            
            let nc = UINavigationController()
            nc.viewControllers = [vc]
            
            self.navigationController?.pushViewController(vc, animated: true)
        })
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
