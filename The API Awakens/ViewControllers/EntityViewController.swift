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
    
    
    @IBOutlet weak var infoLabel1Name: UILabel!
    @IBOutlet weak var infoLabel1Value: UILabel!
    
    @IBOutlet weak var infoLabel2Name: UILabel!
    @IBOutlet weak var infoLabel2Value: UILabel!
    
    @IBOutlet weak var infoLabel3Name: UILabel!
    @IBOutlet weak var infoLabel3Value: UILabel!
    
    @IBOutlet weak var infoLabel4Name: UILabel!
    @IBOutlet weak var infoLabel4Value: UILabel!
    
    @IBOutlet weak var infoLabel5Name: UILabel!
    @IBOutlet weak var infoLabel5Value: UILabel!
    
    @IBOutlet weak var valueButtonUSD: UIButton!
    @IBOutlet weak var valueButtonCredits: UIButton!
    
    @IBOutlet weak var sizeUnitEnglish: UIButton!
    @IBOutlet weak var sizeUnitMetric: UIButton!
    
    
    @IBOutlet weak var smallestEntityLabel: UILabel!
    @IBOutlet weak var largestEntityLabel: UILabel!
    
    
    // Variable for selected entity
    var selectedEntity: Entity?
    let client = SwapiClient()
    var entityCollection: EntityCollection? = nil
    

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        
        // Get entities
        guard let entityCollection = entityCollection else { fatalError()}
        
        setupNavBar()
        nameTheLabels()
        
        // Setup PickerViews Datasource
        entityPicker.dataSource = entityCollection
        entityCollection.pickerView = entityPicker
        entityCollection.delegate = self
    
        
        // Get the entity list
        client.getEntities(for: entityCollection) { error in
            if let error = error {
            print("\(error)")
            }
        }
        
    }
    
    // MARK: - Configure view
    func setupNavBar() {
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    func nameTheLabels() {
        switch entityCollection!.type {
        case .people:
            valueButtonUSD.isHidden = true
            valueButtonCredits.isHidden = true
            self.title = "Characters"
            
        case .vehicles:
            infoLabel1Name.text = "Make"
            infoLabel2Name.text = "Cost"
            infoLabel3Name.text = "Length"
            infoLabel4Name.text = "Class"
            infoLabel5Name.text = "Crew"
            self.title = "Vehicles"
            
        case .ships:
            infoLabel1Name.text = "Make"
            infoLabel2Name.text = "Cost"
            infoLabel3Name.text = "Length"
            infoLabel4Name.text = "Class"
            infoLabel5Name.text = "Crew"
            self.title = "Ships"
        }
        
        //remove default names
        entityName.text = ""
        infoLabel1Value.text = ""
        infoLabel2Value.text = ""
        infoLabel3Value.text = ""
        infoLabel4Value.text = ""
        infoLabel5Value.text = ""
    }
    
    func setupLabelValues(for entity: EntityInfo) {
        
        if let entity = entity as? Character {
            infoLabel1Value.text = entity.birthYear
            infoLabel2Value.text = entity.homeWorldName
            infoLabel3Value.text = entity.heightString
            infoLabel4Value.text = entity.eyeColor
            infoLabel5Value.text = entity.hairColor
        }
        
        if let entity = entity as? Vehicle {
            infoLabel1Value.text = entity.manufacturer
            infoLabel2Value.text = entity.cost
            infoLabel3Value.text = entity.lengthString
            infoLabel4Value.text = entity.vehicleClass
            infoLabel5Value.text = entity.crewNumber
        }
    }
}

// MARK: - Delegates

extension EntityViewController: UIPickerViewDelegate {
    

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let rowName = entityCollection!.entityList[row].name
        return rowName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedEntity = entityCollection!.entityList[row]
        entityName.text = selectedEntity!.name
        
        client.fetchEntityData(for: entityCollection!.type, urlString: selectedEntity!.url) {entity, error in
            
            if let error = error{
                print("\(error)")
            }
            guard let entity = entity else { return }
            self.setupLabelValues(for: entity)
            
            if let entity = entity as? Character {
                entity.delegate = self
            }
        }
    }
}

extension EntityViewController: EntityCollectionDelegate {
    func didUpdatedSmallestAndLargestLabel() {
        smallestEntityLabel.text = entityCollection!.smallestEntity?.name
        largestEntityLabel.text = entityCollection!.highestEntity?.name
    }
}


extension EntityViewController: HomeWorldNameDelegate {
    func didSetHomeWorldName(character: Character) {
        infoLabel2Value.text = character.homeWorldName
    }
    
}















