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