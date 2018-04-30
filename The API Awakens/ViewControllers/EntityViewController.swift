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
    
    @IBOutlet var exhangeLabelCollection: [UILabel]!
    @IBOutlet weak var exchangeRateTextField: UITextField!
    
    
    // Variable for selected entity
    var selectedEntity: Entity?
    
    var selectedEntityData: EntityInfo?
    let client = SwapiClient()
    var entityCollection: EntityCollection? = nil
    var exchangeRate: Double = 0
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        //exchangeRateTextField.becomeFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        
        
        // Get entities
        guard let entityCollection = entityCollection else { fatalError()}
        
        setupNavBar()
        nameTheLabels()
        // Crash if inital value cannot be converted to double
        exchangeRate = Double(exchangeRateTextField.text!)!
        
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
            for label in exhangeLabelCollection {
                label.isHidden = true
            }
            exchangeRateTextField.isHidden = true
            
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
            
            //setup the default size
            self.sizeUnitMetric.isSelected = true
            self.sizeUnitEnglish.isSelected = false
            
            self.selectedEntityData = entity
            self.setupLabelValues(for: entity)
            
            if let entity = entity as? Character {
                entity.delegate = self
                self.assosVehicleBtn.setTitle("Show associated vehicles and starships (0)", for: .normal)
            } else {
                self.valueButtonUSD.isSelected = true
                self.valueButtonCredits.isSelected = false
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
        assosVehicleBtn.setTitle("Show associated vehicles and starships (\(count))", for: .normal)
    }
    
    func didSetHomeWorldName(character: Character) {
        infoLabel2Value.text = character.homeWorldName
    }
    
}


// MARK: - Vehicles and Starships list
extension EntityViewController {
    
    /// Show associated vehicles
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

// MARK: - Conversions

extension EntityViewController {
    @IBAction func sizeConverter(_ sender: UIButton) {
        
        if selectedEntityData == nil  { return }
        
        var metricsValue: Int = 0
        var britishValue: Int = 0
        var metricsSuffix: String = ""
        let britishSuffix = " inches"
        
        switch entityCollection!.type {
        case .people:
            let selectedEntity = selectedEntityData as! Character
            if let _ = selectedEntity.height {
                metricsValue = Int(selectedEntity.height!)
                britishValue = Int(selectedEntity.height! * 0.3937)
                metricsSuffix = "cm"
            } else {
                return
            }
        case .ships, .vehicles:
            let selectedEntity = selectedEntityData as! Vehicle
            
            if let _ = selectedEntity.length {
                metricsValue = Int(selectedEntity.length!)
                britishValue = Int(selectedEntity.length! * 100 * 0.3937)
                metricsSuffix = "m"
            } else {
                return
            }
        }
        
        
        if(sender.tag == 1 ){
            //metric selected
            sizeUnitEnglish.isSelected = false
            sender.isSelected = true
            infoLabel3Value.text = String(metricsValue) + metricsSuffix
            
        } else {
            //english selected
            sizeUnitMetric.isSelected = false
            sender.isSelected = true
            infoLabel3Value.text = String(britishValue) + britishSuffix
         }
        
    }
    
    @IBAction func costConverter(_ sender: UIButton) {
        
        var costInUsd: Int = 0
        var costInCredits: Int = 0
        
        switch entityCollection!.type {
        case .people:
            return
        case .ships, .vehicles:
            let selectedEntity = selectedEntityData as! Vehicle
            if let price = Double(selectedEntity.cost) {
                costInUsd = Int(price)
                costInCredits = Int(price * exchangeRate)
            } else {
                return
            }
        }

        if(sender.tag == 1 ){
            //credits selected
            valueButtonUSD.isSelected = false
            sender.isSelected = true
            infoLabel2Value.text = "\(costInCredits)"
            
        } else {
            //USD selected
            valueButtonCredits.isSelected = false
            sender.isSelected = true
            infoLabel2Value.text = "\(costInUsd)"
        }
        
    }
}

// MARK: - Exchange Rate InputField Delegate

extension EntityViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("Editing Started")
        //exchangeRateTextField.becomeFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("Should end editing")
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //print("Should return")
        if let rateNumber = Double(textField.text!), rateNumber > 0 {
            print(textField.text!)
        } else {
            Alert.showBasic(title: "Invalid rate", message: "Exchange rate must be a positive number (not even 0)", vc: self)
            return false
        }
        
        textField.resignFirstResponder()
        exchangeRate = Double(textField.text!)!
        
        //change the rate if credits label is shown
        if valueButtonCredits.isSelected {
            if let entity = selectedEntityData as? Vehicle, let price = Double(entity.cost) {
                infoLabel2Value.text = String(Int(price * exchangeRate))
            }
        }
        return true
    }
}















