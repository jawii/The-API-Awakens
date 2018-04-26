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
}


class EntityCollection: NSObject{
    
    var entityList: [Entity] = []  {
        didSet {
            pickerView?.reloadAllComponents()
            print(entityList.count)
            
        }
    }
    var type: EntityList
    var nextPageUrl: String? = nil
    var pickerView: UIPickerView?
    
    init(type: EntityList) {
        self.type = type
    }
    
    func addEntities(array: Dictionary<String, AnyObject>) {
        
        for item in array {
            if item.key == "next" {
                guard let nextPage = item.value as? String else {
                    nextPageUrl = nil
                    return
                }
                nextPageUrl = nextPage
            }
            else if item.key == "results" {
                if let entities = item.value as? [[String: AnyObject]] {
                    for entity in entities {
                        guard let entityName = entity["name"] as? String , let entityUrl = entity["url"]  as? String else { return }
                        let newEntity = Entity(name: entityName, url: entityUrl)
                        self.entityList.append(newEntity)
                    }
                    
                }
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




















