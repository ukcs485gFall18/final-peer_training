//
//  GoalListViewController.swift
//
//
//  Created by Hurst, Conner on 10/29/18.
//
import UIKit
import Firebase
import FirebaseDatabase

class GoalListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    var completedHandle:DatabaseHandle?
    var goalData = [GoalModel]()
    var postData = [String]()
    var sendGoal: GoalModel?
    var postLogId = ""
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Fill cell from postData
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = postData[indexPath.row]
        
        //Fill with checkmark if the goal is completed
        for goals in goalData{
            if(goals.goalName == postData[indexPath.row]){
                if(goals.complete == "true"){
                    cell?.accessoryType = UITableViewCell.AccessoryType.checkmark
                }
                else{
                    cell?.accessoryType = UITableViewCell.AccessoryType.none
                }
            }
        }
        return cell!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //Set the firebase reference
        ref = Database.database().reference()
        
        //Set current user ID
        let currentUserId = Auth.auth().currentUser?.uid
        
        // reset goals to false if they haven't been completed today
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let currentDate = formatter.string(from: date)

        databaseHandle = ref?.child("goalHistory").child(currentUserId!).observe(.value, with: { (snapshot) in
            for gid in snapshot.children {
                let gidSnap = gid as! DataSnapshot
                var completed = false
                for date in gidSnap.children {
                    let dateSnap = date as! DataSnapshot
                    if (dateSnap.key == currentDate){
                        completed = true
                    }
                }
                if (completed == false) {
                    self.ref!.child("Goals").child(currentUserId!).child("goals").child(gidSnap.key).updateChildValues(["completed":"false"])
                }
            }
        })
        
        // fill goalData with user's goals and append gnames to postData
        databaseHandle = self.ref?.child("Goals").child(currentUserId!).child("goals").observe(.value, with: { (goalSnapshot) in
            self.postData.removeAll()
            self.goalData.removeAll()
            for goal in goalSnapshot.children {
                print("*** Goal info - \(String(describing: goal))")
                let fgoal = GoalModel(snap: goal as! DataSnapshot)
                self.goalData.append(fgoal)
            }
            
            for goal in self.goalData {
                self.postData.append(goal.goalName)
            }
            self.tableView.reloadData()
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {
        //Array of action objects
        let complete = UITableViewRowAction(style: .normal, title: "Complete") { action, index in
            print("complete button tapped")
            
            //Set current user ID
            let currentUserId = Auth.auth().currentUser?.uid
            
            // Get text for current row
            let currentCell = tableView.cellForRow(at: indexPath)
            let cellName = currentCell!.textLabel!.text
            
            // get current date
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMdd"
            let currentDate = formatter.string(from: date)
            
            // mark as completed, and then log data
            for goals in self.goalData{
                if(goals.goalName == cellName){
                    self.ref!.child("Goals").child(currentUserId!).child("goals").child(String(goals.gid)).setValue(["completed":"true","gid":goals.gid,"gname":goals.goalName,"goal_des":goals.goal_desc])
                    self.ref?.child("goalHistory").child(currentUserId!).child(String(goals.gid)).child(currentDate).setValue(["true"])
                }
            }
        }
        complete.backgroundColor = #colorLiteral(red: 0.3869009155, green: 0.696799651, blue: 0.3262433093, alpha: 0.75)
        
        let details = UITableViewRowAction(style: .normal, title: "Details") { action, index in
            
            // get cellname
            let currentCell = tableView.cellForRow(at: indexPath) as! UITableViewCell
            let cellName = currentCell.textLabel!.text
            
            // set sendgid
            for goals in self.goalData{
                if(goals.goalName == cellName){
                    self.sendGoal = goals
                }
            }
            
            // segue to description
            self.performSegue(withIdentifier: "goalDescription", sender: cellName)
        }
        details.backgroundColor = #colorLiteral(red: 0.7189426104, green: 0.71675867, blue: 0.27614689, alpha: 0.75)
        
        return [complete, details]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let secondVC = segue.destination as? GoalDetailsViewController else {return}
        secondVC.sentGoal = sendGoal
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return "Goals"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = #colorLiteral(red: 0.3182998379, green: 0.3019897466, blue: 0.4855987017, alpha: 0.65)
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
