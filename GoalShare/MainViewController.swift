//
//  MainViewController.swift
//  GoalShare
//
//  Seanna Lea LoBue
//  Last update 11/28/2018
//  ** Added Split TableView to display summary info
//

import UIKit
import Firebase
import FirebaseDatabase

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var summaryTableView: UITableView!
    var dbref : DatabaseReference!
    let currentUser = Auth.auth().currentUser?.uid
    var friendHandle : DatabaseHandle?
    var goalHandle : DatabaseHandle?
    
    // setting datasource for summary
    var friendData = [FriendModel]()
    var goalData = [GoalModel]()
    let sections = ["Friends",
                    "My Goals"]
    var items = [[FriendModel]() as [Any],
                 [GoalModel]()]

    
    // View Display and Data Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        summaryTableView.delegate = self
        summaryTableView.dataSource = self
        
        // build reference to Firebase
        dbref = Database.database().reference()
        guard let currentUser = currentUser else{
            print("/(curentUser) not defined.")
            fatalError("Current User is not defined.")
        }
        
        friendHandle = dbref?.child("friends").child(currentUser).observe(.childAdded, with: { (snapshot) in
            for friend in snapshot.children{
                let friendSnap = friend as! DataSnapshot
                let friend = FriendModel(snap: friendSnap)
                self.goalHandle = self.dbref?.child("Goals/\(friend.uid)").observe(.childAdded, with: { (goalSnapshot) in
                var goals = [GoalModel]()
                    for goal in goalSnapshot.children {
                        print("*** Goal info - \(String(describing: goal))")
                        let fgoal = GoalModel(snap: goal as! DataSnapshot)
                        goals.append(fgoal)
                    }
                    friend.goals = goals
                    })
                self.friendData.append(friend)
                }
            self.items[0] = self.friendData
            //print("*** COUNT of friendData - \(self.friendData.count)")
            self.summaryTableView.reloadData()
        })
    }

    override func viewDidAppear(_ animated: Bool) {
        self.summaryTableView.reloadData()
    }
    
    
    // Table - Delegate Functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let maxRows = 5
        //print("*** ITEMS SECTION *** \(section)")
        if items[section].count > 5{
            return maxRows
        }else{
            return items[section].count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = summaryTableView.dequeueReusableCell(withIdentifier: "cell")
        if(indexPath.section == 0){
            let friend = items[indexPath.section][indexPath.row] as! FriendModel
            cell?.textLabel?.text = friend.nickName
            cell?.detailTextLabel?.text = "\(friend.nickName) has completed \(friend.completeRate)% of their goals."
        }else{
            cell?.textLabel?.text = "Testing"
            cell?.detailTextLabel?.text = "No Completion Found"
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = #colorLiteral(red: 0.5571277142, green: 0.3138887882, blue: 0.4069343805, alpha: 0.5)
    }
}
