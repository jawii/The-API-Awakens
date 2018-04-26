//
//  EntityList.swift
//  The API Awakens
//
//  Created by Jaakko Kenttä on 25/04/2018.
//  Copyright © 2018 Jaakko Kenttä. All rights reserved.
//

import Foundation
import UIKit


enum EntityList: String {
    case people = "people/"
    case ships = "starships/"
    case vehicles = "vehicles/"
}


struct Entity {
    let name: String
    let url: String
    let size: Int?
}


class EntityCollection: NSObject{
    
    var entityList: [Entity] = []  {
        didSet {
                //print(entityList.count)
        }
    }

    var type: EntityList
    var nextPageUrl: String? = nil
    var pickerView: UIPickerView?
    
    var smallestEntity: Entity? {
        didSet {
            print("Smallest: \(smallestEntity?.name)")
        }
    }
    var highestEntity: Entity?
    
    init(type: EntityList) {
        self.type = type
    }
    
    func addEntities(array: Dictionary<String, AnyObject>) {
        
        for item in array {
            
            if item.key == "results" {
                if let entities = item.value as? [[String: AnyObject]] {
                    for entity in entities {
                        guard let entityName = entity["name"] as? String,
                            let entityUrl = entity["url"]  as? String else { return }
                        
                        var sizeKey: String

                        switch type {
                        case .people:
                            sizeKey = "height"
                        case .ships, .vehicles:
                            sizeKey = "length"
                        }
                        
                        guard let entitySize = entity[sizeKey] as? String else { return }
                        
                        let sizeToInt = Int(entitySize)
                        let newEntity = Entity(name: entityName, url: entityUrl, size: sizeToInt)
                        
                        //check the size if entity has valid height
                        if sizeToInt != nil {
                            smallestAndHighestCheck(for: newEntity)
                        }
                        
                        self.entityList.append(newEntity)
                        arrangeEntities()
                        self.pickerView?.reloadAllComponents()
                    }
                }
            }
            else if item.key == "next" {
                let nextPage = item.value as? String
                nextPageUrl = nextPage
            }
        }
    }
    
    func arrangeEntities() {
        let arrangedEntities = entityList.sorted { $0.name < $1.name}
        entityList = arrangedEntities
    }
    
    func smallestAndHighestCheck(for entity: Entity) {
        
        // BANG BANG
        
        let newSize = entity.size!
        
        if smallestEntity == nil {
            smallestEntity = entity
        } else {
            if smallestEntity!.size! > newSize {
                smallestEntity = entity
            }
        }
        
        if highestEntity == nil {
            highestEntity = entity
        } else {
            if highestEntity!.size! < newSize {
                highestEntity = entity
            }
        }
    }
    
}


// MARK: - PickerViewDataSource Extension

extension EntityCollection: UIPickerViewDataSource {

     func numberOfComponents(in pickerView: UIPickerView) -> Int {
     return 1
     }
     
     func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
     return entityList.count
    }
    
    
}




















