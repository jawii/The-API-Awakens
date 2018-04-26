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
    typealias FetchPageDataHandler = (SwapiError?) -> Void
    
    
    func getEntityCollection(for entities: EntityList, completionHandler completion: @escaping EntityCollectionHandler){
        
        
        let entityCollection = EntityCollection(type: entities)
        
        guard let url = URL(string: entities.rawValue, relativeTo: baseUrl) else {
            completion(nil, .invalidUrl)
            return
        }
        let request = URLRequest(url: url)
        let task = downloader.jsonTask(with: request) { json, error in
            
            // Go back to main thread
            DispatchQueue.main.async {
                guard let json = json else {
                    completion(nil, .jsonParsingFailure)
                    return
                }
                entityCollection.addEntities(array: json)
                completion(entityCollection, nil)
                if entityCollection.nextPageUrl != nil {
                    let newPage = entityCollection.nextPageUrl
                    self.fetchThePageData(for: entityCollection, pageUrl: newPage!) { error in
                        print(error)
                    }
                }
            }
        }
        task.resume()
    }


    func fetchThePageData(for entities: EntityCollection, pageUrl: String, completionHandler completion: @escaping FetchPageDataHandler){
    
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
                if entities.nextPageUrl != nil {
                    let newPage = entities.nextPageUrl
                    self.fetchThePageData(for: entities, pageUrl: newPage!) { error in }
                }
            }
        }
        task.resume()
    }
}



