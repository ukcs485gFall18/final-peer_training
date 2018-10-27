//
//  LoginViewController.swift
//  GoalShare
//
//  Created by Seanna Lea LoBue on 10/20/18.
//  Copyright © 2018 Seanna Lea LoBue. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var pswdTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    
    @IBAction func loginPress(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTxt.text!, password: pswdTxt.text!) { (user, error) in
            if error != nil {
                print(error ?? "Error logging in with the provided information.")
            }else{
                self.performSegue(withIdentifier: "goToMain2", sender: self)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.borderWidth = 2
        loginButton.layer.cornerRadius = 10
        loginButton.layer.borderColor = #colorLiteral(red: 0.5576759543, green: 0.3133929401, blue: 0.4060785278, alpha: 1)
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
