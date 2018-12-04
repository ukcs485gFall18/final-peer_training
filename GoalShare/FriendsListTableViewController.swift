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
    
    override func viewDidAppear(_ animated: Bool) {
        self.postData.removeAll()
        //Set the firebase reference
        ref = Database.database().reference()
        
        //Set current user ID
        let currentUserId = Auth.auth().currentUser?.uid
        //Retrieve posts and listen for changes
        databaseHandle = ref?.child("friends").child(currentUserId!).observe(.childAdded, with: { (snapshot) in
            for users in snapshot.children {
                let friendSnap = users as! DataSnapshot
                self.postData.append(friendSnap.value as! String)
            }
            self.friendTableView.reloadData()
        })
        self.friendTableView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Fill cell from postData
        let thisCell = friendTableView.dequeueReusableCell(withIdentifier: "friendCell")
        thisCell?.textLabel?.text = postData[indexPath.row]
        return thisCell!
    }

    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        friendTableView.delegate = self
        friendTableView.dataSource = self
    }
}


