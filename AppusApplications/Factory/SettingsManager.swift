//
//  ColorManager.swift
//  AppusApplications
//
//  Created by Vladimir Grigoriev on 1/31/17.
//  Copyright © 2017 Appus. All rights reserved.
//

import UIKit

open class SettingsManager: NSObject {
    open static let shared = SettingsManager()
    
    // MARK: UINavigationBar
    open var cancelButtonHidden = false
    open var isTransparentNavigationBar = false
    open var navigationBarImage: UIImage?
    open var navigationBarColor: UIColor?
    open var navigationTitleColor = UIColor.black // default: black
    open var navigationItemColor: UIColor?
    open var cancelButtonImage: UIImage?
    
    // MARK: Rating view
    open var filledRatingImage = UIImage(named: "StarEmpty.png")
    open var emptyRatingImage = UIImage(named: "StarFull.png")
    
    // MARK: Screens parameters
    open var sectionTitleColor = UIColor.black // default: black
    open var backgroundImage: UIImage?
    open var backgroundColor = UIColor.white
    
    // MARK: Details Screen parameter
    open var textColor = UIColor.darkGray // default: darkGrey
    open var infoTextColor = UIColor.black // default: black
    open var separatorColor: UIColor?
    open var purchaseButtonColor: UIColor?
}
