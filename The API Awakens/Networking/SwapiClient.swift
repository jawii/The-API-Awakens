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
    
    typealias EntityCollectionHandler = (EntityCollection?, SwapiError?) -> Void
    
    func getEntityCollection(for entities: EntityList, completionHandler completion: @escaping EntityCollectionHandler){
        
        // Check that url is correct
        guard let url = URL(string: entities.rawValue, relativeTo: baseUrl) else {
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
                guard let entityList = EntityCollection(array: json) else {
                    completion(nil, .jsonParsingFailure)
                    return
                }
                
                completion(entityList, nil)
            }
        }
        
        task.resume()
        
    }
    
    typealias PageCompletionHandler = (EntityCollection?, SwapiError?) -> Void
    
    
    /*
    func findEntitiesFrom(pageUrl: String, completionHandler completion: @escaping EntityCollectionHandler) {
        
        guard let url = URL(string: pageUrl) else {
            completion(nil, .invalidUrl)
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = downloader.jsonTask(with: request) { json, error in
            
            DispatchQueue.main.async {
                guard let json = json else {
                    completion(nil, error)
                    return
                }
            }
        }
        task.resume()
        
        
    }
     */
}









