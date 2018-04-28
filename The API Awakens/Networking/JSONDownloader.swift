//
//  JSONDownloader.swift
//  The API Awakens
//
//  Created by Jaakko Kenttä on 24/04/2018.
//  Copyright © 2018 Jaakko Kenttä. All rights reserved.
//

import Foundation
import UIKit

class JSONDownloader {
    let session: URLSession
    
    init(configuration: URLSessionConfiguration){
        self.session = URLSession(configuration: configuration)
    }
    
    // Init for default confinguration
    convenience init() {
        self.init(configuration: .default)
    }
    
    typealias JSON = [String: AnyObject]
    typealias JSONTaskCompletionHandler = (JSON?, SwapiError?) -> Void
    
    func jsonTask (with request: URLRequest, completionHandler completion: @escaping JSONTaskCompletionHandler) -> URLSessionDataTask {
        
        let task = session.dataTask(with: request) { data, response, error in
            
            if let error = error as? URLError {
                
                switch error.code {
                case .notConnectedToInternet:
                    if let topController = UIApplication.topViewController() {
                        Alert.showBasic(title: "Error", message: "The internet connection appears to be offline.", vc: topController )
                    }
                case .networkConnectionLost:
                    if let topController = UIApplication.topViewController() {
                        Alert.showBasic(title: "Error", message: "Network connection lost.", vc: topController )
                    }
                default: print(error.localizedDescription)
                }
               
                return
            }
            
            // Convert to HTTP Response
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, .requestFailed)
                return
            }
            
            // Now there is a response
            if httpResponse.statusCode == 200 {
                
                // Try to convert data to JSON - object
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
                        completion(json, nil)
                    } catch {
                        completion(nil, .jsonParsingFailure)
                    }
                } else {
                    completion(nil, .invalidData)
                }
            } else {
                completion(nil, .responseUnsuccesful)
            }
        }
        return task
    }
}
