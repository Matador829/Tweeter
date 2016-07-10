//
//  PostCell.swift
//  Tweeter
//
//  Created by Julio Buendia on 7/9/16.
//  Copyright © 2016 Julio Buendia. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    // UI Objects
    @IBOutlet var usernameLbl: UILabel!
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var textLbl: UILabel!
    @IBOutlet var pictureImg: UIImageView!
    
    
    
    // first load func
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // color
        usernameLbl.textColor = colorBrandBlue
        
        // round corners
        pictureImg.layer.cornerRadius =  pictureImg.bounds.width / 20
        pictureImg.clipsToBounds = true
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
