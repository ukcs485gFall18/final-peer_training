//
//  GoalsViewController.swift
//  GoalShare
//
//  Created by Bryan Willis on 10/20/18.
//  Copyright © 2018 Bryan Willis. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class GoalsViewController: UIViewController {
    @IBOutlet weak var goalNameTxt: UITextField!
    @IBOutlet weak var goalDescriptionTxt: UITextField!
    
    var dbref : DatabaseReference!
    var gid: Int!
    var anyValue: AnyObject?
    
    @IBAction func DoneButtonPressed(_ sender: Any) {
        if let goalDes = goalDescriptionTxt.text {
            if let goalName = goalNameTxt.text {
                if (goalDes != "" && goalName != "") {
                    dbref.child("goals").queryOrdered(byChild: "gid").queryLimited(toLast: 1).observeSingleEvent(of: .value, with: {
                        snapshot in
                        guard let fetchedData = snapshot.children.allObjects as? [DataSnapshot] else {return}
                        for item in fetchedData {
                            let value = item.value as! [String: AnyObject]
                            self.anyValue = value["gid"]
                        }
                        let maxGid = self.anyValue as? Int
                        if let retrievedGid = maxGid as? Int {
                            self.gid = retrievedGid + 1
                        } else {
                            self.gid = 0
                        }
                        let uid = Auth.auth().currentUser?.uid
                        self.dbref.child("goals").child(goalName).setValue(["gid":self.gid, "goal_des":goalDes])
                        self.dbref.child("goals").child(goalName).child("uids").child(uid!).setValue(["completed":"false"])
                    })
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        dbref =  Database.database().reference()
        // Do any additional setup after loading the view.
    }
}
