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
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load categories from API
        let todoEndpoint: String = "https://jsonplaceholder.typicode.com/todos"
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
                print("error calling GET on /todos")
                print(error)
                return
            }
            // parse the result as JSON, since that's what the API provides
            do {
                guard let todos = try NSJSONSerialization.JSONObjectWithData(responseData, options: []) as? [[String: AnyObject]] else {
                    // TODO: handle
                    print("Couldn't convert received data to JSON dictionary")
                    return
                }
                // now we have the todo, let's just print it to prove we can access it
                print("The todo is: " + todos[0].description)
                
                // the todo object is a dictionary
                // so we just access the title using the "title" key
                // so check for a title and print it if we have one
                guard let todoTitle = todos[0]["title"] as? String else {
                    print("Could not get todo title from JSON")
                    return
                }
                print("The title is: " + todoTitle)
                
                // Create categories from retrieved data
                for todo in todos[0..<5] {
                    let category = Category(name: todo["title"] as! String)
                    self.basics += [category]
                }
                Root.rootInstance.dashboard[0].categories = self.basics
                Root.rootInstance.dashboard[1].categories = self.basics
                Root.rootInstance.dashboard[2].categories = self.basics
            } catch  {
                print("error trying to convert data to JSON")
            }
        }
        task.resume()
        
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
