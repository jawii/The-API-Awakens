//
//  EntityViewController.swift
//  The API Awakens
//
//  Created by Jaakko Kenttä on 23/04/2018.
//  Copyright © 2018 Jaakko Kenttä. All rights reserved.
//

import UIKit

class EntityViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.isOpaque = true

        self.navigationController?.navigationItem.title = "Character"
        
        self.view.backgroundColor = UIColor.black
        
        
    }

}
