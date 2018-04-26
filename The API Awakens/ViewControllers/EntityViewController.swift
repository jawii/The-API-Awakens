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
    
        
        // test the entity
        client.getEntities(for: entityCollection) { error in
            // FIXME: - Error handling
            //print("\(String(describing: error))")
            //print(self.entityCollection.entityList.count)
        }
        
        
        
    }
    
    // MARK: - Configure view
    func setupNavBar() {
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.isTranslucent = false
        self.title = "Characters"
    }
    
    // MARK: - PickerView Extension
    
//    func createPickerView() {
//        let pickerView = UIPickerView()
//        pickerView.delegate = self
//        pickerViewTextField.inputView = pickerView
//    }
    
    

}


extension EntityViewController: UIPickerViewDelegate {
    

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let rowName = entityCollection.entityList[row].name
        //print(rowName)
        return rowName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedEntity = entityCollection.entityList[row]
        entityName.text = selectedEntity?.name
    }

}















