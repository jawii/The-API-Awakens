//
//  EntityList.swift
//  The API Awakens
//
//  Created by Jaakko Kenttä on 25/04/2018.
//  Copyright © 2018 Jaakko Kenttä. All rights reserved.
//

import Foundation


enum EntityList: String {
    case people = "people/"
    case ships = "starships/"
    case vehicles = "vehicles/"
}


struct Entity {
    let name: String
    let url: String
}


struct EntityCollection {
    // EntityType
    var entityList: [Entity]
    var pagesEnded: Bool = false
    
    init?(array: Dictionary<String, AnyObject>) {
        
        var entityList: [Entity] = []
        
        for item in array {
            if item.key == "next" {
                guard let value = item.value as? String else { return nil }
                    if value == "null" {
                        self.pagesEnded = true
                    }
            }
            else if item.key == "results" {
                if let entities = item.value as? [[String: AnyObject]] {
                    for entity in entities {
                        guard let entityName = entity["name"] as? String , let entityUrl = entity["url"]  as? String else { return nil }
                        let newEntity = Entity(name: entityName, url: entityUrl)
                        entityList.append(newEntity)
                    }
                    
                }
            }
        }
        self.entityList = entityList
    }
}




















