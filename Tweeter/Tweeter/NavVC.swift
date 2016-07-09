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
        self.navigationBar.barTintColor = colorBrandBlue
       
        // disable translucent
        self.navigationBar.translucent = false
        
    }

    // white status bar
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    



}
