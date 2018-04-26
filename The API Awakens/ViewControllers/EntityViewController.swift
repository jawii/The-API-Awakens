//
//  EntityViewController.swift
//  The API Awakens
//
//  Created by Jaakko Kenttä on 23/04/2018.
//  Copyright © 2018 Jaakko Kenttä. All rights reserved.
//

import UIKit

class EntityViewController: UIViewController {
    
    // MARK: - Outletts
    
    @IBOutlet weak var entityName: UILabel!
    @IBOutlet weak var picker: UIPickerView!
    
    
    
    
    let client = SwapiClient()

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        setupNavBar()
        configureViewToMatchEntity()
        
        
        // test the entity
        client.getEntityCollection(for: .people) { entityCollection, error in
            if let entityCollection = entityCollection {
                print(entityCollection.entityList.count)
            }
            print(error)
        }
        
    }
    
    // MARK: - Configure view
    func setupNavBar() {
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.isTranslucent = false
        self.title = "Characters"
    }
    
    func configureViewToMatchEntity() {
        
    }

}
