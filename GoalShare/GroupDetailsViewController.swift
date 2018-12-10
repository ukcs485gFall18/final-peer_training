//
//  GroupDetailsViewController.swift
//  GoalShare
//
//  Created by Willis, Bryan A on 12/9/18.
//  Copyright © 2018 Seanna Lea LoBue. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class GroupDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var groupTableView: UITableView!
    var groupName: String?
    var ref:DatabaseReference?
    var friendData = [String]()
    var tintColors = [ #colorLiteral(red: 0.3182998379, green: 0.3019897466, blue: 0.4855987017, alpha: 0.9021476506), #colorLiteral(red: 0.21545305, green: 0.4786607049, blue: 0.5639418172, alpha: 0.9021476506), #colorLiteral(red: 0.3869009155, green: 0.696799651, blue: 0.3262433093, alpha: 0.9021476506), #colorLiteral(red: 0.696799651, green: 0.04511301659, blue: 0.0009451018385, alpha: 0.9021476506), #colorLiteral(red: 0.7189426104, green: 0.71675867, blue: 0.27614689, alpha: 0.9021476506) ]

    override func viewDidLoad() {
        super.viewDidLoad()
        //let currentUserId = Auth.auth().currentUser?.uid
        
        groupTableView.delegate = self
        groupTableView.dataSource = self
        
        // build reference to Firebase
        ref = Database.database().reference()
        if(friendData.count == 0){
            ref?.child("Groups").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
                for child in snapshot.children {
                    let currentGroupId = child as! DataSnapshot
                    let currentGroupName = currentGroupId.childSnapshot(forPath: "GroupName")
                    if (self.groupName == currentGroupName.value as? String) {
                        let users = currentGroupId.childSnapshot(forPath: "uids")
                        for grandChild in users.children {
                            let currentFriendInfo = grandChild as! DataSnapshot
                            let currentFriendName = currentFriendInfo.childSnapshot(forPath: "1")
                            self.friendData.append(currentFriendName.value as! String)
                        }
                    }
                }
            })
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        groupTableView.delegate = self
        groupTableView.dataSource = self
        // build reference to Firebase
        ref = Database.database().reference()
        
        self.groupTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = groupTableView.dequeueReusableCell(withIdentifier: "cell")
        if(indexPath.section == 0){
            if friendData.count > 0 {
                cell?.textLabel?.text = friendData[indexPath.row]
            } else{
                cell?.textLabel?.text = "No Friends Found"
                cell?.detailTextLabel?.text = "Go to the Friends menu to add a friend!"
            }
        } else{
            cell?.textLabel?.text = "Error"
            cell?.detailTextLabel?.text = "No data found"
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return "Group Members"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendData.count
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        //TODO center text
        view.tintColor = #colorLiteral(red: 0.696799651, green: 0.04511301659, blue: 0.0009451018385, alpha: 0.9021476506)
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
