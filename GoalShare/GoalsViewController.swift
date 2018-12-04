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

    @IBOutlet weak var goalName: UITextField!
    @IBOutlet weak var goalDes: UITextField!
    @IBOutlet weak var groupName: UITextField!
    @IBOutlet weak var inviteFriends: UITextField!
    @IBOutlet weak var myswitch: UISwitch!
    

    
    var dbref : DatabaseReference!
    var handle: DatabaseHandle!
    var gid: Int!
    var groupId: Int!
    var uid: String!
    var anyValue: AnyObject?
    var groupGoalFlag = 0
    var uidsToAdd = [String]()
    
    @IBAction func onAllAccessory(_ sender: UISwitch) {
        if myswitch.isOn == true {
            groupName.isHidden = false
            inviteFriends.isHidden = false
        } else {
            groupName.isHidden = true
            inviteFriends.isHidden = true
        }
    }
    
    @IBAction func DoneButtonPressed(_ sender: Any) {
        uid = Auth.auth().currentUser?.uid
        //This is going to be a group goal
        if (self.myswitch.isOn == true && self.groupName.text != "" && self.goalName.text != "" && self.goalDes.text != "") {
            let NamesArr = self.inviteFriends.text!.split(separator:",")
            //search if users in list exist and if so add them to the namesToAdd array
            dbref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: {(snapshot) in
                for child in snapshot.children {
                    let currentUser = child as! DataSnapshot
                    let currentUserName = currentUser.childSnapshot(forPath: "uname")
                    if (NamesArr.contains(currentUserName.value as! Substring)) {
                        let currentUserId = currentUser.childSnapshot(forPath: "uid")
                        self.uidsToAdd.append(currentUserId.value as! String)
                    }
                }
            })
            //retrieve the max gid and groupId
            dbref!.child("MaxIDs").queryOrderedByKey().observeSingleEvent(of: .value, with: {(snapshot) in
                let children = snapshot.value as! [String: Any]
                self.gid = children["gid"] as? Int
                self.groupId = children["groupId"] as? Int
                
                //create the new group
                self.dbref!.child("Groups").child(String(self.groupId)).setValue(["GroupName":self.groupName.text!,"uids":self.uidsToAdd])
                //update the max gid and groupId
                self.dbref.child("MaxIDs").setValue(["gid":self.gid+1,"groupId":self.groupId+1])
                //add the current users uid to the list
                self.uidsToAdd.append(self.uid)
                //add the goal to every member of the group
                for index in self.uidsToAdd {
                    self.dbref.child("Goals").child(String(index)).child("goals").child(String(self.gid)).setValue(["completed":"false","gid":self.gid,"gname":self.goalName.text!,"goal_des":self.goalDes.text!])
                }
            })
        }
        //This is an individual goal
        else if (self.goalName.text != "" && self.goalDes.text != "") {
            //retrieve the max gid
            dbref!.child("MaxIDs").queryOrderedByKey().observeSingleEvent(of: .value, with: {(snapshot) in
                let children = snapshot.value as! [String: Any]
                self.gid = children["gid"] as? Int
                
                //update the max gid, but leave groupId at current value
                self.dbref.child("MaxIDs").setValue(["gid":self.gid+1,"groupId":self.groupId])
                self.dbref.child("Goals").child(self.uid).child("goals").child(String(self.gid)).setValue(["completed":"false", "gid":self.gid, "gname":self.goalName.text!, "goal_des":self.goalDes.text!])
            })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        myswitch.isOn = false
        groupName.isHidden = true
        inviteFriends.isHidden = true
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        dbref =  Database.database().reference()
        // Do any additional setup after loading the view.
    }
}
