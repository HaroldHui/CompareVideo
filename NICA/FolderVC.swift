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
        
//        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 250, height: 50))
//        backButton.setTitle("Back to Levels", forState: UIControlState.Normal)
//        backButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
//        backButton.addTarget(self, action: #selector(backToLevels), forControlEvents: UIControlEvents.TouchUpInside)
//        let leftBarButton = UIBarButtonItem()
//        leftBarButton.customView = backButton
//        self.navigationItem.leftBarButtonItem = leftBarButton
        
        self.title = "Folders"
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    // Go back to level view
    func backToLevels(sender: UIButton!) {
        let vc = LevelVC()
        vc.dashboard = dashboard
        vc.category = category
        vc.act = act
        
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
        
        // Load acts from API
        let todoEndpoint: String = "http://ec2-52-25-32-82.us-west-2.compute.amazonaws.com:3000/api/category" + category.cid + "/act/" + act.aid + "/level/" + level + "/folder/" + folder.fid
        guard let url = NSURL(string: todoEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        
        let urlRequest = NSURLRequest(URL: url)
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) in
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            guard error == nil else {
                print("error calling GET")
                print(error)
                return
            }
            // parse the result as JSON, since that's what the API provides
            do {
                guard let folderdetail = try NSJSONSerialization.JSONObjectWithData(responseData, options: []) as? [String: AnyObject] else {
                    // TODO: handle
                    print("Couldn't convert received data to JSON dictionary")
                    return
                }
                
                // Get folder details from retrieved data
                folder.description = folderdetail["description"] as! String
                folder.name = folderdetail["name"] as! String
                
                // Create videos and pictures for folder from retrieved data
                if let videos = folderdetail["videos"] as? [[String: AnyObject]] {
                    for v in videos {
                        let video = Video(name: v["name"] as! String)
                        folder.videos += [video]
                    }
                }
                if let pictures = folderdetail["pictures"] as? [[String: AnyObject]] {
                    for p in pictures {
                        let picture = Picture(name: p["name"] as! String)
                        folder.pictures += [picture]
                    }
                }
                
            } catch  {
                print("error trying to convert data to JSON")
            }
        }
        task.resume()
        
        // Navigate to the picture and video view
        let vc = PictureVideoVC()
        vc.sDelegate = self.sDelegate
        vc.dashboard = dashboard
        vc.category = category
        vc.act = act
        vc.folders = folders
        vc.videos = folder.videos
        vc.pictures = folder.pictures
        
        let nc = UINavigationController()
        nc.viewControllers = [vc]
        
        self.navigationController?.pushViewController(vc, animated: true)
//        self.showDetailViewController(nc, sender: self)
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
