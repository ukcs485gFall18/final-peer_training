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
    var valueToPass:String!
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    var postData = [String]()
    var numOfMembersInGroups = [String]()
    var friendData = [String]()
    var groupData = [String]()
    let sections = ["Friends",
                    "Groups"]
    var items = [[String]() as [Any],
                 [GoalModel]()]
    var tintColors = [ #colorLiteral(red: 0.3182998379, green: 0.3019897466, blue: 0.4855987017, alpha: 0.9021476506), #colorLiteral(red: 0.21545305, green: 0.4786607049, blue: 0.5639418172, alpha: 0.9021476506), #colorLiteral(red: 0.3869009155, green: 0.696799651, blue: 0.3262433093, alpha: 0.9021476506), #colorLiteral(red: 0.696799651, green: 0.04511301659, blue: 0.0009451018385, alpha: 0.9021476506), #colorLiteral(red: 0.7189426104, green: 0.71675867, blue: 0.27614689, alpha: 0.9021476506) ]
    override func viewDidLoad() {
        super.viewDidLoad()

        friendTableView.delegate = self
        friendTableView.dataSource = self
    }
    override func viewDidAppear(_ animated: Bool) {
        friendTableView.delegate = self
        friendTableView.dataSource = self
        let currentUserId = Auth.auth().currentUser?.uid

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
                    if (currentUserUid.value as! String == currentUserId!) {
                        self.groupData.append(currentGroupName.value as! String)
                        self.numOfMembersInGroups.append(String(usersInCurrentGroup.childrenCount))
                    }
                }
                self.items[1] = self.groupData
                self.friendTableView.reloadData()
            }
        })
        self.friendTableView.reloadData()
    }
    // Table - Delegate Functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let maxRows = items[section].count
        if items[section].count > 0{
            return maxRows
        }else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = friendTableView.dequeueReusableCell(withIdentifier: "cell")
        if(indexPath.section == 0){
            if friendData.count > 0 {
                cell?.textLabel?.text = friendData[indexPath.row]
                cell?.detailTextLabel?.text = ""
            } else{
                cell?.textLabel?.text = "No Friends Found"
            }
        } else if(indexPath.section == 1) {
            if groupData.count > 0 {
                cell?.textLabel?.text = groupData[indexPath.row]
                cell?.detailTextLabel?.text = self.numOfMembersInGroups[indexPath.row]+" members in this group!"
            } else{
                cell?.textLabel?.text = "No groups Found"
                cell?.detailTextLabel?.text = "Go to the Goals menu to create a new group goal!"
            }
        } else {
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
        if(indexPath.section == 1) {
            let selected = friendTableView.cellForRow(at: indexPath)
            valueToPass = selected?.textLabel?.text
            self.performSegue(withIdentifier: "GroupDetails", sender: self)
        } else {
            valueToPass = "None"
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GroupDetails" {
            let viewController = segue.destination as! GroupDetailsViewController
            viewController.groupName = valueToPass
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        //TODO center text
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        //header.textLabel?.font = UIFont(name: "YourFontname", size: 14.0)
        header.textLabel?.textAlignment = NSTextAlignment.center
        view.tintColor = #colorLiteral(red: 0.21545305, green: 0.4786607049, blue: 0.5639418172, alpha: 0.9021476506)
    }
    @IBAction func unwindToVC1(segue:UIStoryboardSegue) {
        let Scene = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "FriendsViewController") as UIViewController
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        appDelegate.window?.rootViewController = Scene
    }
}
