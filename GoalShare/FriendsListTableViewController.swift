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
    //let currentUser = Auth.auth().currentUser?.uid
    var postData = [String]()
    
    //setting datasource for summary
    var friendData = [String]()
    let sections = ["Friends",
                    "Groups"]
    //TODO will need to be friend model and group model
    var items = [[String]() as [Any],
                 [GoalModel]()]
    var tintColors = [ #colorLiteral(red: 0.3182998379, green: 0.3019897466, blue: 0.4855987017, alpha: 0.9021476506), #colorLiteral(red: 0.21545305, green: 0.4786607049, blue: 0.5639418172, alpha: 0.9021476506), #colorLiteral(red: 0.3869009155, green: 0.696799651, blue: 0.3262433093, alpha: 0.9021476506), #colorLiteral(red: 0.696799651, green: 0.04511301659, blue: 0.0009451018385, alpha: 0.9021476506), #colorLiteral(red: 0.7189426104, green: 0.71675867, blue: 0.27614689, alpha: 0.9021476506) ]
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentUserId = Auth.auth().currentUser?.uid

        friendTableView.delegate = self
        friendTableView.dataSource = self
        
        // build reference to Firebase
        ref = Database.database().reference()
        //maynot need this if
        print("FRIEEEENDDD")
        print(friendData.count)
        if(friendData.count == 0){
            databaseHandle = ref?.child("friends").child(currentUserId!).observe(.childAdded, with: { (snapshot) in
                for users in snapshot.children {
                    let friendSnap = users as! DataSnapshot
                    print("MyFriends")
                    print(friendSnap.value)
                    self.friendData.append(friendSnap.value as! String)
                }
                print("FRIEEEENDDD COUNNNT")
                print(self.friendData.count)
                self.items[0] = self.friendData
                self.friendTableView.reloadData()
            })
        }
        
        
        //This was in loop
       /* ref?.child("friends").child(currentUser!).observe(.childAdded, with: { (snapshot) in
            for friend in snapshot.children{
                let friendSnap = friend as! DataSnapshot
                let friend = FriendModel(snap: friendSnap)
            }
            self.items[0] = self.friendData
            self.friendTableView.reloadData()
        })*/
        
        //Below was code before changing to split view
        /*self.postData.removeAll()
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
         self.friendTableView.reloadData()*/
    }
    override func viewDidAppear(_ animated: Bool) {
        let currentUser = Auth.auth().currentUser?.uid
        
        friendTableView.delegate = self
        friendTableView.dataSource = self
        
        // build reference to Firebase
        ref = Database.database().reference()

        self.friendTableView.reloadData()
    }
    // Table - Delegate Functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let maxRows = 5
        if items[section].count > 5{
            return maxRows
        }else if items[section].count == 0 {
            return 1
        }else {
            return items[section].count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = friendTableView.dequeueReusableCell(withIdentifier: "cell")
        print("INDEX")
        print(friendData.count)
        if(indexPath.section == 0){
            if friendData.count > 0 {
                //let friend = items[indexPath.section][indexPath.row] as! FriendModel
                cell?.textLabel?.text = friendData[indexPath.row]
                let timage = UIImage(named: "message")?.withRenderingMode(.alwaysTemplate)
                let msgBtn = UIButton()
                msgBtn.setImage(timage, for: .normal)
                msgBtn.tintColor = tintColors[0]
                cell?.addSubview(msgBtn)
            }else{
                cell?.textLabel?.text = "No Friends Found"
                cell?.detailTextLabel?.text = "Go to the Friends menu to add a friend."
            }
        } else{
            cell?.textLabel?.text = "Error"
            cell?.detailTextLabel?.text = "No data found"
        }
        return cell!
        /*// Fill cell from postData
         let thisCell = friendTableView.dequeueReusableCell(withIdentifier: "friendCell")
         thisCell?.textLabel?.text = postData[indexPath.row]
         return thisCell!*/
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = #colorLiteral(red: 0.5571277142, green: 0.3138887882, blue: 0.4069343805, alpha: 0.5)
    }
    /* override func viewDidLoad() {
     // Do any additional setup after loading the view.
     friendTableView.delegate = self
     friendTableView.dataSource = self
     }*/
}


