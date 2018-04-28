//
//  Entity.swift
//  The API Awakens
//
//  Created by Jaakko Kenttä on 24/04/2018.
//  Copyright © 2018 Jaakko Kenttä. All rights reserved.
//

import Foundation


protocol CharacterInfoDelegate: class {
    func didSetHomeWorldName(character: Character)
    func updateVehicleCount(for count: Int)
}

class EntityInfo {
    var size: Double = 0
}

class Character: EntityInfo {
    
    weak var delegate: CharacterInfoDelegate?
    
    let name: String
    let birthYear: String
    let homeWorld: String
    let heightString: String
    let height: Double?
    let eyeColor: String
    let hairColor: String
    var homeWorldName: String? = nil {
        didSet {
            delegate?.didSetHomeWorldName(character: self)
        }
    }
    let starshipsUrls: [String]
    let vehiclesUrls: [String]
    var vehicles: [String] = [] {
        didSet {
            allVehicleCount += 1
            delegate?.updateVehicleCount(for: allVehicleCount)
        }
    }
    var starships: [String] = [] {
        didSet {
            allVehicleCount += 1
            delegate?.updateVehicleCount(for: allVehicleCount)
        }
    }
    
    var allVehicleCount = 0
    
    required init?(json: [String: AnyObject]) {
        
        guard let height = json[Key.height] as? String,
            let name = json[Key.name] as? String,
            let birthYear = json[Key.birthYear] as? String,
            let homeWorld = json[Key.homeWorld] as? String,
            let eyeColor = json[Key.eyeColor] as? String,
            let vehicles = json[Key.vehicles] as? [String],
            let starShips = json[Key.starships] as? [String],
            let hairColor = json[Key.hairColor] as? String else  { return nil }
        
        
        
        if let height = Double(height) {
            self.height = height
            self.heightString = String(height) + "cm"
        } else {
            self.heightString = height
            self.height = nil
        }
        
        self.name = name
        self.birthYear = birthYear
        self.homeWorld = homeWorld
        self.eyeColor = eyeColor
        self.hairColor = hairColor
        self.vehiclesUrls = vehicles
        self.starshipsUrls = starShips
    }
}


extension Character {
    
    struct Key {
        static let name = "name"
        static let birthYear = "birth_year"
        static let homeWorld = "homeworld"
        static let eyeColor = "eye_color"
        static let hairColor = "hair_color"
        static let height = "height"
        static let vehicles = "vehicles"
        static let starships = "starships"
    }
}
