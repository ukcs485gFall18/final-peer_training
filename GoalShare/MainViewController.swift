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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.summaryTableView.reloadData()
    }
    
    
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

        if(friendData.count == 0){
            friendHandle = dbref?.child("friends").child(currentUser).observe(.childAdded, with: { (snapshot) in
                for friend in snapshot.children{
                    let friendSnap = friend as! DataSnapshot
                    let friend = FriendModel(snap: friendSnap)
                    self.goalHandle = self.dbref?.child("Goals/\(friend.uid)").observe(.childAdded, with: { (goalSnapshot) in
                        var goals = [GoalModel]()
                        for goal in goalSnapshot.children {
                            let fgoal = GoalModel(snap: goal as! DataSnapshot)
                            goals.append(fgoal)
                        }
                        friend.goals = goals
                        friend.calculateCompletionRate(goals)
                        //print("*** Count of friend goals = \(friend.goals.count)")
                    })
                    if(!self.friendData.contains(friend)){
                        self.friendData.append(friend)
                    }
                    self.items[0] = self.friendData
                    self.summaryTableView.reloadData()
                }
            })
        }
        
        if(goalData.count == 0){
            goalHandle = dbref?.child("Goals/\(currentUser)").observe(.childAdded, with: { (goalSnapshot) in
                for goal in goalSnapshot.children{
                    let ugoal = GoalModel(snap: goal as! DataSnapshot)
                    self.goalData.append(ugoal)
                }
                self.items[1] = self.goalData
                self.summaryTableView.reloadData()
            })
        }
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
        if items[section].count > 5{
            return maxRows
        }else if items[section].count == 0 {
            return 1
        }else {
            return items[section].count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = summaryTableView.dequeueReusableCell(withIdentifier: "cell")
        if(indexPath.section == 0){
            if friendData.count > 0 {
                let friend = items[indexPath.section][indexPath.row] as! FriendModel
                cell?.textLabel?.text = friend.nickName
                print("*** \(friend.nickName) has completed \(friend.completePercent)% of their goals.")
                cell?.detailTextLabel?.text = "\(friend.nickName) has completed \(friend.completePercent)% of their goals."
            }else{
                cell?.textLabel?.text = "No Friends Found"
                cell?.detailTextLabel?.text = "Go to the Friends menu to add a friend."
            }
        }else if(indexPath.section == 1){
            if goalData.count > 0 {
                let goal = items[indexPath.section][indexPath.row] as! GoalModel
                cell?.textLabel?.text = goal.goal_desc
                let completionStatus = (goal.complete == "true" ? "completed" : "not completed")
                print("*** \(goal.goalName) is \(goal.complete) for today.")
                cell?.detailTextLabel?.text = "\(goal.goalName) is \(completionStatus) for today."
            }else{
                cell?.textLabel?.text = "No Goals Found"
                cell?.detailTextLabel?.text = "Go to the Goals menu to create your first Goal."
            }
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
