//
//  ResetVC.swift
//  Tweeter
//
//  Created by Julio Buendia on 7/1/16.
//  Copyright © 2016 Julio Buendia. All rights reserved.
//

import UIKit

class ResetVC: UIViewController {

    // UI object
    @IBOutlet var emailTxt: UITextField!
    
    
    // first function
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // Reset Button Clicked
    @IBAction func resetButton(sender: AnyObject) {
        
        // if no text entered
        if emailTxt.text!.isEmpty {
            
            //red placeholders
            emailTxt.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName: UIColor.redColor()])
        
        } else {
            
            let email = emailTxt.text!.lowercaseString
            
           // send mysql / php. request
            
            // path to php file
            let url = NSURL(string: "http://localhost/Tweeter/resetPassword.php")!
            
            // request to send to this file
            let request = NSMutableURLRequest(URL: url)
            
            // method of passing inf to this file
            request.HTTPMethod = "POST"
            
            // body to be appended to url. It passes inf to this file
            let body = "email=\(email)"
            request.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding)
            
            // process request
            NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) in
                if error == nil{
                    
                    // give main queue to UI to communicate back
                    dispatch_async(dispatch_get_main_queue(), {
                        do {
                            let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                            
                            guard let parseJSON  = json else {
                                print("Error while parsing")
                                return
                            }
                            
                            // successfully reset
                            let email = parseJSON["email"]
                            if email != nil {
                                
                                // get main queue to communicate back to user
                                dispatch_async(dispatch_get_main_queue(),{
                                    let message = parseJSON["message"] as! String
                                    appDelegate.infoView(message: message, color: colorLightGreen)
                                })
                                
                             // error
                            } else {
                                
                                // get main queue to communicate back to user
                                dispatch_async(dispatch_get_main_queue(),{
                                    let message = parseJSON["message"] as! String
                                    appDelegate.infoView(message: message, color: colorSmoothRed)
                                })
                                
                            }
                            
                        } catch {
                            
                            // get main queue to communicate back to user
                            dispatch_async(dispatch_get_main_queue(),{
                                let message = String(error)
                                appDelegate.infoView(message: message, color: colorSmoothRed)
                            })
                            
                        }
                    })
                    
                } else {
                    
                     // get main queue to communicate back to user
                    dispatch_async(dispatch_get_main_queue(),{
                        let message = error!.localizedDescription
                        appDelegate.infoView(message: message, color: colorSmoothRed)
                    })
                    
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
