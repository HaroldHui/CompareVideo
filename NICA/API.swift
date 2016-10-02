import Foundation

class API {
	callAPI(path: String) {
	let todoEndpoint: String = URLOFAPI + path
		var categories = []
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
                    categories += [category]
                }

                // Set the categories for basics, specialties and group acts
                return categories
            } catch  {
                print("error trying to convert data to JSON")
            }
        }
        task.resume()
	}
}