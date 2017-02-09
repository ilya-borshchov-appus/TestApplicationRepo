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

let CellId = "cellId"
let DateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
let IPhoneString = "iPhone"
let IPadString = "iPad"
let IPodTouchString = "iPod touch"

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
    
    // Static labels
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var developerLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var updatedLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var compatibilityLabel: UILabel!
    @IBOutlet weak var languagesLabel: UILabel!
    
    // Collections of views
    @IBOutlet var separators: [UIView]!
    @IBOutlet var sectionTitles: [UILabel]!
    @IBOutlet var textLabels: [UILabel]!
    @IBOutlet var infoTextLabels: [UILabel]!
    
    fileprivate let settingsManager = SettingsManager.shared
    
    fileprivate var _podBundle : Bundle? = nil
    
    internal var podBundle : Bundle{
        get{
            if (!(_podBundle != nil)){
                let bundlePath = Bundle(for: AppsViewController.self)
                let pathResource = bundlePath.path(forResource: BundleName, ofType: BundleType)!
                _ = Bundle(path: pathResource)
                _podBundle = Bundle(path: pathResource)
            }
            return _podBundle!
        }
        set{
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTheme()
        self.initLayout()
        self.setTitles()
    }
    
    // MARK: Init UI
    fileprivate func setupTheme() {        
        self.containerView.backgroundColor = UIColor.clear
        self.backgroundView.image = self.settingsManager.backgroundImage
        self.view.backgroundColor = self.settingsManager.backgroundColor
        
        self.iTunesButton.setTitleColor(self.settingsManager.purchaseButtonColor, for: .normal)
        
        self.setColor(self.settingsManager.sectionTitleColor, for: self.sectionTitles)
        self.setColor(self.settingsManager.textColor, for: self.textLabels)
        self.setColor(self.settingsManager.infoTextColor, for: self.infoTextLabels)
        
        for separator in separators {
            separator.backgroundColor = self.settingsManager.separatorColor ?? UIColor.lightGray
        }
    }
    
    fileprivate func setColor(_ color: UIColor, for labels: [UILabel]) {
        for label in labels {
            label.textColor = color
        }
    }
    
    fileprivate func initLayout() {
        self.appName?.text = selectedApp?.appName
        
        Alamofire.request((selectedApp?.appImagePath)!).responseData { response in
            debugPrint(response)
            debugPrint(response.result)
            
            if response.result.value != nil {
                let image = UIImage(data: response.result.value!)
                self.appImage?.image = image
                self.appImage.layer.cornerRadius = 15.0
                self.appImage.layer.masksToBounds = true
            }
        }
        
        self.appRating.emptyImage = self.settingsManager.emptyRatingImage
        self.appRating.fullImage = self.settingsManager.filledRatingImage
        self.appRating.contentMode = UIViewContentMode.scaleAspectFit
        
        self.appRating.rating = Float((self.selectedApp?.averageRating)!) ?? 0
        self.appRating.isHidden = self.appRating.rating == 0
        
        self.appRating.editable = false
        self.appRating.floatRatings = true
        
        /*if (self.selectedApp?.price == "0"){
            self.iTunesButton.setTitle(NSLocalizedString(Localisation.free, comment: ""), for: .normal)
        }else{*/
            self.iTunesButton.setTitle(self.selectedApp?.price, for: .normal)
        //}
        
        self.iTunesButton.layer.cornerRadius = 6.0
        self.iTunesButton.layer.borderColor = self.iTunesButton.currentTitleColor.cgColor
        self.iTunesButton.layer.borderWidth = 1.0
        
        self.detailDescription.text = self.selectedApp?.appDescription
        self.developerInfo.text = self.selectedApp?.companyName
        self.categoryInfo.text = self.selectedApp?.primaryGenre
        self.updatedInfo.text = Date.dateWithMediumStyleFrom((self.selectedApp?.currentVersionDate)!)
        
        //
        var iPhone = false
        var iPad = false
        for device in (self.selectedApp?.suportedDevices)! {
            if ((device as String).range(of: IPhoneString) != nil){
                iPhone = true
                
            } else if ((device as String).range(of: IPadString) != nil){
                iPad = true
            }
            
            if (iPhone && iPad){
                continue
            }
        }
        var compatible = ""
        
        if (iPhone && !iPad){
            compatible = String(format: "%@ \(IPhoneString) %@ \(IPodTouchString).", NSLocalizedString(Localisation.compatibleWith, tableName: nil, bundle: podBundle, value: "", comment: ""), NSLocalizedString(Localisation.and, tableName: nil, bundle: podBundle, value: "", comment: ""))
        } else if (!iPhone && iPad){
            compatible = String(format: "%@ \(IPadString).", NSLocalizedString(Localisation.compatibleWith, tableName: nil, bundle: podBundle, value: "", comment: ""))
        } else if(iPhone && iPad){
            compatible = String(format: "%@ \(IPhoneString), \(IPadString) %@ \(IPodTouchString).", NSLocalizedString(Localisation.compatibleWith, tableName: nil, bundle: podBundle, value: "", comment: ""), NSLocalizedString(Localisation.and, tableName: nil, bundle: podBundle, value: "", comment: ""))
        }
        
        self.compatibilityInfo.text = String(format: NSLocalizedString(Localisation.formatRequirements, tableName: nil, bundle: podBundle, value: "", comment: ""), (self.selectedApp?.minVersion)!, compatible)
        self.ratingInfo.text = "\(NSLocalizedString(Localisation.rated, tableName: nil, bundle: podBundle, value: "", comment: "")) \((self.selectedApp?.contentAdvisoryRating)!)"
        
        // Repo with all country code in csv format with differenet locales: https://github.com/umpirsky/language-list/
        let bundlePath = Bundle(for: AppsViewController.self)
        guard let path = bundlePath.path(forResource: NSLocalizedString(Localisation.countriesCSV, tableName: nil, bundle: podBundle, value: "", comment: ""), ofType: "csv") else {

            return
        }
        
        var keyedRows = [[String]]()
        do {
            let content = try String(contentsOfFile:path, encoding: String.Encoding.utf8)
            let csv = CSwiftV(with: content)
            keyedRows = csv.rows 
            
            
        } catch _ as NSError {
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

    fileprivate func setTitles() {
        self.title = NSLocalizedString(Localisation.appDetails, tableName: nil, bundle: podBundle, value: "", comment: "")
        self.descriptionLabel.text = NSLocalizedString(Localisation.appDescription, tableName: nil, bundle: podBundle, value: "", comment: "")
        self.infoLabel.text = NSLocalizedString(Localisation.info, tableName: nil, bundle: podBundle, value: "", comment: "")
        self.developerLabel.text = NSLocalizedString(Localisation.developer, tableName: nil, bundle: podBundle, value: "", comment: "")
        self.categoryLabel.text = NSLocalizedString(Localisation.category, tableName: nil, bundle: podBundle, value: "", comment: "")
        self.updatedLabel.text = NSLocalizedString(Localisation.updated, tableName: nil, bundle: podBundle, value: "", comment: "")
        self.ratingLabel.text = NSLocalizedString(Localisation.rating, tableName: nil, bundle: podBundle, value: "", comment: "")
        self.compatibilityLabel.text = NSLocalizedString(Localisation.compatibility, tableName: nil, bundle: podBundle, value: "", comment: "")
        self.languagesLabel.text = NSLocalizedString(Localisation.languages, tableName: nil, bundle: podBundle, value: "", comment: "")
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

extension DetailViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return self.selectedApp!.screenshots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath : IndexPath) -> UICollectionViewCell {
        
        let reuseIdentifier = CellId
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! DetailCollectionViewCell
      
        
        Alamofire.request((self.selectedApp!.screenshots[indexPath.row])).responseData { response in            
            if response.result.value != nil {
                let image = UIImage(data: response.result.value!)
                cell.imageView?.image = image
                cell.imageView.layer.borderWidth = 1.0
                cell.imageView.layer.borderColor = UIColor(colorLiteralRed: 153.0/255.0, green: 137.0/255.0, blue: 132.0/255.0, alpha: 1.0).cgColor
            }
        }
        
        return cell
    }
}

extension DetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.contentSize.height
        if (self.selectedApp?.isIPadScreenshots)! {
            return CGSize.init(width: 3.0 / 4.0 * height, height: height)
        } else {
            return CGSize.init(width: 9.0 / 16.0 * height, height: height)
        }
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
