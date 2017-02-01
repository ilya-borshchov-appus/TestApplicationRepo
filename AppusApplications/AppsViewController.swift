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
    fileprivate let colorManager = ColorManager.shared
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
//        self.testColorScheme()
        
        self.initDataSource()
        self.setupTheme()
        
        if let image = self.colorManager.cancelButtonImage {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: image, style: .done, target: self, action: #selector(cancelTapped))
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Cancel", style: .done, target: self, action: #selector(cancelTapped))
        }
        
        self.tableView.tableFooterView = UIView()
    }
    
//    fileprivate func testColorScheme() {
//        self.colorManager.isTransparentNavigationBar = true
//        self.colorManager.navigationBarColor = UIColor.red
//        self.colorManager.navigationTitleColor = UIColor.blue
//        self.colorManager.navigationItemColor = UIColor.green
//        
//        self.colorManager.sectionTitleColor = UIColor.yellow
//        self.colorManager.backgroundColor = UIColor.black
//        self.colorManager.backgroundImage = UIImage(named: "background")
//        
//        self.colorManager.textColor = UIColor.orange
//        self.colorManager.infoTextColor = UIColor.orange
//        self.colorManager.separatorColor = UIColor.orange
//        self.colorManager.purchaseButtonColor = UIColor.orange
//    }
    
    open static func sharedAppsViewController () -> AppsViewController {
        let appStoryboard = UIStoryboard(name: "AppApp", bundle: Bundle.main)
        return appStoryboard.instantiateViewController(withIdentifier: "AppsViewController") as! AppsViewController
    }
    
    fileprivate func setupTheme() {
        if let navigationController = self.navigationController {
            let navBar = navigationController.navigationBar
            
            if self.colorManager.isTransparentNavigationBar {
                navBar.setBackgroundImage(UIImage(), for: .default)
                navBar.shadowImage = UIImage()
                navBar.isTranslucent = true
            } else {
                navBar.setBackgroundImage(self.colorManager.navigationBarImage, for: .default)
                navBar.barTintColor = self.colorManager.navigationBarColor
            }
      
            navBar.titleTextAttributes = [NSForegroundColorAttributeName: self.colorManager.navigationTitleColor]
            
            if let itemsColor = self.colorManager.navigationItemColor {
                navBar.tintColor = itemsColor
            }
        }
        
        self.tableView.backgroundColor = UIColor.clear
        self.backgroundView.image = self.colorManager.backgroundImage
        self.view.backgroundColor = self.colorManager.backgroundColor
        
        self.tableView.separatorColor = self.colorManager.separatorColor
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
            ApplicationFactory.sharedFactory.getListOfApplicationsFromFileWith(name: name, completion: self.completion)
        case .url(let url):
            ApplicationFactory.sharedFactory.getListOfApplicationsFromCloudWithFile(url: url, completion: self.completion)
        case .developer(let id):
            ApplicationFactory.sharedFactory.getListOfApplicationsForDeveloper(with: id, completion: self.completion)
        }
    }
    
    fileprivate func completion(_ dataSource: [AppusApp]?) {
        guard let dataSource = dataSource else {
            return
        }
        
        self.dataSource = dataSource
        self.tableView.reloadData()
        
        print("Data source \(dataSource)")
    }
    
    // MARK: Segue    
    override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detailSegue"){
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
        let cellId = "applicationCell"
        let appusApp = self.dataSource[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! ApplicationTableViewCell
        
        cell.appLabel?.text = appusApp.appName
        
        cell.ratingView.emptyImage = self.colorManager.emptyRatingImage
        cell.ratingView.fullImage = self.colorManager.filledRatingImage
        
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
        self.performSegue(withIdentifier: "detailSegue", sender: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62.0
    }
}
