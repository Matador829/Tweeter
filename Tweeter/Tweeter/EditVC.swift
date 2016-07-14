//
//  EditVC.swift
//  Tweeter
//
//  Created by Julio Buendia on 7/13/16.
//  Copyright © 2016 Julio Buendia. All rights reserved.
//

import UIKit

class EditVC: UIViewController, UITextFieldDelegate {

    // UI Obj
    @IBOutlet var usernameTxt: UITextField!
    @IBOutlet var firstNameTxt: UITextField!
    @IBOutlet var lastNameTxt: UITextField!
    @IBOutlet var fullnameLbl: UILabel!
    @IBOutlet var emailTxt: UITextField!
    @IBOutlet var avaImg: UIImageView!
    @IBOutlet var saveBtn: UIButton!
    
    
    // first default function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // shortcuts
        let username = user!["username"] as? String
        let fullname = user!["fullname"] as? String
        let fullnameArray = fullname!.characters.split {$0 == " "}.map(String.init) // include 'Firstname Lastname' as array of separated elements
        let firstname = fullnameArray[0]
        let lastname = fullnameArray[1]
        
        let email = user!["email"] as? String
        let ava = user!["ava"] as? String
        
        // assign shortcuts to obj
        navigationItem.title = "Profile"
        usernameTxt.text = username
        firstNameTxt.text = firstname
        lastNameTxt.text = lastname
        emailTxt.text = email
        fullnameLbl.text = "\(firstNameTxt.text!) \(lastNameTxt.text!)"
        
        
        // get user profile picture
        if ava != "" {
            
            // url path to image
            let imageURL = NSURL(string: ava!)!
            
            // communicate back user as main queue
            dispatch_async(dispatch_get_main_queue(), {
                
                // get data from image url
                let imageData = NSData(contentsOfURL: imageURL)
                
                // if data is not nil assign it to ava.Img
                if imageData != nil {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.avaImg.image = UIImage(data: imageData!)
                    })
                    
                }
                
            })
            
        }
        
        // round corners
        avaImg.layer.cornerRadius = avaImg.bounds.width / 2
        avaImg.clipsToBounds = true
        
        // color
        saveBtn.backgroundColor = colorBrandBlue
        
        // disable button initially
        saveBtn.layer.cornerRadius = saveBtn.bounds.width / 5
        saveBtn.enabled = false
        saveBtn.alpha = 0.4
        
        
        // delegating textFields
        usernameTxt.delegate = self
        firstNameTxt.delegate = self
        lastNameTxt.delegate = self
        emailTxt.delegate = self
        
        // add target to textfield as execution of function
        firstNameTxt.addTarget(self, action: #selector(EditVC.textFieldDidChange(_:)), forControlEvents: .EditingChanged)
        lastNameTxt.addTarget(self, action: #selector(EditVC.textFieldDidChange(_:)), forControlEvents: .EditingChanged)
        usernameTxt.addTarget(self, action: #selector(EditVC.textFieldDidChange(_:)), forControlEvents: .EditingChanged)
        emailTxt.addTarget(self, action: #selector(EditVC.textFieldDidChange(_:)), forControlEvents: .EditingChanged)

        
    }
    
    // called once entered any chars in name / surname textfields
    func textFieldDidChange(textField : UITextView){
        
        fullnameLbl.text = "\(firstNameTxt.text!) \(lastNameTxt.text!)"
        
        // if text fields are empty - disable save button
        if usernameTxt.text!.isEmpty || firstNameTxt.text!.isEmpty || lastNameTxt.text!.isEmpty || emailTxt.text!.isEmpty {
            
            saveBtn.enabled = false
            saveBtn.alpha = 0.4
            
            // enable button if changed and there is some text
        } else {
            saveBtn.enabled = true
            saveBtn.alpha = 1
        }

        
    }
    
    
    // clicked save button
    @IBAction func save_clicked(sender: AnyObject) {
    
        if usernameTxt.text!.isEmpty || firstNameTxt.text!.isEmpty || lastNameTxt.text!.isEmpty || emailTxt.text!.isEmpty {
            
            //red placeholders
            usernameTxt.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSForegroundColorAttributeName: colorSmoothRed])
            firstNameTxt.attributedPlaceholder = NSAttributedString(string: "First Name", attributes: [NSForegroundColorAttributeName: colorSmoothRed])
            lastNameTxt.attributedPlaceholder = NSAttributedString(string: "Last Name", attributes: [NSForegroundColorAttributeName: colorSmoothRed])
            emailTxt.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName: colorSmoothRed])
            
            //if text is entered
        } else {
            
            // remove keyboard
            self.view.endEditing(true)
            
            // shortcuts
            let username = usernameTxt.text!.lowercaseString
            let fullname = fullnameLbl.text
            let email = emailTxt.text!.lowercaseString
            let id = user!["id"]!
            
            // preparing request to be sent
            let url = NSURL(string: "http://localhost/Tweeter/updateUser.php")!
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            let body = "username=\(username)&fullname=\(fullname)&email=\(email)&id=\(id)"
            request.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding)
            
            // sending request
            NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) in
                
                // no error
                if error == nil {
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        do {
                            // declare json var to store $returnArray from php file
                            let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                            
                            // assign json to new secure var prevent from crashing
                            guard let parseJSON = json else {
                                print("Error while parsing")
                                return
                            }
                            
                            // get if from parseJSON dictionary
                            let id = parseJSON["id"]
                            
                            // successfully updated
                            if id != nil {
                                
                                // save user information we received from host
                                NSUserDefaults.standardUserDefaults().setObject(parseJSON, forKey: "parseJSON")
                                user = NSUserDefaults.standardUserDefaults().valueForKey("parseJSON") as? NSDictionary
                                
                                // go to tabbar / home page
                                dispatch_async(dispatch_get_main_queue(), {
                                    appDelegate.login()
                                })

                                
                            }
                       
                        // error while jsoning
                        } catch {
                            print("Caught an error: \(error)")
                        }
                        
                    })
                    
                // error with php request
                } else {
                    print("Error: \(error)")
                }
                
                
            }).resume()
            
            
        }
    
    
    }


}
