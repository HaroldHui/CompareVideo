//
//  API.swift
//  NICA
//
//  Created by Roger Li on 01/10/2016.
//  Copyright © 2016 Johan Albert. All rights reserved.
//

import Foundation

class API {
    class func callAPICategories(path : String, completionHandler : ((categories : [Category]) -> Void)) {
	let todoEndpoint: String = URLOFSERVER + "/api/" + path
        var tempcategories : [Category] = []
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
                guard let categorydata = try NSJSONSerialization.JSONObjectWithData(responseData, options: []) as? [[String: AnyObject]] else {
                    // TODO: handle
                    print("Couldn't convert received data to JSON dictionary")
                    return
                }
                
                // Create categories from retrieved data
                for categorybrief in categorydata {
                    let category = Category(name: categorybrief["name"] as! String, cid: categorybrief["cid"] as! String)
                    tempcategories += [category]
                }
                completionHandler(categories : tempcategories)
            } catch  {
                print("error trying to convert data to JSON")
            }
        }
        task.resume()
	}
    
    class func callAPI(path: String, completionHandler : ((array: [String: AnyObject]) -> Void)) {
        let todoEndpoint: String = URLOFSERVER + "/api/" + path
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
            
            dispatch_async(dispatch_get_main_queue()) {
                // parse the result as JSON, since that's what the API provides
                do {
                    guard let categorydetail = try NSJSONSerialization.JSONObjectWithData(responseData, options: []) as? [String: AnyObject] else {
                        // TODO: handle
                        print("Couldn't convert received data to JSON dictionary")
                        return
                    }
                    
                    completionHandler(array: categorydetail)
                    
                } catch  {
                    print("error trying to convert data to JSON")
                }
            }
        }
        task.resume()
    }
    
    
}
