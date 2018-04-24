//
//  Entity.swift
//  The API Awakens
//
//  Created by Jaakko Kenttä on 24/04/2018.
//  Copyright © 2018 Jaakko Kenttä. All rights reserved.
//

import Foundation



struct Character {
    let name: String
    let birthYear: String
    let homeWorld: String
    let height: Int
    let eyeColor: String
    let hairColor: String
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
    
    init?(json: [String: AnyObject]) {
        
        print("Character initializing")
        guard let height = json[Key.height] as? Int,
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
