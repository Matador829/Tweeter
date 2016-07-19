//
//  ViewController.swift
//  Tweeter
//
//  Created by Julio Buendia on 6/28/16.
//  Copyright © 2016 Julio Buendia. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController {

    @IBOutlet var usernameTextfield: UITextField!
    
    @IBOutlet var passwordTextfield: UITextField!
    
    @IBOutlet var emailTextfield: UITextField!
    
    @IBOutlet var firstNameTextfield: UITextField!
    
    @IBOutlet var lastNameTextfield: UITextField!
    
    
  
    
    // first func
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //register button clicked
    @IBAction func registerButton(sender: AnyObject) {
    
        if usernameTextfield.text!.isEmpty || passwordTextfield.text!.isEmpty || emailTextfield.text!.isEmpty || firstNameTextfield.text!.isEmpty || lastNameTextfield.text!.isEmpty{
            
            //red placeholders
            usernameTextfield.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSForegroundColorAttributeName: UIColor.redColor()])
            passwordTextfield.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSForegroundColorAttributeName: UIColor.redColor()])
            emailTextfield.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSForegroundColorAttributeName: UIColor.redColor()])
            firstNameTextfield.attributedPlaceholder = NSAttributedString(string: "first name", attributes: [NSForegroundColorAttributeName: UIColor.redColor()])
            lastNameTextfield.attributedPlaceholder = NSAttributedString(string: "last name", attributes: [NSForegroundColorAttributeName: UIColor.redColor()])
            
            //if text is entered
        } else {
            
            // remove keyboard
            self.view.endEditing(true)
            
            // URL to php file
            let url = NSURL(string: "http://localhost/Tweeter/register.php")!
            
            // request to this file
            let request = NSMutableURLRequest(URL: url)
            
            // method to pass data to this file
            request.HTTPMethod = "POST"
            
            //body to be appended to URL
            let body = "username=\(usernameTextfield.text!.lowercaseString)&password=\(passwordTextfield.text!)&email=\(emailTextfield.text!)&fullname=\(firstNameTextfield.text!)%20\(lastNameTextfield.text!)"
            request.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding)
            
            // launching
            NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data: NSData?, response:NSURLResponse?, error: NSError?) in
                
                if error == nil {
                    
                    // get main queue in code process to commmunicate back
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        do {
                            // get json result
                            let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as?
                                NSDictionary
                            
                            // assign json to new var parseJSON in secure way
                            guard let parseJSON = json else {
                                print("Error while parsing")
                                return
                            }
                            
                            // get id from parseJSON dictionary
                            let id = parseJSON["id"]
                            
                            // successfully registered
                            if id != nil{
                                
                                // save user information we received from our host
                                NSUserDefaults.standardUserDefaults().setObject(parseJSON, forKey: "parseJSON")
                                user = NSUserDefaults.standardUserDefaults().valueForKey("parseJSON") as? NSDictionary

                                
                                
                                // go to tabbar / home page
                                dispatch_async(dispatch_get_main_queue(), {
                                    appDelegate.login()
                                })
                                
                                
                            // error
                            } else {
                               
                                // get main queue to communicate back to user
                                dispatch_async(dispatch_get_main_queue(),{
                                    let message = parseJSON["message"] as! String
                                    appDelegate.infoView(message: message, color: colorSmoothRed)
                                })
                                return
                            }
                            
                            
                        } catch {
                            
                            // get main queue to communicate back to user
                            dispatch_async(dispatch_get_main_queue(),{
                                let message = String(error)
                                appDelegate.infoView(message: message, color: colorSmoothRed)
                            })
                            return
                            
                        }
                        
                        
                    })
                   
                 //if unable to proceed request
                } else {
                    
                    // get main queue to communicate back to user
                    dispatch_async(dispatch_get_main_queue(),{
                        let message = error!.localizedDescription
                        appDelegate.infoView(message: message, color: colorSmoothRed)
                    })
                    return
                    
                }
                
                // launch prepared session
            }).resume()
            
        }
        
    }
    
    @IBAction func loginButton(sender: AnyObject) {
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // white status bar
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }


}

