//
//  UsersCell.swift
//  Tweeter
//
//  Created by Julio Buendia on 7/11/16.
//  Copyright © 2016 Julio Buendia. All rights reserved.
//

import UIKit

class UsersCell: UITableViewCell {

    // UI obj
    @IBOutlet var avaImg: UIImageView!
    @IBOutlet var usernameLbl: UILabel!
    @IBOutlet var fullnameLbl: UILabel!
    
    
    // first load func
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // round corners
        avaImg.layer.cornerRadius = avaImg.bounds.width / 2
        avaImg.clipsToBounds = true
        
        // color
        usernameLbl.textColor = colorBrandBlue
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
