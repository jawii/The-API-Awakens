//
//  ViewController.swift
//  The API Awakens
//
//  Created by Jaakko Kenttä on 23/04/2018.
//  Copyright © 2018 Jaakko Kenttä. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var charactersButton: UIButton!
    @IBOutlet weak var vehiclesButton: UIButton!
    @IBOutlet weak var starshipsButton: UIButton!
    
    
    // Setup the status bar white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        charactersButton.alignImageAndTitleVertically()
        vehiclesButton.alignImageAndTitleVertically()
        starshipsButton.alignImageAndTitleVertically()

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.white
        
        
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        var entityType: EntityList?
        if let sender = sender as? UIButton {
            
            switch sender.tag {
            case 0: entityType = .people
            case 1: entityType = .vehicles
            case 2: entityType = .ships
            default: return
            }
        }
        if let entityType = entityType {
            let controller = segue.destination as? EntityViewController
            controller?.entityCollection = EntityCollection(type: entityType)
        }
    }
    
    @IBAction func changeToEntityController(_ sender: UIButton) {
        performSegue(withIdentifier: "showEntity", sender: sender)
    }
    

}



