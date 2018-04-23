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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        charactersButton.alignImageAndTitleVertically()
        vehiclesButton.alignImageAndTitleVertically()
        starshipsButton.alignImageAndTitleVertically()
        self.navigationController?.isNavigationBarHidden = true
        
        
    }
    
    @IBAction func changeToEntityController(_ sender: Any) {
        
    }
    

}



