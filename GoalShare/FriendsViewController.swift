//
//  FriendsViewController.swift
//  GoalShare
//
//  Created by Bryan Willis on 11/5/18.
//  Copyright © 2018 Bryan Willis. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class FriendsViewController: UIViewController {
  

    @IBOutlet weak var NameTxt: UITextField!
    var dbref : DatabaseReference!
    var anyValue: AnyObject?
    let uid = Auth.auth().currentUser?.uid
    
    @IBAction func Add_Button_Pressed(_ sender: Any) {
        if let Name = NameTxt.text {
            if (Name != "") {
                //search the database for the user
                dbref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
                    for snap in snapshot.children {
                        let userSnap = snap as! DataSnapshot
                        let friendUid = userSnap.key //the uid of each user
                        let userDict = userSnap.value as! [String:AnyObject] //child data
                        let userName = userDict["uname"] as! String
                        if (Name == userName) {
                            self.dbref.child("friends").child(self.uid!).child("uids").child(friendUid).setValue(Name)
                                print("Friend Added!")
                        }
                    }
                })
            }
        }
    } //Add_Button_pressed */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        dbref =  Database.database().reference()
        // Do any additional setup after loading the view.
    }
}
