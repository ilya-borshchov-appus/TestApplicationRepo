//
//  ColorManager.swift
//  AppusApplications
//
//  Created by Vladimir Grigoriev on 1/31/17.
//  Copyright © 2017 Appus. All rights reserved.
//

import UIKit

class ColorManager: NSObject {
    open static let shared = ColorManager()
    
    // MARK: UINavigationBar
    var isTransparentNavigationBar = false
    var navigationBarImage: UIImage?
    var navigationBarColor: UIColor?
    var navigationTitleColor = UIColor.black // default: black
    var navigationItemColor: UIColor?
    var cancelButtonImage: UIImage?
    
    // MARK: Rating view
    var filledRatingImage = UIImage(named: "StarEmpty")
    var emptyRatingImage = UIImage(named: "StarFull")
    
    // MARK: Screens parameters
    var sectionTitleColor = UIColor.black // default: black
    var backgroundImage: UIImage?
    var backgroundColor = UIColor.white
    
    // MARK: Details Screen parameter
    var textColor = UIColor.darkGray // default: darkGrey
    var infoTextColor = UIColor.black // default: black
    var separatorColor: UIColor?
    var purchaseButtonColor: UIColor?
}
