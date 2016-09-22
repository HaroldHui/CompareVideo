//
//  LevelVC.swift
//  NICA
//
//  Created by Johan Albert on 12/08/2016.
//  Copyright © 2016 Johan Albert. All rights reserved.
//

import UIKit

class LevelVC: UITableViewController {
    var sDelegate: SelectionDelegate?
    
    var dashboard: Dashboard = Dashboard()
    var category: Category = Category()
    var act: Act = Act()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 250, height: 50))
//        backButton.setTitle("Back to Acts", forState: UIControlState.Normal)
//        backButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
//        backButton.addTarget(self, action: #selector(backToActs), forControlEvents: UIControlEvents.TouchUpInside)
//        let leftBarButton = UIBarButtonItem()
//        leftBarButton.customView = backButton
//        self.navigationItem.leftBarButtonItem = leftBarButton
        
        self.title = "Levels"
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    // Go back to act view
    func backToActs(sender: UIButton!) {
        let vc = ActVC()
        vc.dashboard = dashboard
        vc.category = category
        vc.acts = category.acts
        
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
        return 5
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        // Cell labels based on row number, one for each of the five levels
        if (indexPath.row == 0) {
            cell.textLabel?.text = "Prerequisites"
        }
        if (indexPath.row == 1) {
            cell.textLabel?.text = "Foundation"
        }
        if (indexPath.row == 2) {
            cell.textLabel?.text = "Intermediate"
        }
        if (indexPath.row == 3) {
            cell.textLabel?.text = "Advanced"
        }
        if (indexPath.row == 4) {
            cell.textLabel?.text = "Professional/Inspirational"
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Load acts from API
        let todoEndpoint: String = URLOFAPI + "category" + category.cid + "/act/" + act.aid
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
                guard let actdetail = try NSJSONSerialization.JSONObjectWithData(responseData, options: []) as? [String: AnyObject] else {
                    // TODO: handle
                    print("Couldn't convert received data to JSON dictionary")
                    return
                }
                
                // Get act details from retrieved data
                self.act.description = actdetail["decription"] as! String
                self.act.trainer = actdetail["trainer"] as! String
                self.act.equipments = actdetail["equipments"] as! String
                
                // Create folders for all levels from retrieved data
                if let prerequisites = actdetail["pre_requisites"] as? [[String: AnyObject]] {
                    for f in prerequisites {
                        let folder = Folder(name: f["name"] as! String, fid: f["fid"] as! String)
                        self.act.prerequisites += [folder]
                    }
                }
                if let foundation = actdetail["foundation"] as? [[String: AnyObject]] {
                    for f in foundation {
                        let folder = Folder(name: f["name"] as! String, fid: f["fid"] as! String)
                        self.act.foundation += [folder]
                    }
                }
                if let intermediate = actdetail["intermediate"] as? [[String: AnyObject]] {
                    for f in intermediate {
                        let folder = Folder(name: f["name"] as! String, fid: f["fid"] as! String)
                        self.act.intermediate += [folder]
                    }
                }
                if let advanced = actdetail["advanced"] as? [[String: AnyObject]] {
                    for f in advanced {
                        let folder = Folder(name: f["name"] as! String, fid: f["fid"] as! String)
                        self.act.advanced += [folder]
                    }
                }
                if let professional = actdetail["professional_inspiraton"] as? [[String: AnyObject]] {
                    for f in professional {
                        let folder = Folder(name: f["name"] as! String, fid: f["fid"] as! String)
                        self.act.professional += [folder]
                    }
                }

            } catch  {
                print("error trying to convert data to JSON")
            }
        }
        task.resume()
        
        // Navigate to folder view
        let vc = FolderVC()

        vc.sDelegate = self.sDelegate
        vc.dashboard = dashboard
        vc.category = category
        vc.act = act
        
        // Temporary
        act.prerequisites = [Folder(name: "Folder1"), Folder(name: "Folder2")]
        act.foundation = [Folder(name: "Folder1"), Folder(name: "Folder2")]
        act.intermediate = [Folder(name: "Folder1"), Folder(name: "Folder2")]
        act.advanced = [Folder(name: "Folder1"), Folder(name: "Folder2")]
        act.professional = [Folder(name: "Folder1"), Folder(name: "Folder2")]
        
        if (indexPath.row == 0) {
            vc.folders = act.prerequisites
            vc.level = "pre_requisites"
        }
        if (indexPath.row == 1) {
            vc.folders = act.foundation
            vc.level = "foundation"
        }
        if (indexPath.row == 2) {
            vc.folders = act.intermediate
            vc.level = "intermediate"
        }
        if (indexPath.row == 3) {
            vc.folders = act.advanced
            vc.level = "advanced"
        }
        if (indexPath.row == 4) {
            vc.folders = act.professional
            vc.level = "professional_inspirational"
        }
        
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
