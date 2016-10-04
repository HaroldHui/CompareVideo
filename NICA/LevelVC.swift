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
        
        self.title = "Levels"
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
        
        self.act.prerequisites = []
        self.act.foundation = []
        self.act.intermediate = []
        self.act.advanced = []
        self.act.professional = []
        
        let path : String = "category/" + category.cid + "/act/" + act.aid
        showSpinner(tableView)
        API.callAPI(path, completionHandler: {(actdetail) -> Void in
            // Get act details from retrieved data
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
            if let professional = actdetail["professional_inspirational"] as? [[String: AnyObject]] {
                for f in professional {
                    let folder = Folder(name: f["name"] as! String, fid: f["fid"] as! String)
                    self.act.professional += [folder]
                }
            }
            // Navigate to folder view
            let vc = FolderVC()
            
            vc.sDelegate = self.sDelegate
            vc.dashboard = self.dashboard
            vc.category = self.category
            vc.act = self.act
            
            if (indexPath.row == 0) {
                vc.folders = self.act.prerequisites
                vc.level = "pre_requisites"
            }
            if (indexPath.row == 1) {
                vc.folders = self.act.foundation
                vc.level = "foundation"
            }
            if (indexPath.row == 2) {
                vc.folders = self.act.intermediate
                vc.level = "intermediate"
            }
            if (indexPath.row == 3) {
                vc.folders = self.act.advanced
                vc.level = "advanced"
            }
            if (indexPath.row == 4) {
                vc.folders = self.act.professional
                vc.level = "professional_inspirational"
            }
            self.hideSpinner(tableView)
            let nc = UINavigationController()
            nc.viewControllers = [vc]
            
            self.navigationController?.pushViewController(vc, animated: true)
        })
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
