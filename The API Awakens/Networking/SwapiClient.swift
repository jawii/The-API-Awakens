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
    
    typealias EntityCollectionHandler = (SwapiError?) -> Void
    typealias FetchPageDataHandler = (SwapiError?) -> Void
    
    
    func getEntities(for entityCollection: EntityCollection, completionHandler completion: @escaping EntityCollectionHandler){
        
        
        guard let url = URL(string: entityCollection.type.rawValue, relativeTo: baseUrl) else {
            completion(.invalidUrl)
            return
        }
        let request = URLRequest(url: url)
        let task = downloader.jsonTask(with: request) { json, error in
            
            // Go back to main thread
            DispatchQueue.main.async {
                guard let json = json else {
                    completion(.jsonParsingFailure)
                    return
                }
                entityCollection.addEntities(array: json)
                completion(nil)
                if entityCollection.nextPageUrl != nil {
                    let newPage = entityCollection.nextPageUrl
                    self.fetchThePagesData(for: entityCollection, pageUrl: newPage!) { error in
                        // FIXME: - Error handling
                        //print(error as Any)
                    }
                }
            }
        }
        task.resume()
    }


    func fetchThePagesData(for entities: EntityCollection, pageUrl: String, completionHandler completion: @escaping FetchPageDataHandler){
        
        
        var lastPage = false
    
        guard let url = URL(string: pageUrl) else {
            completion(.invalidUrl)
            return
        }
        let request = URLRequest(url: url)
        let task = downloader.jsonTask(with: request) { json, error in
            
            // Go back to main thread
            DispatchQueue.main.async {
                guard let json = json else {
                    completion(.jsonParsingFailure)
                    return
                }
                entities.addEntities(array: json)
                completion(nil)
                
                if entities.nextPageUrl != nil && !lastPage{
                    let newPage = entities.nextPageUrl
                    self.fetchThePagesData(for: entities, pageUrl: newPage!) { error in }
                    
                    if entities.nextPageUrl == nil {
                        lastPage = true
                    }
                }
                
                
            }
        }
        task.resume()
    }
}



