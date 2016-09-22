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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let category = categories[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.text = category.name

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Temporary
        let category = categories[indexPath.row]
        category.acts = [Act(name: "Act1"), Act(name: "Act2")]

        let vc = ActVC()
        
        vc.sDelegate = self.sDelegate
        vc.dashboard = dashboard

        vc.category = category
        vc.acts = category.acts
        
        let nc = UINavigationController()
        nc.viewControllers = [vc]

        self.navigationController?.pushViewController(vc, animated: true)
        
        // Get acts from API based on category id
        let todoEndpoint: String = URLOFAPI + "category/" + category.cid
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
                guard let categorydetail = try NSJSONSerialization.JSONObjectWithData(responseData, options: []) as? [String: AnyObject] else {
                    // TODO: handle
                    print("Couldn't convert received data to JSON dictionary")
                    return
                }
                
                // Create acts from retrieved data
                category.tag = categorydetail["tag"] as! String
                if let actsarray = categorydetail["acts"] as? [[String: AnyObject]] {
                    for act in actsarray {
                        let newact = Act(name: act["name"] as! String, aid: act["aid"] as! String!)
                        category.acts += [newact]
                    }
                }
                
                // Navigate to act view
                let vc = ActVC()
                vc.dashboard = self.dashboard
                vc.category = category
                vc.acts = category.acts
                
                let nc = UINavigationController()
                nc.viewControllers = [vc]
                
                self.showDetailViewController(nc, sender: self)

            } catch  {
                print("error trying to convert data to JSON")
            }
        }
        task.resume()

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
