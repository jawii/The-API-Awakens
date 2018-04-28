//
//  Vehicle.swift
//  The API Awakens
//
//  Created by Jaakko Kenttä on 27/04/2018.
//  Copyright © 2018 Jaakko Kenttä. All rights reserved.
//

import Foundation


class Vehicle: EntityInfo {
    

    let name: String
    let manufacturer: String
    let cost: String
    let lengthString: String
    let length: Double?
    let vehicleClass: String
    let crewNumber: String
    
    required init?(json: [String: AnyObject], entityType: EntityList) {
        
        var entityClass: String
        if entityType == .vehicles {
            entityClass = Key.vehicleClass
        } else if entityType == .ships {
            entityClass = Key.startShipClass
        } else {
            return nil
        }
        
        guard let crewNumber = json[Key.crewNumber] as? String,
            let name = json[Key.name] as? String,
            let manufacturer = json[Key.manufacturer] as? String,
            let cost = json[Key.cost] as? String,
            let length = json[Key.length] as? String,
            let vehicleClass = json[entityClass] as? String else { return nil }
        
        self.name = name
        self.manufacturer = manufacturer
        self.cost = cost
        
        if let length = Double(length) {
            self.length = length
            self.lengthString = String(length) + "m"
        } else {
            self.lengthString = length
            self.length = nil
        }
        
        self.vehicleClass = vehicleClass.capitalized
        self.crewNumber = crewNumber
    }
}

extension Vehicle {
    
    struct Key {
        static let name = "name"
        static let manufacturer = "manufacturer"
        static let cost = "cost_in_credits"
        static let length = "length"
        static let startShipClass = "starship_class"
        static let vehicleClass = "vehicle_class"
        static let crewNumber = "crew"
    }
}
