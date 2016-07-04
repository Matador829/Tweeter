//
//  AppDelegate.swift
//  Tweeter
//
//  Created by Julio Buendia on 6/28/16.
//  Copyright © 2016 Julio Buendia. All rights reserved.
// yes

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // Image to be animated
    let backgroundImg = UIImageView()


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        
        // creating imageView to store background image "mainbg.jpg"
        backgroundImg.frame = CGRectMake(0, 0, self.window!.bounds.height * 1.688, self.window!.bounds.height)
        backgroundImg.image = UIImage(named: "mainbg.jpg")
        self.window!.addSubview(backgroundImg)
        moveBGLeft()
        
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

