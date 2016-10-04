//
//  LoginVC.swift
//  NICA
//
//  Created by lyx_xuan on 16/9/2o.
//  Copyright © 2016年 Johan Albert. All rights reserved.
//

import UIKit


class LoginVC: UIViewController {
    
    var userDefaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(sender: UIButton) {
        
        let loginURL = NSURL(string: URLOFAPI + "login")
        let request = NSMutableURLRequest(URL: loginURL!)
        request.HTTPMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let bodyStr:String = "studentNumber=" + self.id.text! + "&studentFirstName=" + self.firstName.text! + "&studentLastName=" + self.lastName.text!
        request.HTTPBody = bodyStr.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            (data, response, error) in
            do{
                if (error == nil){
                    guard let loginJson = try NSJSONSerialization.JSONObjectWithData(data!,options: []) as? [String: AnyObject]
                        else {
                            print("Could not get JSON from responseData as dictionary")
                            self.loginFailed()
                            return
                    }
                    print(loginJson)
                    if loginJson["error"] != nil {
                        print(loginJson["error"])
                        self.loginFailed()
                        return
                    }
                    guard let success = loginJson["success"] as? Bool else{
                        print("not bool")
                        self.loginFailed()
                        return
                    }
                    if success{
                        self.loginSuccess()
                    }else{
                        self.loginFailed()
                    }
                }
            } catch {
                self.loginFailed()
                return
            }
        }
        task.resume()
        
    }
    private func loginSuccess(){
        NSOperationQueue.mainQueue().addOperationWithBlock {
//            self.invalidMessage.text = "success"
//            let viewcontroller = WatchVideoVC()
//            self.navigationController!.pushViewController(viewcontroller, animated: true)
            self.userDefaults.setBool(true, forKey: "login")
            let viewcontroller = WatchVideoVC()
//            self.presentViewController(viewcontroller, animated: true, completion: nil)
            self.navigationController!.pushViewController(viewcontroller, animated: true)
        }
        
    }
    private func loginFailed(){
        NSOperationQueue.mainQueue().addOperationWithBlock {
            self.invalidMessage.text = "error"
            self.id.text = nil
            self.firstName.text = nil
            self.lastName.text = nil
        }
    }
    
    
    
    @IBOutlet weak var invalidMessage: UILabel!
    
    
    
    
    
    @IBOutlet weak var id: UITextField!
    
    
    @IBOutlet weak var firstName: UITextField!
    
    
    @IBOutlet weak var lastName: UITextField!
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
