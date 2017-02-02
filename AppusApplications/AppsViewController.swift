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

let StoryboardName = "AppApp"
let CurrentViewControllerId = "AppsViewController"
let CancelButtonTitle = "Cancel"
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
    
    open var type: DataSourceType? = .developer("1065810792") {
        didSet {
            self.initDataSource();
        }
    }
    
    fileprivate var dataSource : [AppusApp] = []
    fileprivate let settingsManager = SettingsManager.shared
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.initDataSource()
        self.setupTheme()
        
        if let image = self.settingsManager.cancelButtonImage {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: image, style: .done, target: self, action: #selector(cancelTapped))
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: CancelButtonTitle, style: .done, target: self, action: #selector(cancelTapped))
        }
        
        if (self.settingsManager.cancelButtonHidden == true){
            self.navigationItem.rightBarButtonItem = nil
        }
        
        self.tableView.tableFooterView = UIView()
    }
    
    open static func sharedAppsViewController () -> AppsViewController {
        let bundlePath = Bundle(for: AppsViewController.self)
        let pathResource = bundlePath.path(forResource: StoryboardName, ofType: "bundle")!
        let podBundle = Bundle(path: pathResource)
        let appStoryboard = UIStoryboard(name: StoryboardName, bundle: podBundle)
        return appStoryboard.instantiateViewController(withIdentifier: CurrentViewControllerId) as! AppsViewController
    }
    
    open static func sharedNavigationViewController () -> UINavigationController {
        let bundlePath = Bundle(for: AppsViewController.self)
        let pathResource = bundlePath.path(forResource: StoryboardName, ofType: "bundle")!
        let podBundle = Bundle(path: pathResource)
        let appStoryboard = UIStoryboard(name: StoryboardName, bundle: podBundle)
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
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}

extension AppsViewController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let appusApp = self.dataSource[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: AppCellId) as! ApplicationTableViewCell
        cell.appLabel?.text = appusApp.appName
        cell.ratingView.emptyImage = self.settingsManager.emptyRatingImage
        cell.ratingView.fullImage = self.settingsManager.filledRatingImage
        cell.ratingView.contentMode = UIViewContentMode.scaleAspectFit
        cell.ratingView.rating = Float((appusApp.averageRating)) ?? 0
        cell.ratingView.isHidden = cell.ratingView.rating == 0
        cell.ratingView.editable = false
        cell.ratingView.floatRatings = true
        cell.countRating.text = String(format: "(%@)", appusApp.userRatingCount)
        
        Alamofire.request(appusApp.appImagePath).responseImage { response in
            debugPrint(response)
            debugPrint(response.result)
            
            if response.result.value != nil {
                cell.appImage?.image = response.result.value
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
