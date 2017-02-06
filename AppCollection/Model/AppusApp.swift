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
        
        self.appImagePathForCell = json["artworkUrl100"].stringValue
        
        if idiom == .pad {
            self.appImagePath = json["artworkUrl512"].stringValue
            
            if json["ipadScreenshotUrls"].count > 0 {
                self.screenshots = json["ipadScreenshotUrls"].arrayValue.map({$0.stringValue})
                self.isIPadScreenshots = true
            } else {
                self.screenshots = json["screenshotUrls"].arrayValue.map({$0.stringValue})
            }
        } else {
            self.appImagePath = json["artworkUrl100"].stringValue
            
            if json["screenshotUrls"].count > 0 {
                self.screenshots = json["screenshotUrls"].arrayValue.map({$0.stringValue})
            } else {
                self.screenshots = json["ipadScreenshotUrls"].arrayValue.map({$0.stringValue})
                self.isIPadScreenshots = true
            }
        }
        
        self.appName = json["trackName"].stringValue
        self.appCensoredName = json["trackCensoredName"].stringValue
        self.companyName = json["artistName"].stringValue
        self.sellerName = json["sellerName"].stringValue
        
        self.appDescription = json["description"].stringValue
        self.genres = json["genres"].arrayValue.map({$0.stringValue})
        self.primaryGenre = json["genres"][0].stringValue
        self.url = json["trackViewUrl"].stringValue
        self.price = json["formattedPrice"].stringValue
        self.currency = json["currency"].stringValue
        self.languageCodes = json["languageCodesISO2A"].arrayValue.map({$0.stringValue})
        self.versionNumber = json["version"].stringValue
        self.minVersion = json["minimumOsVersion"].stringValue
        self.suportedDevices = json["supportedDevices"].arrayValue.map({$0.stringValue})
        
        self.date = json["releaseDate"].stringValue
        self.currentVersionDate = json["currentVersionReleaseDate"].stringValue
        
        self.currentRating = json["userRatingCountForCurrentVersion"].stringValue
        self.currrentAverageRating = json["averageUserRatingForCurrentVersion"].stringValue
        self.averageRating = json["averageUserRating"].stringValue
        self.contentRating = json["trackContentRating"].stringValue
        self.contentAdvisoryRating = json["contentAdvisoryRating"].stringValue
        self.userRatingCount = json["userRatingCount"].stringValue
    }
}
