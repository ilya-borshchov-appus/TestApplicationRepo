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
    fileprivate let formatLookupURL = "%@lookup?id=%@&entity=software"
    
    open static let sharedFactory = ApplicationFactory()
    
    func getListOfApplicationsForDeveloper(with developerId : String, completion: @escaping (_ list  : [AppusApp]?) -> Void) {
        let url = String(format: formatLookupURL, baseURL, developerId)
        self.getListOfApplicationsWith(url) { (dataSource) in
            guard var dataSource = dataSource else {
                completion(nil)
                return
            }
            
            if dataSource.count > 0 {
                dataSource.removeFirst();
            }
            completion(dataSource)
        }
    }
    
    func getListOfApplications(by ids : [String], completion: @escaping (_ list  : [AppusApp]?) -> Void) {
        let url = String(format: formatLookupURL, baseURL, ids.joined(separator: ","))
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
                self.getListOfApplicationsFrom(String.init(data: data, encoding: .utf8), completion: completion)
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
        var url = url
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            url.append("&country=\(countryCode)")
        }
        
        Alamofire.request(url).responseJSON { response in
            if response.result.isFailure {
                completion(nil)
                
                print("Error: \(response.result.error!.localizedDescription)")
                return
            }
            
            guard let jsonDict = response.result.value as? NSDictionary else {
                completion(nil)
                return
            }
            
            guard let apps : NSArray = jsonDict["results"] as? NSArray else {
                completion(nil)
                if let _ = jsonDict["errorMessage"] as? String {
                    let url = (response.request?.url?.absoluteURL)!
                    print("Error: invalid application(s) or developer id(s).\nURL: \(url)")
                }
                return
            }
            
            let json = JSON(apps)
            
            self.saveJSON(json)
            var dataSource = [AppusApp]()
            json.arrayValue.forEach({ (app) in
                let appusApp = AppusApp()
                appusApp.initWith(app)
                dataSource.append(appusApp)
            })
            
            completion(dataSource)
        }
    }
}

// MARK: - Local JSON Cache
extension ApplicationFactory {
    
    private var localURL: URL {
        return FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)
            .first!
            .appendingPathComponent("com.appus.aCamApp")
            .appendingPathComponent(ApplicationFactoryConstants.cacheFileName)
    }
    
    @discardableResult
    fileprivate func saveJSON(_ json: JSON) -> Bool {
        
        var rawJsonArray = json.arrayObject ?? []
        rawJsonArray.removeFirst()
        
        let data = try! JSONSerialization.data(withJSONObject: rawJsonArray)
        
        let fileURL = self.localURL
        let directoryURL = fileURL.deletingLastPathComponent()
        do {
            try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Error while creating local directory for iTunes application cache")
            return false
        }
        
        guard (try? data.write(to: fileURL, options: .atomic)) != nil else {
            return false
        }
        
        let string = try! String(contentsOfFile: fileURL.path, encoding: .utf8)
        let fixedString = string.replacingOccurrences(of: "\\/", with: "/", options: .caseInsensitive, range: string.startIndex..<string.endIndex)
        
        let resultData = fixedString.data(using: .utf8)!
        guard (try? resultData.write(to: fileURL, options: .atomic)) != nil else {
            return false
        }
        return true
    }
    
    /*
     * Return empty array if local data not exists.
     */
    func localListOfApplications() -> [AppusApp] {
        
        let fileURL = self.localURL
        
        guard let data = try? Data(contentsOf: fileURL) else {
            return []
        }
        let jsonArray = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [[String: Any]]
        
        var dataSource = [AppusApp]()
        jsonArray.forEach { app in
            let appusApp = AppusApp()
            appusApp.initWith(dictionary: app)
            dataSource.append(appusApp)
        }
        return dataSource
    }
    
}

private struct ApplicationFactoryConstants {
    static let cacheFileName = "itunes_appus_apps.json"
}
