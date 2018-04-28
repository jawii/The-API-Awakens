//
//  Alert.swift
//  The API Awakens
//
//  Created by Jaakko Kenttä on 28/04/2018.
//  Copyright © 2018 Jaakko Kenttä. All rights reserved.
//

import Foundation
import UIKit

class Alert {
    
    class func showBasic(title: String, message: String, vc: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okey!", style: .default, handler: nil))
        vc.present(alert, animated: true)
    }
}
