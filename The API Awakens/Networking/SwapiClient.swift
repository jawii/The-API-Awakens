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
    

    func getEntities(for entityCollection: EntityCollection, completionHandler completion: @escaping (SwapiError?) -> Void){
        
        
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
                        
                        if let error = error{
                            print("\(error)")
                        }
                        
                    }
                }
            }
        }
        task.resume()
    }


    func fetchThePagesData(for entities: EntityCollection, pageUrl: String, completionHandler completion: @escaping (SwapiError?) -> Void){
    
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
                
                let newPage = entities.nextPageUrl
                
                if newPage != nil{
                    self.fetchThePagesData(for: entities, pageUrl: newPage!) { error in
                        if let error = error{
                            print("\(error)")
                        }
                    }
                }
            }
        }
        task.resume()
    }
    
    typealias EntityFetcherCompletionHandler = (EntityInfo?, SwapiError?) -> Void
    
    func fetchEntityData(for type: EntityList, urlString: String, completionHandler completion: @escaping EntityFetcherCompletionHandler) {
        guard let url = URL(string: urlString) else {
            completion(nil, .invalidUrl)
            return
        }
        //print("fetching data for \(urlString)")
        let request = URLRequest(url: url)
        let task = downloader.jsonTask(with: request) { json, error in
            
            // Go back to main thread
            DispatchQueue.main.async {
                guard let json = json else {
                    completion(nil, .jsonParsingFailure)
                    return
                }
                
                if type == .people {
                    
                    // Try to make the character
                    guard let entity = Character(json: json) else { completion(nil, .jsonConversionFailure); return}
                    
                    // Fetch the homworld name
                    self.fetchName(for: entity.homeWorld) {name, error in
                        if let error = error {
                            print("\(error)")
                        } else {
                            entity.homeWorldName = name!
                        }
                    }
                    // Get the vehicles
                    for vehicleUrl in entity.vehiclesUrls {
                            self.fetchName(for: vehicleUrl){name, error in
                            if let error = error {
                                print("\(error)")
                            }
                            guard let name = name else { return }
                            entity.vehicles.append(name)
                        }
                    }
                    // Get the ships
                    for shipUrl in entity.starshipsUrls {
                        self.fetchName(for: shipUrl){name, error in
                            if let error = error {
                                print("\(error)")
                            }
                            guard let name = name else { return }
                            entity.starships.append(name)
                        }
                    }
                
                    completion(entity, nil)
                    
                }
                else {
                    guard let entity = Vehicle(json: json, entityType: type) else {
                        completion(nil, .jsonConversionFailure)
                        return
                    }
                    completion(entity, nil)
                }
                
            }
        }
        task.resume()
    }
    
    typealias NameFetcherCompletionHandler = (String?, SwapiError?) -> Void
    
    func fetchName(for urlString: String, completionHandler completion: @escaping NameFetcherCompletionHandler) {
        guard let url = URL(string: urlString) else {
            completion(nil, .invalidUrl)
            return
        }
        //print("fetching data for \(urlString)")
        let request = URLRequest(url: url)
        let task = downloader.jsonTask(with: request) { json, error in
            
            // Go back to main thread
            DispatchQueue.main.async {
                guard let json = json else {
                    completion(nil, .jsonParsingFailure)
                    return
                }
                
                guard let name = json["name"] as? String else {
                    completion(nil, .jsonConversionFailure)
                    return
                }
                completion(name, nil)
            }
        }
        task.resume()
    }
}



