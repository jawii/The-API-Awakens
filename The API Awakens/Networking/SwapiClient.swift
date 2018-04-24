//
//  SwapiClient.swift
//  The API Awakens
//
//  Created by Jaakko Kenttä on 24/04/2018.
//  Copyright © 2018 Jaakko Kenttä. All rights reserved.
//

import Foundation



class SwapiClient {
    
    lazy var baseUrl: URL = {
        return URL(string: "https://swapi.co/api/")!
    }()
    
    // Init downloader with default configuration
    let downloader = JSONDownloader()
    
    typealias EntityCompletionHandler = (Character?, SwapiError?) -> Void
    
    
    func getEntities(completionHandler completion: @escaping EntityCompletionHandler){
        
        // Check that url is correct
        guard let url = URL(string: "people/1/", relativeTo: baseUrl) else {
            completion(nil, .invalidUrl)
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = downloader.jsonTask(with: request) { json, error in
            
            // Go back to main thread
            DispatchQueue.main.async {
                guard let json = json else {
                    completion(nil, error)
                    return
                }
                
                guard let entity = Character(json: json) else {
                    //print("Parsing in SwapiClient failed")
                    completion(nil, .jsonParsingFailure)
                    return
                }
                
                completion(entity, nil)
            }
        }
        
        task.resume()
        
    }
}









