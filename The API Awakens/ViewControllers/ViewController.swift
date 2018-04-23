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
        if let sender = sender as? UIButton {
            print(sender.tag)
        }
    }
    
    @IBAction func changeToEntityController(_ sender: UIButton) {
        performSegue(withIdentifier: "showEntity", sender: sender)
    }
    

}



