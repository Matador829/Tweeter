//
//  HomeVC.swift
//  Tweeter
//
//  Created by Julio Buendia on 7/7/16.
//  Copyright © 2016 Julio Buendia. All rights reserved.
//

import UIKit

class HomeVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    // UI Obj
    @IBOutlet var avaImg: UIImageView!
    @IBOutlet var usernameLbl: UILabel!
    @IBOutlet var fullnameLbl: UILabel!
    @IBOutlet var emailLbl: UILabel!
    @IBOutlet var editBtn: UIButton!
    
    
    
    // first load
    override func viewDidLoad() {
        super.viewDidLoad()

        // get user details from user global var
        // shortcuts to shore inf
        let username = user!["username"]?.uppercaseString
        let fullname = user!["fullname"] as! String
        let email = user!["email"] as? String
        let ava = user!["ava"] as? String
        
        // assign values to labels
        usernameLbl.text = username
        fullnameLbl.text = fullname
        emailLbl.text = email
        
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
        avaImg.layer.cornerRadius =  avaImg.bounds.width / 20
        avaImg.clipsToBounds = true
        
        editBtn.setTitleColor(colorBrandBlue, forState: .Normal)
        
        // title on top
        self.navigationItem.title = username
    
    }

    
    
    // edit button clicked
    @IBAction func edit_click(sender: AnyObject) {
        // select ava
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        picker.allowsEditing = true
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    // selected image
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        avaImg.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
        
        // call func of uploading file to server
        uploadAva()
    }

    // custom body of HTTP request to upload image file
    func createBodyWithParams(paramaters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        
        let body = NSMutableData();
        
        if paramaters != nil{
            
            for (key, value) in paramaters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
                
            }
            
        }
        
        let filename = "ava.jpg"
        
        let mimetype = "image/jpg"
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.appendData(imageDataKey)
        body.appendString("\r\n")
        
        body.appendString("--\(boundary)--\r\n")
        
        return body
        
        
    }
    
    
    // upload image to server
    func uploadAva() {
        
        // shortcut id
        let id = user!["id"] as! String
        
        // url path to php file
        let url = NSURL(string: "http://localhost/Tweeter/uploadAva.php")!
        
        // declare request to this file
        let request = NSMutableURLRequest(URL: url)
        
        // declare method of passign inf to this file
        request.HTTPMethod = "POST"
        
        // param to be sent in body of request
        let param = ["id" : id]
        
        // body
        let boundary = "Boundary-\(NSUUID().UUIDString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // compress image and assign to imageData
        let imageData = UIImageJPEGRepresentation(avaImg.image!, 0.5)
        
        // if not compressed, return ... do not continue to code
        if imageData == nil {
            return
        }
        
        // ... body
        request.HTTPBody = createBodyWithParams(param, filePathKey: "file", imageDataKey: imageData!, boundary: boundary)
        
        // launch session
        NSURLSession.sharedSession().dataTaskWithRequest(request) { (data:NSData?, response: NSURLResponse?, error:NSError?) in
         
            // get main queue to communicate back to user
            dispatch_async(dispatch_get_main_queue(), {
                
                if error == nil {
                    
                    do {
                        // json contains $returnArray from php
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                        
                        // declare new parseJSON to store json
                        guard let parseJSON = json else {
                            print("Error while parsing")
                            return
                        }
                        
                        // get id from $returnArray["id"] - parseJSON["id"]
                        let id = parseJSON["id"]
                        
                        // successfully uploaded
                        if id != nil {
                            
                            // save uuser information we received from our host
                            NSUserDefaults.standardUserDefaults().setObject(parseJSON, forKey: "parseJSON")
                            user = NSUserDefaults.standardUserDefaults().valueForKey("parseJSON") as? NSDictionary
                         
                        // did not give back "id" value from server
                        } else {
                            
                            // get main queue to communicate back to user
                            dispatch_async(dispatch_get_main_queue(), {
                                let message = parseJSON["message"] as! String
                                appDelegate.infoView(message: message, color: colorSmoothRed)
                            })
                            
                        }
                        
                        
                     // error while jsoning
                    } catch {
                        
                        // get main queue to communicate back to user
                        dispatch_async(dispatch_get_main_queue(), {
                            let message = error as! String
                            appDelegate.infoView(message: message, color: colorSmoothRed)
                        })
                        
                        
                        
                    }
                    
                  // error with php file
                } else {
                    // get main queue to communicate back to user
                    dispatch_async(dispatch_get_main_queue(), {
                        let message = error!.localizedDescription
                        appDelegate.infoView(message: message, color: colorSmoothRed)
                    })
                }
                
                
            })
            
        }.resume()
        
    }
    
    // clicked logout button
    @IBAction func logout_click(sender: AnyObject) {
        
        // remove saved information
        NSUserDefaults.standardUserDefaults().removeObjectForKey("parseJSON")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        // go back to login page
        let loginvc = self.storyboard?.instantiateViewControllerWithIdentifier("LoginVC") as! LoginVC
        self.presentViewController(loginvc, animated: true, completion: nil)
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        
        
    }
    
    
    
}

// Creating protocol of appending string to var of type data
extension NSMutableData {
    
    func appendString(string : String) {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        appendData(data!)
        
        
    }
    
    
}