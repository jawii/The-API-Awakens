//
//  Entity.swift
//  The API Awakens
//
//  Created by Jaakko Kenttä on 24/04/2018.
//  Copyright © 2018 Jaakko Kenttä. All rights reserved.
//

import Foundation


protocol HomeWorldNameDelegate: class {
    func didSetHomeWorldName(character: Character)
}

class EntityInfo {
    
}

class Character: EntityInfo {
    
    weak var delegate: HomeWorldNameDelegate?
    
    let name: String
    let birthYear: String
    let homeWorld: String
    let height: String
    let eyeColor: String
    let hairColor: String
    var homeWorldName: String? = nil {
        didSet {
            delegate?.didSetHomeWorldName(character: self)
        }
    }
    
    required init?(json: [String: AnyObject]) {
        
        guard let height = json[Key.height] as? String,
            let name = json[Key.name] as? String,
            let birthYear = json[Key.birthYear] as? String,
            let homeWorld = json[Key.homeWorld] as? String,
            let eyeColor = json[Key.eyeColor] as? String,
            let hairColor = json[Key.hairColor] as? String else  { return nil }
        
        self.height = height
        self.name = name
        self.birthYear = birthYear
        self.homeWorld = homeWorld
        self.eyeColor = eyeColor
        self.hairColor = hairColor
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
    }
}
