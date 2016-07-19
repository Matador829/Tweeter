//
//  LoginVC.swift
//  Tweeter
//
//  Created by Julio Buendia on 7/1/16.
//  Copyright © 2016 Julio Buendia. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    //UI Object
    @IBOutlet var usernameTxt: UITextField!
    
    @IBOutlet var passwordTxt: UITextField!
    
   // First Function
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Clicked Login Button
    @IBAction func loginButton(sender: AnyObject) {
        
        // if no text enterd
        if usernameTxt.text!.isEmpty || passwordTxt.text!.isEmpty {
            //red placeholders
            usernameTxt.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSForegroundColorAttributeName: UIColor.redColor()])
            passwordTxt.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor.redColor()])
            
            //if text is entered
        } else {
            
            // remove keyboard
            self.view.endEditing(true)
            
            // shortcuts
            let username = usernameTxt.text!.lowercaseString
            let password = passwordTxt.text!
            
            // send request to mysql db
            // url to access our php file
            let url = NSURL(string: "http://localhost/Tweeter/login.php")!
            
            // request url
            let request = NSMutableURLRequest(URL: url)
            
            // method to pass data POST - because it is secured
            request.HTTPMethod = "POST"
            
            // body going to be appended to url
            let body = "username=\(username)&password=\(password)"
            
            // append body to our request that is going to be sent
            request.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding)
            
            // launch session
            NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {(data:NSData?, response:NSURLResponse?, error:NSError?) in
                
                // no error
                if error == nil {
                    do {
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                        
                        guard let parseJSON = json else {
                            print("Error while parsing")
                            return
                        }
                        
                        print(parseJSON)
                        
                        let id = parseJSON["id"] as? String
                        
                         // successfully logged in
                        if id != nil {
                            
                            // save user information we received from host
                            NSUserDefaults.standardUserDefaults().setObject(parseJSON, forKey: "parseJSON")
                            user = NSUserDefaults.standardUserDefaults().valueForKey("parseJSON") as? NSDictionary
                            
                            // Clear text fields
                            self.usernameTxt.text = ""
                            self.passwordTxt.text = ""
                            
                            self.view.removeFromSuperview()
                            
                            // go to tabbar / home page
                            dispatch_async(dispatch_get_main_queue(), {
                                appDelegate.login()
                                
                                
                        
                        })
                            
                        // error
                        } else {
                            dispatch_async(dispatch_get_main_queue(),{
                            let message = parseJSON["message"] as! String
                            appDelegate.infoView(message: message, color: colorSmoothRed)
                            })
                            return
                            
                        }
                        
                        
                    } catch {
                        dispatch_async(dispatch_get_main_queue(),{
                            let message = String(error)
                           appDelegate.infoView(message: message, color: colorSmoothRed)
                        })
                        return
                    }
                    
                } else {
                    
                    dispatch_async(dispatch_get_main_queue(),{
                        let message = error!.localizedDescription
                        appDelegate.infoView(message: message, color: colorSmoothRed)
                    })
                    return
                }
                
            }).resume()
            
            
        }
        
        
    }
    
    // white status bar
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    // touched scnreen
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        // hide keyboard
        self.view.endEditing(false)
    }


}
