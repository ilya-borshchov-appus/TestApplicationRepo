//
//  ApplicationTableViewCell.swift
//  AppusApplications
//
//  Created by Feather52 on 1/16/17.
//  Copyright © 2017 Appus. All rights reserved.
//

import UIKit

class ApplicationTableViewCell: UITableViewCell {

    @IBOutlet weak var appLabel : UILabel!
    @IBOutlet weak var appImage : UIImageView!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var countRating: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        appLabel.textColor = ColorManager.shared.sectionTitleColor
    }
    
}
