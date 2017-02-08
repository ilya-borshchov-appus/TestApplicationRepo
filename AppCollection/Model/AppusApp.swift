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
    fileprivate(set) var appImagePath = ""
    fileprivate(set) var appImagePathForCell = ""
    fileprivate(set) var screenshots : [String] = []
    fileprivate(set) var isIPadScreenshots = false
    
    // Name
    fileprivate(set) var appName = ""
    fileprivate(set) var appCensoredName = ""
    fileprivate(set) var companyName = ""
    fileprivate(set) var sellerName = ""
    
    // Details
    fileprivate(set) var appDescription = ""
    fileprivate(set) var genres : [String] = []
    fileprivate(set) var primaryGenre = ""
    fileprivate(set) var url = ""
    fileprivate(set) var price = ""
    fileprivate(set) var currency = ""
    fileprivate(set) var languageCodes : [String] = []
    fileprivate(set) var versionNumber = ""
    fileprivate(set) var minVersion = ""
    fileprivate(set) var suportedDevices : [String] = []
    
    // Date
    fileprivate(set) var date = ""
    fileprivate(set) var currentVersionDate = ""
    
    // Rating
    fileprivate(set) var currentRating = ""
    fileprivate(set) var currrentAverageRating = ""
    fileprivate(set) var averageRating = ""
    fileprivate(set) var contentRating = ""
    fileprivate(set) var contentAdvisoryRating = ""
    fileprivate(set) var userRatingCount = ""
    
    override var description : String {
        var text = "Name: \(self.appName)\n"
        text.append("Censored name: \(self.appCensoredName)\n")
        text.append("Company name: \(self.companyName)\n")
        text.append("Seller name: \(self.sellerName)\n")
        text.append("Price: \(self.price)\n")
        text.append("Screenshots: \(self.screenshots)")
        
        return text
    }

    func initWith(_ json: JSON) {
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
    
    func initWith(dictionary: [String: Any]) {
        
        self.appImagePath = dictionary[Keys.appIconURL100] as? String ?? ""
        self.screenshots = dictionary[Keys.screenshotsUrls] as? [String] ?? []
        
        if (self.screenshots.count == 0){
            self.screenshots = dictionary[Keys.iPadScreenshotsUrls] as? [String] ?? []
        }
        
        self.appName = dictionary[Keys.appName] as? String ?? ""
        self.appCensoredName = dictionary[Keys.appCensoredName] as? String ?? ""
        self.companyName = dictionary[Keys.developerName] as? String ?? ""
        self.sellerName = dictionary[Keys.companyName] as? String ?? ""
        self.appDescription = dictionary[Keys.description] as? String ?? ""
        self.genres = dictionary[Keys.genres] as? [String] ?? []
        self.primaryGenre =  ((dictionary[Keys.genres] as! Array)[0] as? String)! 
        self.url = dictionary[Keys.iTunesURL] as? String ?? ""
        self.price = dictionary[Keys.formattedPrice] as? String ?? ""
        self.currency = dictionary[Keys.currency] as? String ?? ""
        self.languageCodes = dictionary[Keys.languageCodes] as? [String] ?? []
        self.versionNumber = dictionary[Keys.version] as? String ?? ""
        self.minVersion = dictionary[Keys.minimumOsVersion] as? String ?? ""
        self.suportedDevices = dictionary[Keys.supportedDevices] as? [String] ?? []
        self.date = dictionary[Keys.releaseDate] as? String ?? ""
        self.currentVersionDate = dictionary[Keys.currentVersionReleaseDate] as? String ?? ""
        self.currentRating = dictionary[Keys.currentRating] as? String ?? ""
        self.currrentAverageRating = dictionary[Keys.currrentAverageRating] as? String ?? ""
        self.averageRating = dictionary[Keys.averageUserRating] as? String ?? ""
        self.contentRating = dictionary[Keys.contentRating] as? String ?? ""
        self.contentAdvisoryRating = dictionary[Keys.contentAdvisoryRating] as? String ?? ""
        self.userRatingCount = dictionary[Keys.userRatingCount] as? String ?? ""
    }
}
