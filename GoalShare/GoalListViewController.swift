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
    var sendgid: Int?
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
        
        //****
        // This section is for resetting goals to false if they haven't been completed today
        // I started on it but realized it's low priority so it is unfinished
        //****
//        //get current date
//        let date = Date()
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyyMMdd"
//        let currentDate = formatter.string(from: date)
//
//        databaseHandle = ref?.child("goalHistory").child(currentUserId!).observe(.value, with: { (snapshot) in
//            for gid in snapshot.children {
//                let gidSnap = gid as! DataSnapshot
//                var completed = false
//                for date in gidSnap.children {
//                    let dateSnap = date as! DataSnapshot
//                    if (dateSnap.key == currentDate){
//                        completed = true
//                    }
//                }
//                if (completed == false) {
//                    // Set value to false
//                    //self.ref!.child("goals").child(cellName!).child("uids").child(currentUserId!).setValue(["completed":"true"])
//                }
//            }
//        })
        
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
            let currentCell = tableView.cellForRow(at: indexPath) as! UITableViewCell
            let cellName = currentCell.textLabel!.text
            
            // Set value to true
            //self.ref!.child("Goals").child(currentUserId!).child().setValue(["completed":"true"])
            
            // store in log
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
        complete.backgroundColor = .lightGray
        
        let details = UITableViewRowAction(style: .normal, title: "Details") { action, index in
            
            // get cellname
            let currentCell = tableView.cellForRow(at: indexPath) as! UITableViewCell
            let cellName = currentCell.textLabel!.text
            
            // set sendgid
            for goals in self.goalData{
                if(goals.goalName == cellName){
                    self.sendgid = goals.gid
                }
            }
            
            // segue to description
            self.performSegue(withIdentifier: "goalDescription", sender: cellName)
            print("details button tapped")
        }
        details.backgroundColor = .orange
        
        return [complete, details]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let secondVC = segue.destination as? GoalDetailsViewController else {return}
        secondVC.sentgid = sendgid
    
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
