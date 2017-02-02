//
//  DetailViewController.swift
//  AppusApplications
//
//  Created by Feather52 on 1/20/17.
//  Copyright © 2017 Appus. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

let CsvLanguagesPath = "languages_isoa2"
let CompatibleiPhoneAndiPod = "Compatible with iPhone and iPod touch."
let CompatibleiPad = "Compatible with iPad."
let CompatibleAll = "Compatible with iPhone, iPad and iPod touch."
let MinVersion = "Requires iOS %@ or later. %@"
let CellId = "cellId"
let DateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

class DetailViewController: UIViewController {
    var selectedApp : AppusApp?
    
    @IBOutlet weak var backgroundView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var appRating: FloatRatingView!
    @IBOutlet weak var appImage: UIImageView!
    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var iTunesButton: UIButton!
    @IBOutlet weak var detailDescription: UILabel!
    @IBOutlet weak var developerInfo: UILabel!
    @IBOutlet weak var categoryInfo: UILabel!
    @IBOutlet weak var updatedInfo: UILabel!
    @IBOutlet weak var ratingInfo: UILabel!
    @IBOutlet weak var compatibilityInfo: UILabel!
    @IBOutlet weak var languagesInfo: UILabel!
    @IBOutlet var separators: [UIView]!
    @IBOutlet var sectionTitles: [UILabel]!
    @IBOutlet var textLabels: [UILabel]!
    @IBOutlet var infoTextLabels: [UILabel]!
    
    fileprivate let colorManager = ColorManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTheme()
        self.initLayout()
    }
    
    // MARK: Init UI
    fileprivate func setupTheme() {
    
        self.containerView.backgroundColor = UIColor.clear
        self.backgroundView.image = self.colorManager.backgroundImage
        self.view.backgroundColor = self.colorManager.backgroundColor
        self.iTunesButton.setTitleColor(self.colorManager.purchaseButtonColor, for: .normal)
        self.setColor(self.colorManager.sectionTitleColor, for: self.sectionTitles)
        self.setColor(self.colorManager.textColor, for: self.textLabels)
        self.setColor(self.colorManager.infoTextColor, for: self.infoTextLabels)
        
        for separator in separators {
            separator.backgroundColor = self.colorManager.separatorColor ?? UIColor.lightGray
        }
    }
    
    fileprivate func setColor(_ color: UIColor, for labels: [UILabel]) {
        for label in labels {
            label.textColor = color
        }
    }
    
    fileprivate func initLayout() {
        self.appName?.text = selectedApp?.appName
        
        Alamofire.request((selectedApp?.appImagePath)!).responseImage { response in
            debugPrint(response)
            debugPrint(response.result)
            
            if response.result.value != nil {
                self.appImage?.image = response.result.value
                self.appImage.layer.cornerRadius = 15.0
                self.appImage.layer.masksToBounds = true
            }
        }
        
        self.appRating.emptyImage = self.colorManager.emptyRatingImage
        self.appRating.fullImage = self.colorManager.filledRatingImage
        self.appRating.contentMode = UIViewContentMode.scaleAspectFit
        self.appRating.rating = Float((self.selectedApp?.averageRating)!) ?? 0
        self.appRating.isHidden = self.appRating.rating == 0
        self.appRating.editable = false
        self.appRating.floatRatings = true
        
        if (self.selectedApp?.price == "0"){
            self.iTunesButton.setTitle("Free", for: .normal)
        }else{
            self.iTunesButton.setTitle(self.selectedApp?.price, for: .normal)
        }
        
        self.iTunesButton.layer.cornerRadius = 6.0
        self.iTunesButton.layer.borderColor = self.iTunesButton.currentTitleColor.cgColor
        self.iTunesButton.layer.borderWidth = 1.0
        self.detailDescription.text = self.selectedApp?.appDescription
        self.developerInfo.text = self.selectedApp?.companyName
        self.categoryInfo.text = self.selectedApp?.primaryGenre
        self.updatedInfo.text = Date.dateWithMediumStyleFrom((self.selectedApp?.currentVersionDate)!)
        
        var iPhone = false
        var iPad = false
        for device in (self.selectedApp?.suportedDevices)! {
            if ((device as String).range(of: "iPhone") != nil){
                iPhone = true
                
            } else if ((device as String).range(of: "iPad") != nil){
                iPad = true
            }
            
            if (iPhone && iPad){
                continue
            }
        }
        var compatible = ""
        
        if (iPhone && !iPad){
            compatible = CompatibleiPhoneAndiPod
        } else if (!iPhone && iPad){
            compatible = CompatibleiPad
        } else if(iPhone && iPad){
            compatible = CompatibleAll
        }
        
        self.compatibilityInfo.text = String(format: MinVersion, (self.selectedApp?.minVersion)!, compatible)
        self.ratingInfo.text = "Rated \((self.selectedApp?.contentAdvisoryRating)!)"
        
        guard let path = Bundle.main.path(forResource: CsvLanguagesPath, ofType: "csv") else {
            return
        }
        
        var keyedRows = [[String]]()
        do {
            let content = try String(contentsOfFile:path, encoding: String.Encoding.utf8)
            let csv = CSwiftV(with: content)
            keyedRows = csv.rows
        } catch _ as NSError {
            print ("Error occurred")
            return
        }
        var codeDictionary = [String : String]()
        for row in keyedRows {
            codeDictionary[row[0]] = row[1]
        }
        var arrayLanguage = [String]()
        for code in (self.selectedApp?.languageCodes)! {
            let lowercased = (code as String).lowercased()
            if (codeDictionary[lowercased] != nil){
                arrayLanguage.append(codeDictionary[lowercased]!)
            }
        }
        
        self.languagesInfo.text = String(format: "%@", (arrayLanguage.joined(separator: ", ")))
        self.collectionView.reloadData()
    }

    // MARK : User actions
    @IBAction func goToItunesClicked(_ sender: Any) {
        guard let urlString = self.selectedApp?.url,
            let url = URL(string: urlString) else {
            return
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}

extension DetailViewController {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return self.selectedApp!.screenshots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath : IndexPath) -> UICollectionViewCell {
        
        let reuseIdentifier = CellId
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! DetailCollectionViewCell
      
        Alamofire.request((self.selectedApp!.screenshots[indexPath.row])).responseImage { response in            
            if response.result.value != nil {
                cell.imageView?.image = response.result.value
                cell.imageView.layer.borderWidth = 1.0
                cell.imageView.layer.borderColor = UIColor(colorLiteralRed: 153.0/255.0, green: 137.0/255.0, blue: 132.0/255.0, alpha: 1.0).cgColor
            }
        }
        return cell
    }
}

extension Date {
    static func dateWithMediumStyleFrom(_ string: String) -> String {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat
        guard let dateFromString = dateFormatter.date(from: string) else {
            return string
        }
        dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: dateFromString)
    }
}
