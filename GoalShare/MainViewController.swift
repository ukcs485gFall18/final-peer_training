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
    var tintColors = [ #colorLiteral(red: 0.3182998379, green: 0.3019897466, blue: 0.4855987017, alpha: 0.9021476506), #colorLiteral(red: 0.21545305, green: 0.4786607049, blue: 0.5639418172, alpha: 0.9021476506), #colorLiteral(red: 0.3869009155, green: 0.696799651, blue: 0.3262433093, alpha: 0.9021476506), #colorLiteral(red: 0.696799651, green: 0.04511301659, blue: 0.0009451018385, alpha: 0.9021476506), #colorLiteral(red: 0.7189426104, green: 0.71675867, blue: 0.27614689, alpha: 0.9021476506) ]
    
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
        var goals = [GoalModel]()
        if(friendData.count == 0){
            friendHandle = dbref?.child("friends").child(currentUser).observe(.childAdded, with: { (snapshot) in
                for friend in snapshot.children{
                    let friendSnap = friend as! DataSnapshot
                    let friend = FriendModel(snap: friendSnap)
                    self.goalHandle = self.dbref?.child("Goals/\(friend.uid)").observe(.childAdded, with: { (goalSnapshot) in
                        for goal in goalSnapshot.children {
                            let fgoal = GoalModel(snap: goal as! DataSnapshot)
                            goals.append(fgoal)
                        }
                        friend.goals = goals
                        print("*** Count of friend goals = \(friend.goals.count)")
                    })
                    if(!self.friendData.contains(friend)){
                        friend.completePercent = friend.calculateCompletionRate()
                        self.friendData.append(friend)
                    }
                }
                self.items[0] = self.friendData
                self.summaryTableView.reloadData()
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
        self.summaryTableView.reloadData()
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
                friend.completePercent = friend.calculateCompletionRate()
                print("*** \(friend.nickName) has completed \(friend.completePercent)% of their goals.")
                cell?.detailTextLabel?.text = "\(friend.nickName) has completed \(friend.completePercent)% of their goals."
                let tindex = friend.completePercent == 0 ? 0 : Int(friend.completePercent / 20) - 1
                let timage = UIImage(named: "message")?.withRenderingMode(.alwaysTemplate)
                let msgBtn = UIButton()
                msgBtn.setImage(timage, for: .normal)
                msgBtn.tintColor = tintColors[tindex]
                cell?.addSubview(msgBtn)
            }else{
                cell?.textLabel?.text = "No Friends Found"
                cell?.detailTextLabel?.text = "Go to the Friends menu to add a friend."
            }
        }else if(indexPath.section == 1){
            if goalData.count > 0 {
                let goal = items[indexPath.section][indexPath.row] as! GoalModel
                cell?.textLabel?.text = goal.goal_desc
                let completionStatus = (goal.complete == "true" ? "completed" : "not completed")
                cell?.detailTextLabel?.text = "\(goal.goalName) is \(completionStatus) for today."
            }else{
                cell?.textLabel?.text = "No Goals Found"
                cell?.detailTextLabel?.text = "Go to the Goals menu to create your first Goal."
            }
        }else{
            cell?.textLabel?.text = "Error"
            cell?.detailTextLabel?.text = "No data found"
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
