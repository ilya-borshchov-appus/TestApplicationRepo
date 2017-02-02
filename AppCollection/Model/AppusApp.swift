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
    fileprivate(set) var appImagePath = ""
    fileprivate(set) var screenshots : [String] = []
    
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
        self.appImagePath = json["artworkUrl100"].stringValue
        self.screenshots = json["screenshotUrls"].arrayValue.map({$0.stringValue})
        
        if (self.screenshots.count == 0){
            self.screenshots = json["ipadScreenshotUrls"].arrayValue.map({$0.stringValue})
        }
        
        self.appName = json["trackName"].stringValue
        self.appCensoredName = json["trackCensoredName"].stringValue
        self.companyName = json["artistName"].stringValue
        self.sellerName = json["sellerName"].stringValue
        
        self.appDescription = json["description"].stringValue
        self.genres = json["genres"].arrayValue.map({$0.stringValue})
        self.primaryGenre = json["primaryGenreName"].stringValue
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
