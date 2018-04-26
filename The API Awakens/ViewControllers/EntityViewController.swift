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
    @IBOutlet weak var entityPicker: UIPickerView!
    @IBOutlet weak var smallestEntityLabel: UILabel!
    @IBOutlet weak var largestEntityLabel: UILabel!
    
    
    // Variable for selected entity
    var selectedEntity: Entity?
    let client = SwapiClient()
    let entityCollection = EntityCollection(type: .people)
    

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        setupNavBar()
        
        // Setup PickerViews Datasource
        entityPicker.dataSource = entityCollection
        entityCollection.pickerView = entityPicker
    
        // Get entities
        client.getEntities(for: entityCollection) { error in
            
            if let error = error{
                print("\(error)")
            }
        }
        
        
    }
    
    // MARK: - Configure view
    func setupNavBar() {
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.isTranslucent = false
        self.title = "Characters"
    }
}


extension EntityViewController: UIPickerViewDelegate {
    

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let rowName = entityCollection.entityList[row].name
        return rowName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedEntity = entityCollection.entityList[row]
        entityName.text = selectedEntity?.name
    }

}















