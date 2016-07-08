//
//  NavVC.swift
//  Tweeter
//
//  Created by Julio Buendia on 7/6/16.
//  Copyright © 2016 Julio Buendia. All rights reserved.
//

import UIKit

class NavVC: UINavigationController {

    // first load func
    override func viewDidLoad() {
        super.viewDidLoad()

        // color of title at the top of nav controller
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        // create color of buttons in nav controller
        self.navigationBar.tintColor = .whiteColor()
        
        // color of background of nav controller / nav bar
        self.navigationBar.barTintColor = UIColor(red: 45/255, green: 213/255, blue: 255/255, alpha: 1)
       
        // disable translucent
        self.navigationBar.translucent = false
        
    }

    // white status bar
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    



}
