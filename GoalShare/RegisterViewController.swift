//
//  RegisterViewController.swift
//  GoalShare
//
//  Created by Seanna Lea LoBue on 10/20/18.
//  Copyright © 2018 Seanna Lea LoBue. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class RegisterViewController: UIViewController {

    @IBOutlet weak var nicknameTxt: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var emailTxt: UITextField!
    
    @IBOutlet weak var pswdTxt: UITextField!
    
    @IBOutlet weak var confirmPswdTxt: UITextField!
    
    @IBOutlet weak var warningLbl: UILabel!
    
    let dbRef = Database.database().reference()
    
    @IBAction func registerPress(_ sender: Any) {
        if pswdTxt.text == confirmPswdTxt.text{
            if let email = emailTxt.text {
                Auth.auth().createUser(withEmail: email, password: pswdTxt.text!) { (user, error) in
                    if error != nil{
                        print(error ?? "Error registering new user.")
                    }else{
                        let uid = Auth.auth().currentUser?.uid
                        self.dbRef.child("users").child(uid!).setValue(["uid": uid, "uname": self.nicknameTxt.text!])
                        self.performSegue(withIdentifier: "goToMain", sender: self)
                    }
                    }
            }
        }else {
            warningLbl.text = "Your Passwords do not match."
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerButton.layer.borderWidth = 2
        registerButton.layer.cornerRadius = 10
        registerButton.layer.borderColor = #colorLiteral(red: 0.5576759543, green: 0.3133929401, blue: 0.4060785278, alpha: 1)
   
            self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }


}
