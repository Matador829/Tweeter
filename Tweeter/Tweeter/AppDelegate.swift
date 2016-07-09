//
//  AppDelegate.swift
//  Tweeter
//
//  Created by Julio Buendia on 6/28/16.
//  Copyright © 2016 Julio Buendia. All rights reserved.
// yes

import UIKit

// global variable refered to appDelegat to be able to call it from any class / fire.swift
let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

let colorSmoothRed = UIColor(red: 255/255, green: 50/255, blue: 75/255, alpha: 1)
let colorLightGreen = UIColor(red: 30/255, green: 244/255, blue: 125/255, alpha: 1)
let colorLightGray = UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1)
let colorBrandBlue = UIColor(red: 45/255, green: 213/255, blue: 255/255, alpha: 1)

let fontSize12 = UIScreen.mainScreen().bounds.width / 31

// stores all information about user
var user : NSDictionary?

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // Image to be animated
    let backgroundImg = UIImageView()
    
    // boolean to check is errorView showing or not
    var infoViewIsShowing = false


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        
        // creating imageView to store background image "mainbg.jpg"
        backgroundImg.frame = CGRectMake(0, 0, self.window!.bounds.height * 1.688, self.window!.bounds.height)
        backgroundImg.image = UIImage(named: "mainbg.jpg")
        self.window!.addSubview(backgroundImg)
        moveBGLeft()
        
        // load content in user var
        user = NSUserDefaults.standardUserDefaults().valueForKey("parseJSON") as? NSDictionary
        print(user)
        
        // id user once logged in / registered, keep him logged in
        if user != nil {
            
            let id = user!["id"] as? String
            if id != nil{
             
                login()
                
            }
        }
        
        
        return true
    }
    
    
    
    // function to animate bg to move left
    func moveBGLeft(){
        
        // begin animation
        UIView.animateWithDuration(45, animations: {
            
            // changer origin
            self.backgroundImg.frame.origin.x = -self.backgroundImg.bounds.width + self.window!.bounds.width
        
        }) { (finished:Bool) in
            
                // if animation finished execute func moveBGRight
                if finished{
                
                self.moveBGRight()
                
            }
        }
        
    }
    
    // function to animate bg to move right
    func moveBGRight(){
        
        // begin animation
        UIView.animateWithDuration(45, animations: {
            
            // moving bacj hor origin
            self.backgroundImg.frame.origin.x = 0}) { (finished:Bool) in
            
                // id animation finished, exec func moveRight
            if finished{
                
                self.moveBGLeft()
                
            }
        }
    }

    // error view on top
    func infoView(message message: String, color:UIColor) {
        
        // if errorView is not showing...
        if infoViewIsShowing == false {
            
            // cast as errorView currently showing
            infoViewIsShowing = true
            
           
            // red background creation
            let infoView_Height = self.window!.bounds.height / 14.2
            let infoView_Y = 0 - infoView_Height
            
            
            let infoView = UIView(frame: CGRectMake(0,infoView_Y, self.window!.bounds.width, infoView_Height))
            infoView.backgroundColor = color
            self.window!.addSubview(infoView)
            
            
            // errorLabel - label to show error text
            let infoLabel_Width = infoView.bounds.width
            let infoLabel_Height = infoView.bounds.height + UIApplication.sharedApplication().statusBarFrame.height / 2
            
            let infoLabel = UILabel()
            infoLabel.frame.size.width = infoLabel_Width
            infoLabel.frame.size.height = infoLabel_Height
            infoLabel.numberOfLines = 0
            
            infoLabel.text = message
            infoLabel.font = UIFont(name: "HelveticaNeue", size: fontSize12)
            infoLabel.textColor = .whiteColor()
            infoLabel.textAlignment = .Center
            
            infoView.addSubview(infoLabel)
            
            // animate  error view
            UIView.animateWithDuration(0.2, animations:{
                
                    // move down errorView
                    infoView.frame.origin.y = 0
                    
                    // if animation did finish
                }, completion: {(finished:Bool) in
                    
                    // if it is true
                    if finished {
                        
                        UIView.animateWithDuration(0.1, delay: 4, options: .CurveLinear, animations: {
                            
                            // move up errorView
                            infoView.frame.origin.y = -infoView_Height
                            
                            // if finished all animations
                            }, completion:  {(finished:Bool) in
                                
                                if finished {
                                    
                                    infoView.removeFromSuperview()
                                    infoLabel.removeFromSuperview()
                                    self.infoViewIsShowing = false
                                }
                            })
                        
                        }
                })
            }
        
        }
    
    // func to pass to home page to tabBar
    func login(){
        
        // refer to our Main.storyboard
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        // store our tabBar Object from Main.storyboard in tabVar var
        let tabBar = storyBoard.instantiateViewControllerWithIdentifier("tabBar")
        
        // present tabBar that is storing in tabBar var
        window?.rootViewController = tabBar
        
    }
    
    
    
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

