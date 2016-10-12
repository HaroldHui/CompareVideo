//
//  LoginVC.swift
//  NICA
//
//  Created by lyx_xuan on 16/9/2o.
//  Copyright © 2016年 Johan Albert. All rights reserved.
//

import UIKit


class LoginVC: UIViewController,UITextFieldDelegate {
    
    var userDefaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        id.attributedPlaceholder = NSAttributedString(string:"  Trainer ID",
                                                      attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        firstName.attributedPlaceholder = NSAttributedString(string:"  First Name",
                                                             attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        lastName.attributedPlaceholder = NSAttributedString(string:"  Last Name",
                                                            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        id.textAlignment = .Center
        firstName.textAlignment = .Center
        lastName.textAlignment = .Center
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == id{
            firstName.becomeFirstResponder()
        }else if(textField == firstName){
            lastName.becomeFirstResponder()
        }else{
            loginFunc()
        }
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(sender: UIButton) {
        loginFunc()
        
    }
    
    private func loginFunc(){
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
                    if loginJson["error"] != nil {
                        self.loginFailed()
                        return
                    }
                    guard let success = loginJson["success"] as? Bool else{
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
        showSpinner()
    }
    private func loginSuccess(){
        NSOperationQueue.mainQueue().addOperationWithBlock {
            self.hideSpinner()
            self.userDefaults.setBool(true, forKey: "login")
            let viewcontroller = WelcomeVC()
            self.navigationController!.pushViewController(viewcontroller, animated: true)
        }
        
    }
    private func loginFailed(){
        NSOperationQueue.mainQueue().addOperationWithBlock {
            self.hideSpinner()
            self.id.text = nil
            self.firstName.text = nil
            self.lastName.text = nil
            let alert = UIAlertController(title: "Error", message:"An error occurred during the login. Try again!", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Cancel) { _ in }
            alert.addAction(action)
            self.navigationController!.presentViewController(alert, animated: true){}
            
        }
    }
    
    @IBOutlet weak var invalidMessage: UILabel!
    
    @IBOutlet weak var id: UITextField!
    
    
    @IBOutlet weak var firstName: UITextField!
    
    
    @IBOutlet weak var lastName: UITextField!
    
    // snipper
    
    
    var activityIndicator:UIActivityIndicatorView?
    var activityIndicatorView: UIView?
    
    @IBOutlet weak var loginButton: UIButton!
    
    func showSpinner () {
        self.loginButton.userInteractionEnabled = false
        
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
    
    func hideSpinner () {
        self.activityIndicator?.stopAnimating()
        self.activityIndicator?.removeFromSuperview()
        self.activityIndicatorView?.removeFromSuperview()
        
        self.loginButton.userInteractionEnabled = true
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
