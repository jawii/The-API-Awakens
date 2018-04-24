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
    let birthDay: String
    let home: String
    let height: Int
    let eyeColor: String
    let hairColor: String
}


extension Character {
    
    struct Key {
        static let name = "name"
        static let birthday = "birth_year"
        static let home = "homeworld"
        static let eyeColor = "eye_color"
        static let hairColor = "hair_color"
        static let height = "height"
    }
    
    init?(json: [String: Any]) {
        
        guard let height = json[Key.name] as? Int,
        let name = json[Key.name] as? String,
        let birthday = json[Key.birthday] as? String,
        let home = json[Key.home] as? String,
        let eyeColor = json[Key.eyeColor] as? String,
        let hairColor = json[Key.hairColor] as? String else  { return nil }
        
        self.height = height
        self.name = name
        self.birthDay = birthday
        self.home = home
        self.eyeColor = eyeColor
        self.hairColor = hairColor
        
        
    }
}
