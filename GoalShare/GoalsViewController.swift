//
//  GoalsViewController.swift
//  GoalShare
//
//  Created by Seanna Lea LoBue on 10/20/18.
//  Copyright © 2018 Seanna Lea LoBue. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class GoalsViewController: UIViewController {
    
    @IBOutlet weak var goalNameTxt: UITextField!
    @IBOutlet weak var goalDescriptionTxt: UITextField!
    
    let dbref = Database.database().reference()
    
    
    @IBAction func DoneButtonPressed(_ sender: Any) {
        //This is currently hardcoded for test purposes. Will change
        let gid = "0"
        if let goalDes = goalDescriptionTxt.text {
            if goalDes != "" {
                let uid = Auth.auth().currentUser?.uid
                self.dbref.child("goals").child(gid).setValue(["gid":1, "goal_description":goalDes])
            self.dbref.child("goals").child(gid).child("uids").child(uid!).setValue(["completed":"false"])
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
