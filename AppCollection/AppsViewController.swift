//
//  ViewController.swift
//  AppusApplications
//
//  Created by Feather52 on 1/16/17.
//  Copyright © 2017 Appus. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire
import PKHUD

let BundleName = "AppCollection"
let BundleType = "bundle"

let StoryboardName = "AppApp"
let StoryboardIPadName = "AppAppIPad"
let CurrentViewControllerId = "AppsViewController"
let NavigationViewControllerId = "NavigationViewControllerId"
let DetailSegue = "detailSegue"
let AppCellId = "applicationCell"

public enum DataSourceType {
    case array([String])
    case file(String)
    case url(String)
    case developer(String)
}

open class AppsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundView: UIImageView!
    
    open var type: DataSourceType? = //.file("apps_ids") {
        .developer("1065810792") {
        didSet {
            self.initDataSource();
        }
    }
    
    fileprivate var dataSource : [AppusApp] = []
    fileprivate let settingsManager = SettingsManager.shared

    override open func viewDidLoad() {
        super.viewDidLoad()
        
//      self.testColorScheme()
        
        self.title = NSLocalizedString(Localisation.applications, comment: "")
            
        self.initDataSource()
        self.setupTheme()
        
        if let image = self.settingsManager.cancelButtonImage {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: image, style: .done, target: self, action: #selector(cancelTapped))
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: NSLocalizedString(Localisation.cancel, comment: ""), style: .done, target: self, action: #selector(cancelTapped))
        }
        
        if (self.settingsManager.cancelButtonHidden == true){
            self.navigationItem.rightBarButtonItem = nil
        }else{
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: NSLocalizedString(Localisation.cancel, comment: ""), style: .done, target: self, action: #selector(cancelTapped))
        }
        
        self.tableView.tableFooterView = UIView()
    }
    
//    fileprivate func testColorScheme() {
//        self.settingsManager.isTransparentNavigationBar = true
//        self.settingsManager.navigationBarColor = UIColor.red
//        self.settingsManager.navigationTitleColor = UIColor.blue
//        self.settingsManager.navigationItemColor = UIColor.green
//        
//        self.settingsManager.sectionTitleColor = UIColor.yellow
//        self.settingsManager.backgroundColor = UIColor.black
//        self.settingsManager.backgroundImage = UIImage(named: "background")
//        
//        self.settingsManager.textColor = UIColor.orange
//        self.settingsManager.infoTextColor = UIColor.orange
//        self.settingsManager.separatorColor = UIColor.orange
//        self.settingsManager.purchaseButtonColor = UIColor.orange
//    }
    
    open static func sharedAppsViewController () -> AppsViewController {
        var storyboardName = StoryboardName
        if UIDevice.current.userInterfaceIdiom == .pad {
            storyboardName = StoryboardIPadName
        }
        
        let bundlePath = Bundle(for: AppsViewController.self)
        let pathResource = bundlePath.path(forResource: BundleName, ofType: BundleType)!
        let podBundle = Bundle(path: pathResource)
        let appStoryboard = UIStoryboard(name: storyboardName, bundle: podBundle)
        return appStoryboard.instantiateViewController(withIdentifier: CurrentViewControllerId) as! AppsViewController
    }
    
    open static func sharedNavigationViewController () -> UINavigationController {
        var storyboardName = StoryboardName
        if UIDevice.current.userInterfaceIdiom == .pad {
            storyboardName = StoryboardIPadName
        }
        
        let bundlePath = Bundle(for: AppsViewController.self)
        let pathResource = bundlePath.path(forResource: BundleName, ofType: BundleType)!
        let podBundle = Bundle(path: pathResource)
        let appStoryboard = UIStoryboard(name: storyboardName, bundle: podBundle)
        return appStoryboard.instantiateViewController(withIdentifier: NavigationViewControllerId) as! UINavigationController
    }
    
    fileprivate func setupTheme() {
        if let navigationController = self.navigationController {
            let navBar = navigationController.navigationBar
            
            if self.settingsManager.isTransparentNavigationBar {
                navBar.setBackgroundImage(UIImage(), for: .default)
                navBar.shadowImage = UIImage()
                navBar.isTranslucent = true
            } else {
                navBar.setBackgroundImage(self.settingsManager.navigationBarImage, for: .default)
                navBar.barTintColor = self.settingsManager.navigationBarColor
            }
      
            navBar.titleTextAttributes = [NSForegroundColorAttributeName: self.settingsManager.navigationTitleColor]
            
            if let itemsColor = self.settingsManager.navigationItemColor {
                navBar.tintColor = itemsColor
            }
        }
        
        self.tableView.backgroundColor = UIColor.clear
        self.backgroundView.image = self.settingsManager.backgroundImage
        self.view.backgroundColor = self.settingsManager.backgroundColor
        self.tableView.separatorColor = self.settingsManager.separatorColor
    }
    
    // MARK: Data Source initialisation
    fileprivate func initDataSource() {
        guard let type = self.type else {
            return
        }
        
        PKHUD.sharedHUD.contentView = PKHUDProgressView(title: NSLocalizedString(Localisation.loading, comment: ""))
        PKHUD.sharedHUD.show()
        
        switch type {
        case .array(let ids):
            ApplicationFactory.sharedFactory.getListOfApplications(by: ids, completion: self.completion)
        case .file(let name):
            ApplicationFactory.sharedFactory.getListOfApplicationsFromFileWith(name, completion: self.completion)
        case .url(let url):
            ApplicationFactory.sharedFactory.getListOfApplicationsFromCloudWithFile(url, completion: self.completion)
        case .developer(let id):
            ApplicationFactory.sharedFactory.getListOfApplicationsForDeveloper(with: id, completion: self.completion)
        }
    }
    
    fileprivate func completion(_ dataSource: [AppusApp]?) {
        guard let dataSource = dataSource else {
            return
        }
        
        self.dataSource = dataSource
        if (self.tableView != nil){
            self.tableView.reloadData()
        }
        
        PKHUD.sharedHUD.hide()
        
        print("Data source \(dataSource)")
    }
    
    // MARK: Segue    
    override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == DetailSegue){
            let destination = segue.destination as! DetailViewController
            destination.selectedApp = self.dataSource[((sender as! IndexPath).row)]
        }
    }
    
    // MARK: Actions
    func cancelTapped(_ sender: UIBarButtonItem) {
        
    }
}

extension AppsViewController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellId = AppCellId
        let appusApp = self.dataSource[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! ApplicationTableViewCell
        cell.appLabel?.text = appusApp.appName
        cell.ratingView.emptyImage = self.settingsManager.emptyRatingImage
        cell.ratingView.fullImage = self.settingsManager.filledRatingImage
        cell.ratingView.contentMode = UIViewContentMode.scaleAspectFit
        cell.ratingView.rating = Float((appusApp.averageRating)) ?? 0
        cell.ratingView.isHidden = cell.ratingView.rating == 0
        cell.ratingView.editable = false
        cell.ratingView.floatRatings = true
        cell.countRating.text = String(format: "(%@)", appusApp.userRatingCount)
        Alamofire.request(appusApp.appImagePathForCell).responseData { response in
            debugPrint(response)
            debugPrint(response.result)
            
            if response.result.value != nil {
                let image = UIImage(data: response.result.value!)
                cell.appImage?.image = image
                cell.appImage?.layer.cornerRadius = 7.0
                cell.appImage?.layer.masksToBounds = true
            }
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        self.performSegue(withIdentifier: DetailSegue, sender: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62.0
    }
}
