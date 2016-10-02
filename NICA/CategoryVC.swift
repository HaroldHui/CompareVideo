//
//  CategoryVC.swift
//  NICA
//
//  Created by Johan Albert on 12/08/2016.
//  Copyright © 2016 Johan Albert. All rights reserved.
//

import UIKit

class CategoryVC: UITableViewController {
    var sDelegate:SelectionDelegate? = nil
    
    var dashboard: Dashboard = Dashboard()
    var categories: [Category] = []
    var category: Category = Category()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Categories"
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
        return categories.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let category = categories[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.text = category.name

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.category = categories[indexPath.row]
        self.category.acts = []
        let path : String = "category/" + category.cid
        
        API.callAPI(path, completionHandler: {(categorydetail) -> Void in
            // Create acts from retrieved data
            self.category.tag = categorydetail["tag"] as! String
            if let actsarray = categorydetail["acts"] as? [[String: AnyObject]] {
                for act in actsarray {
                    let newact = Act(name: act["name"] as! String, aid: act["aid"] as! String!)
                    self.category.acts += [newact]
                }
            }
            
            // Navigate to act view
            let vc = ActVC()
            vc.sDelegate = self.sDelegate
            vc.dashboard = self.dashboard
            vc.category = self.category
            vc.acts = self.category.acts
            
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
