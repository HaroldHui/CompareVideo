//
//  MasterVC.swift
//  NICA
//
//  Created by Johan Albert on 8/08/2016.
//  Copyright © 2016 Johan Albert. All rights reserved.
//

import UIKit

class MasterVC: UITableViewController {
    var sDelegate:SelectionDelegate? = nil
    
    var basics : [Category] = []
    var specialties : [Category] = []
    var groupacts : [Category] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load categories from API
        let todoEndpoint: String = "http://ec2-52-25-32-82.us-west-2.compute.amazonaws.com:3000/api/basics"
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
                guard let basics = try NSJSONSerialization.JSONObjectWithData(responseData, options: []) as? [[String: AnyObject]] else {
                    // TODO: handle
                    print("Couldn't convert received data to JSON dictionary")
                    return
                }
                
                // Create categories from retrieved data
                for categorybrief in basics {
                    let category = Category(name: categorybrief["name"] as! String, cid: categorybrief["cid"] as! String)
                    self.basics += [category]
                }

                // Set the categories for basics, specialties and group acts
                Root.rootInstance.dashboard[0].categories = self.basics
            } catch  {
                print("error trying to convert data to JSON")
            }
        }
        task.resume()
        
        // Load categories from API
        let todoEndpoint2: String = "http://ec2-52-25-32-82.us-west-2.compute.amazonaws.com:3000/api/specialties"
        guard let url2 = NSURL(string: todoEndpoint2) else {
            print("Error: cannot create URL")
            return
        }
        
        let urlRequest2 = NSURLRequest(URL: url2)
        
        let config2 = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session2 = NSURLSession(configuration: config2)
        
        let task2 = session2.dataTaskWithRequest(urlRequest2) {
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
                guard let specialties = try NSJSONSerialization.JSONObjectWithData(responseData, options: []) as? [[String: AnyObject]] else {
                    // TODO: handle
                    print("Couldn't convert received data to JSON dictionary")
                    return
                }
                
                // Create categories from retrieved data
                for categorybrief in specialties {
                    let category = Category(name: categorybrief["name"] as! String, cid: categorybrief["cid"] as! String)
                    self.specialties += [category]
                }
                
                // Set the categories for basics, specialties and group acts
                Root.rootInstance.dashboard[1].categories = self.specialties
            } catch  {
                print("error trying to convert data to JSON")
            }
        }
        task2.resume()
        
        // Load categories from API
        let todoEndpoint3: String = "http://ec2-52-25-32-82.us-west-2.compute.amazonaws.com:3000/api/group-acts"
        guard let url3 = NSURL(string: todoEndpoint3) else {
            print("Error: cannot create URL")
            return
        }
        
        let urlRequest3 = NSURLRequest(URL: url3)
        
        let config3 = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session3 = NSURLSession(configuration: config3)
        
        let task3 = session3.dataTaskWithRequest(urlRequest3) {
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
                guard let groupacts = try NSJSONSerialization.JSONObjectWithData(responseData, options: []) as? [[String: AnyObject]] else {
                    // TODO: handle
                    print("Couldn't convert received data to JSON dictionary")
                    return
                }
                
                // Create categories from retrieved data
                for categorybrief in groupacts {
                    let category = Category(name: categorybrief["name"] as! String, cid: categorybrief["cid"] as! String)
                    self.groupacts += [category]
                }
                
                // Set the categories for basics, specialties and group acts
                Root.rootInstance.dashboard[2].categories = self.groupacts
            } catch  {
                print("error trying to convert data to JSON")
            }
        }
        task3.resume()
        
        self.title = "Root"
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")

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
        // return the number of rows
        return Root.rootInstance.dashboard.count;
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let dashboard = Root.rootInstance.dashboard[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.text = dashboard.name;
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let dashboard = Root.rootInstance.dashboard[indexPath.row]
        
        // Navigate to category view
        let vc = CategoryVC()

        vc.sDelegate = self.sDelegate

        vc.categories = dashboard.categories
        vc.dashboard = Root.rootInstance.dashboard[indexPath.row]
        
        let nc = UINavigationController()
        nc.viewControllers = [vc]
        
        self.showDetailViewController(nc, sender: self)
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
