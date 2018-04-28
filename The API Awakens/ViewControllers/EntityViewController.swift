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
    
    @IBOutlet weak var assosVehicleBtn: UIButton!
    
    @IBOutlet weak var smallestEntityLabel: UILabel!
    @IBOutlet weak var largestEntityLabel: UILabel!
    
    
    // Variable for selected entity
    var selectedEntity: Entity?
    var selectedEntityData: EntityInfo?
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
            assosVehicleBtn.isHidden = true
            self.title = "Vehicles"
            
        case .ships:
            infoLabel1Name.text = "Make"
            infoLabel2Name.text = "Cost"
            infoLabel3Name.text = "Length"
            infoLabel4Name.text = "Class"
            infoLabel5Name.text = "Crew"
            assosVehicleBtn.isHidden = true
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
            
            self.selectedEntityData = entity
            
            self.setupLabelValues(for: entity)
            
            if let entity = entity as? Character {
                entity.delegate = self
                self.assosVehicleBtn.setTitle("Associated vehicles and starships (0)", for: .normal)
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


extension EntityViewController: CharacterInfoDelegate {
    func updateVehicleCount(for count: Int) {
        assosVehicleBtn.setTitle("Associated vehicles and starships (\(count))", for: .normal)
    }
    
    func didSetHomeWorldName(character: Character) {
        infoLabel2Value.text = character.homeWorldName
    }
    
}


// MARK: - Vehicles and Starships list
extension EntityViewController {

    @IBAction func showAssVechicles() {
        
        guard let character = selectedEntityData as? Character else { return }
        
        var message = ""
        
        if character.vehicles.count > 0 {
            message += "Vehicles\n"
            for vehicle in character.vehicles {
                message.append("\(vehicle)\n")
            }
            message += "\n\n"
        }
        
        if character.starships.count > 0 {
            message += "Starships\n"
            for starship in character.starships {
                message.append("\(starship)\n")
            }
        }
        
        let title = "Associated vehicles and starships"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        
        self.present(alert, animated: true)
    }

}

// MARK: - Conversion to English and Metric system

extension EntityViewController {
    @IBAction func sizeConverter(_ sender: UIButton) {
        
        if selectedEntityData == nil { return }
        
        var selectedEntity: EntityInfo
        
        switch entityCollection!.type {
        case .people:
            selectedEntity = selectedEntityData as! Character
        case .ships, .vehicles:
            selectedEntity = selectedEntityData as! Vehicle
        }
        
        
        if(sender.tag == 1 ){
            //metric selected
            sizeUnitEnglish.isSelected = false
            sender.isSelected = true
            
        } else {
            //english selected
            sizeUnitMetric.isSelected = false
            sender.isSelected = true
        }
        
    }
}















