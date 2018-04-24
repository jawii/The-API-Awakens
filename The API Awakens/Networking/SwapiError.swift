//
//  SwapiError.swift
//  The API Awakens
//
//  Created by Jaakko Kenttä on 24/04/2018.
//  Copyright © 2018 Jaakko Kenttä. All rights reserved.
//

import Foundation

enum SwapiError: Error {
    case requestFailed
    case responseUnsuccesful
    case invalidData
    case jsonConversionFailure
    case invalidUrl
    case jsonParsingFailure
}
