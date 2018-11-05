//
//  FriendsListTableViewController.swift
//  GoalShare
//
//  Created by Bryan Willis on 11/5/18.
//  Copyright © 2018 Bryan Willis. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class FriendsListTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var friendTableView: UITableView!
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    var postData = [String]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Set current user ID
        let currentUserId = Auth.auth().currentUser?.uid
        
        // Fill cell from postData
        let thisCell = friendTableView.dequeueReusableCell(withIdentifier: "friendCell")
        thisCell?.textLabel?.text = postData[indexPath.row]
        print(postData[indexPath.row])
        return thisCell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //Set current user ID
        //let currentUserId = Auth.auth().currentUser?.uid
        
        // Get text for current row
        let currentCell = friendTableView.cellForRow(at: indexPath) as! UITableViewCell
        //let cellName = currentCell.textLabel!.text
        
        // Set value to true
        //ref!.child("goals").child(cellName!).child("uids").child(currentUserId!).setValue(["completed":"true"])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        friendTableView.delegate = self
        friendTableView.dataSource = self
        
        //Set the firebase reference
        ref = Database.database().reference()
        
        //Set current user ID
        let currentUserId = Auth.auth().currentUser?.uid
        
        //Retrieve posts and listen for changes
        databaseHandle = ref?.child("friends").child(currentUserId!).observe(.childAdded, with: { (snapshot) in
            for users in snapshot.children {
                print("snap key = \(snapshot.key)")
                let friendSnap = users as! DataSnapshot
                print("friendSnap key = \(friendSnap.key)")
                self.postData.append(friendSnap.value as! String)
             }
            self.friendTableView.reloadData()
            //self.postData.append()
        })
    }
}


