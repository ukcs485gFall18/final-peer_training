//
//  ViewController.swift
//  GoalShare
//
//  Created by Seanna Lea LoBue on 10/11/18.
//  Copyright © 2018 Seanna Lea LoBue. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var registerButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    loginButton.layer.borderWidth = 2
    loginButton.layer.cornerRadius = 10
    loginButton.layer.borderColor = #colorLiteral(red: 0.5576759543, green: 0.3133929401, blue: 0.4060785278, alpha: 1)
        
    registerButton.layer.borderWidth = 2
    registerButton.layer.cornerRadius = 10
     registerButton.layer.borderColor = #colorLiteral(red: 0.5576759543, green: 0.3133929401, blue: 0.4060785278, alpha: 1)
    }


}

