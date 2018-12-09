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
    var friendData = [String]()
    var groupData = [String]()
    let sections = ["Friends",
                    "Groups"]
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
        if(friendData.count == 0){
            databaseHandle = ref?.child("friends").child(currentUserId!).observe(.childAdded, with: { (snapshot) in
                for users in snapshot.children {
                    let friendSnap = users as! DataSnapshot
                    self.friendData.append(friendSnap.value as! String)
                }
                self.items[0] = self.friendData
                self.friendTableView.reloadData()
            })
        }
        ref!.child("Groups").queryOrderedByKey().observeSingleEvent(of: .value, with: {(snapshot) in
            for child in snapshot.children {
                let currentGroupNumber = child as! DataSnapshot
                let currentGroupName = currentGroupNumber.childSnapshot(forPath: "GroupName")
                let usersInCurrentGroup = currentGroupNumber.childSnapshot(forPath: "uids")
                for grandChild in usersInCurrentGroup.children {
                    let currentUser = grandChild as! DataSnapshot
                    let currentUserUid = currentUser.childSnapshot(forPath: "0")
                    //let currentUserUname = currentUser.childSnapshot(forPath: "1")
                    if (currentUserUid.value as! String == currentUserId!) {
                        self.groupData.append(currentGroupName.value as! String)
                    }
                }
                self.items[1] = self.groupData
                self.friendTableView.reloadData()
            }
        })
    }
    override func viewDidAppear(_ animated: Bool) {
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
        if(indexPath.section == 0){
            if friendData.count > 0 {
                cell?.textLabel?.text = friendData[indexPath.row]
            } else{
                cell?.textLabel?.text = "No Friends Found"
                cell?.detailTextLabel?.text = "Go to the Friends menu to add a friend!"
            }
        } else if(indexPath.section == 1) {
            if groupData.count > 0 {
                cell?.textLabel?.text = groupData[indexPath.row]
            } else{
                cell?.textLabel?.text = "No groups Found"
                cell?.detailTextLabel?.text = "Go to the Goals menu to create a new group goal!"
            }
        } else{
            cell?.textLabel?.text = "Error"
            cell?.detailTextLabel?.text = "No data found"
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        if (section == 0) {
            return "My Friends"
        } else {
            return "My Groups"
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.section)
        if(indexPath.section == 1) {
            self.performSegue(withIdentifier: "GroupDetails", sender: indexPath)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GroupDetails" {
            let destination = (segue.destination as! GroupDetailsTableViewController)
            print(destination)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        //TODO center text
        view.tintColor = #colorLiteral(red: 0.21545305, green: 0.4786607049, blue: 0.5639418172, alpha: 0.9021476506)
    }
}

class GroupDetails: UIStoryboardSegue {
    override func perform() {
        let slideView = destination.view
        source.view.addSubview(slideView!)
        slideView?.transform = CGAffineTransform(translationX: source.view.frame.size.width, y: 0)
        
        UIView.animate(withDuration: 0.25,
                       delay: 0.0,
                       options: UIView.AnimationOptions.curveEaseInOut,
                       animations: {
                        slideView?.transform = CGAffineTransform.identity
        }, completion: { finished in
            
            self.source.present(self.destination, animated: false, completion: nil)
            slideView?.removeFromSuperview()
        })
    }
}
