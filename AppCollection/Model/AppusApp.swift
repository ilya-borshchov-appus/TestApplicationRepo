//
//  AppusApp.swift
//  AppusApplications
//
//  Created by Feather52 on 1/17/17.
//  Copyright © 2017 Appus. All rights reserved.
//

import UIKit
import SwiftyJSON

class AppusApp: NSObject {
    
    fileprivate enum Keys {
        // Image
        static let appIconURL100 = "artworkUrl100"
        static let appIconURL512 = "artworkUrl512"
        static let screenshotsUrls = "screenshotUrls"
        static let iPadScreenshotsUrls = "ipadScreenshotUrls"
        
        // Name
        static let appName = "trackName"
        static let appCensoredName = "trackCensoredName"
        static let developerName = "artistName"
        static let companyName = "sellerName"
        
        // Details
        static let description = "description"
        static let genres = "genres"
        static let iTunesURL = "trackViewUrl"
        static let formattedPrice = "formattedPrice"
        static let currency = "currency"
        static let languageCodes = "languageCodesISO2A"
        static let version = "version"
        static let minimumOsVersion = "minimumOsVersion"
        static let supportedDevices = "supportedDevices"
        
        // Date
        static let releaseDate = "releaseDate"
        static let currentVersionReleaseDate = "currentVersionReleaseDate"
        
        // Rating
        static let currentRating = "userRatingCountForCurrentVersion"
        static let currrentAverageRating = "averageUserRatingForCurrentVersion"
        static let averageUserRating = "averageUserRating"
        static let contentRating = "trackContentRating"
        static let contentAdvisoryRating = "contentAdvisoryRating"
        static let userRatingCount = "userRatingCount"
    }
    
    // Image
    private(set) var appImagePath = ""
    private(set) var appImagePathForCell = ""
    private(set) var screenshots : [String] = []
    private(set) var isIPadScreenshots = false
    
    // Name
    private(set) var appName = ""
    private(set) var appCensoredName = ""
    private(set) var companyName = ""
    private(set) var sellerName = ""
    
    // Details
    private(set) var appDescription = ""
    private(set) var genres : [String] = []
    private(set) var primaryGenre = ""
    private(set) var url = ""
    private(set) var price = ""
    private(set) var currency = ""
    private(set) var languageCodes : [String] = []
    private(set) var versionNumber = ""
    private(set) var minVersion = ""
    private(set) var suportedDevices : [String] = []
    
    // Date
    private(set) var date = ""
    private(set) var currentVersionDate = ""
    
    // Rating
    private(set) var currentRating = ""
    private(set) var currrentAverageRating = ""
    private(set) var averageRating = ""
    private(set) var contentRating = ""
    private(set) var contentAdvisoryRating = ""
    private(set) var userRatingCount = ""
    
    override var description : String {
        var text = "Name: \(self.appName)\n"
        text.append("Censored name: \(self.appCensoredName)\n")
        text.append("Company name: \(self.companyName)\n")
        text.append("Seller name: \(self.sellerName)\n")
        text.append("Price: \(self.price)\n")
        text.append("Screenshots: \(self.screenshots)")
        
        return text
    }

    func initWith(json: JSON) {
        print (json)
        let idiom = UIDevice.current.userInterfaceIdiom
        
        self.appImagePathForCell = json[Keys.appIconURL100].stringValue
        
        if idiom == .pad {
            self.appImagePath = json[Keys.appIconURL512].stringValue
            
            if json[Keys.iPadScreenshotsUrls].count > 0 {
                self.screenshots = json[Keys.iPadScreenshotsUrls].arrayValue.map({$0.stringValue})
                self.isIPadScreenshots = true
            } else {
                self.screenshots = json[Keys.screenshotsUrls].arrayValue.map({$0.stringValue})
            }
        } else {
            self.appImagePath = json[Keys.appIconURL100].stringValue
            
            if json[Keys.screenshotsUrls].count > 0 {
                self.screenshots = json[Keys.screenshotsUrls].arrayValue.map({$0.stringValue})
            } else {
                self.screenshots = json[Keys.iPadScreenshotsUrls].arrayValue.map({$0.stringValue})
                self.isIPadScreenshots = true
            }
        }
        
        self.appName = json[Keys.appName].stringValue
        self.appCensoredName = json[Keys.appCensoredName].stringValue
        self.companyName = json[Keys.developerName].stringValue
        self.sellerName = json[Keys.companyName].stringValue
        
        self.appDescription = json[Keys.description].stringValue
        self.genres = json[Keys.genres].arrayValue.map({$0.stringValue})
        self.primaryGenre = json[Keys.genres][0].stringValue
        self.url = json[Keys.iTunesURL].stringValue
        self.price = json[Keys.formattedPrice].stringValue
        self.currency = json[Keys.currency].stringValue
        self.languageCodes = json[Keys.languageCodes].arrayValue.map({$0.stringValue})
        self.versionNumber = json[Keys.version].stringValue
        self.minVersion = json[Keys.minimumOsVersion].stringValue
        self.suportedDevices = json[Keys.supportedDevices].arrayValue.map({$0.stringValue})
        
        self.date = json[Keys.releaseDate].stringValue
        self.currentVersionDate = json[Keys.currentVersionReleaseDate].stringValue
        
        self.currentRating = json[Keys.currentRating].stringValue
        self.currrentAverageRating = json[Keys.currrentAverageRating].stringValue
        self.averageRating = json[Keys.averageUserRating].stringValue
        self.contentRating = json[Keys.contentRating].stringValue
        self.contentAdvisoryRating = json[Keys.contentAdvisoryRating].stringValue
        self.userRatingCount = json[Keys.userRatingCount].stringValue
    }
}
