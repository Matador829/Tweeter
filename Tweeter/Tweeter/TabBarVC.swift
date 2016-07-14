//
//  TabBarVC.swift
//  Tweeter
//
//  Created by Julio Buendia on 7/6/16.
//  Copyright © 2016 Julio Buendia. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController {

    // first load func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // gray color of tabBar items
        let color = colorLightGray
        
        // color of item in tabbar controller
        self.tabBar.tintColor = .whiteColor()
        
        // color of background of tabbar controller
        self.tabBar.barTintColor = colorBrandBlue
        
        // disable translucent
        self.tabBar.translucent = false
        
        // color of text under icon in tabbar controller
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : color], forState: .Normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.whiteColor()], forState: .Selected)
        
        // new color for all icons of tabbar controller
        for item in self.tabBar.items! as [UITabBarItem]{
            
            if let image = item.image {
                
                item.image = image.imageColor(color).imageWithRenderingMode(.AlwaysOriginal)
           
            }
            
            
        }
        
        // call Animation of Tweeter
        tweeterAnimation()
    }
    
    // Tweeter Brand Animation
    func tweeterAnimation() {
        
        let layer = UIView() // declare var of type UIView
        layer.frame = self.view.frame // declare size = same as screen
        layer.backgroundColor = colorBrandBlue // color of view
        self.view.addSubview(layer) // add view to vc
        
        // Tweeter icon
        let icon = UIImageView() // declare var of type uiImageView Because it stores an image
        icon.image = UIImage(named: "logo.png") // we refer to our image to be stored
        icon.frame.size.width = 200 // width of image view
        icon.frame.size.height = 200 // heigh of image view
        icon.center = view.center // center imageview as per screen size
        self.view.addSubview(icon) // imageview to vc
        
        // starting animation
        UIView.animateWithDuration(0.5, delay: 1, options: .CurveLinear, animations: {
            
            // make small bird
            icon.transform = CGAffineTransformMakeScale(0.9, 0.9)
            
        }) { (finished:Bool) in
            
            if finished {
                
                // second animation
                UIView.animateWithDuration(0.5, animations: { 
                    
                   // make big icon
                    icon.transform = CGAffineTransformMakeScale(20, 20)
                    
                    // third animation
                    UIView.animateWithDuration(0.1, delay: 0.3, options: .CurveLinear, animations: { 
                        
                        icon.alpha = 0
                        layer.alpha = 0
                        
                        }, completion: nil)
                    
                })
                
            }
        
        }
    }



}

// new class created to refer to our icon in tabbar controller

extension UIImage {
    
    // in this class we customize our UIImage - our icon
    func imageColor(color : UIColor) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        let context = UIGraphicsGetCurrentContext()! as CGContextRef
        CGContextTranslateCTM(context, 0, self.size.height)
        CGContextScaleCTM(context, 1.0, -1.0)
        
        let rect = CGRectMake(0, 0, self.size.width, self.size.height) as CGRect
        CGContextClipToMask(context, rect, self.CGImage)
       
        
        color.setFill()
        CGContextFillRect(context, rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
        
    }
    
}