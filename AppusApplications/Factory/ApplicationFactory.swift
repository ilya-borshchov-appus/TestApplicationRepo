//
//  ApplicationFactory.swift
//  AppusApplications
//
//  Created by Feather52 on 1/17/17.
//  Copyright © 2017 Appus. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class ApplicationFactory: NSObject {
    
    fileprivate let baseURL = "https://itunes.apple.com/"
    
    open static let sharedFactory = ApplicationFactory()
    
    func getListOfApplicationsForDeveloper(with developerId : String, completion: @escaping (_ list  : [AppusApp]?) -> Void) {
        let url = String(format: "%@lookup?id=%@&entity=software", baseURL, developerId)
        self.getListOfApplicationsWith(url) { (dataSource) in
            guard var dataSource = dataSource else {
                completion(nil)
                return
            }
            
            dataSource.removeFirst();
            completion(dataSource)
        }
    }
    
    func getListOfApplications(by ids : [String], completion: @escaping (_ list  : [AppusApp]?) -> Void) {
        let url = String(format: "%@lookup?id=%@&entity=software", baseURL, ids.joined(separator: ","))
        self.getListOfApplicationsWith(url, completion: completion)
    }
    
    func getListOfApplicationsFromFileWith(_ name: String, completion: @escaping (_ list  : [AppusApp]?) -> Void) {
        guard let path = Bundle.main.path(forResource: name, ofType: "txt"),
            let text = try? String.init(contentsOfFile: path, encoding: .utf8) else {
                completion(nil)
                return
        }
        
        self.getListOfApplicationsFrom(text, completion: completion)
    }
    
    // http://uploadedit.com <- here you can upload file with .txt type and test this method
    func getListOfApplicationsFromCloudWithFile(_ url: String, completion: @escaping (_ list  : [AppusApp]?) -> Void) {
        Alamofire.request(url)
            .validate(contentType: ["text/plain"])
            .response { response in
                if let error = response.error {
                    print("Error: \(error.localizedDescription)")
                    completion(nil)
                } else {
                    guard let data = response.data else {
                        completion(nil)
                        return
                    }
                    self.getListOfApplicationsFrom(string: String.init(data: data, encoding: .utf8), completion: completion)
                }
        }
    }
    
    fileprivate func getListOfApplicationsFrom(_ string: String?, completion: @escaping (_ list  : [AppusApp]?) -> Void) {
        guard let string = string else {
            completion(nil)
            return
        }
        
        var ids : [String] = []
        string.components(separatedBy: ",").forEach { (component) in
            let id = component.trimmingCharacters(in: .whitespacesAndNewlines)
            if let _ = Int(id) {
                ids.append(id)
            }
        }
        
        self.getListOfApplications(by: ids, completion:completion)
    }
    
    fileprivate func getListOfApplicationsWith(_ url: String, completion: @escaping (_ list  : [AppusApp]?) -> Void) {
        Alamofire.request(url).responseJSON { response in
            if response.result.isFailure {
                completion(nil)
                print("Error: \(response.result.error?.localizedDescription)")
                return
            }
            
            guard let jsonDict = response.result.value as? NSDictionary else {
                completion(nil)
                return
            }
            
            guard let apps : NSArray = jsonDict["results"] as? NSArray else{
                completion(nil)
                return
            }
            
            let json = JSON(apps)
            
            var dataSource = [AppusApp]()
            json.arrayValue.forEach({ (app) in
                let appusApp = AppusApp()
                appusApp.initWith(json: app)
                dataSource.append(appusApp)
            })
            
            completion(dataSource)
        }
    }
}
