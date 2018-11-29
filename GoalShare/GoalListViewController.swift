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
    //var currentUserId = Auth.auth().currentUser?.uid
    
    var postData = [String]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Set current user ID
        let currentUserId = Auth.auth().currentUser?.uid
        
        // Fill cell from postData
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = postData[indexPath.row]
        
        //Fill with checkmark if the goal is completed
        completedHandle = ref?.child("goals").child(postData[indexPath.row]).child("uids").child(currentUserId!).child("completed").observe(.value, with: { (DataSnapshot) in
            let completedString = DataSnapshot.value as? String
            
            if (completedString == "true"){
                cell?.accessoryType = UITableViewCell.AccessoryType.checkmark
            }
            else{
                cell?.accessoryType = UITableViewCell.AccessoryType.none
            }
            
        })
        
        return cell!
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
//    {
//        //Set current user ID
//        let currentUserId = Auth.auth().currentUser?.uid
//
//        // Get text for current row
//        let currentCell = tableView.cellForRow(at: indexPath) as! UITableViewCell
//        let cellName = currentCell.textLabel!.text
//
//        // Set value to true
//        ref!.child("goals").child(cellName!).child("uids").child(currentUserId!).setValue(["completed":"true"])
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //Set the firebase reference
        ref = Database.database().reference()
        
        //Set current user ID
        let currentUserId = Auth.auth().currentUser?.uid
        
        //Retrieve posts and listen for changes
        databaseHandle = ref?.child("goals").observe(.childAdded, with: { (snapshot) in
            
            //Code that is executed when a new goal is added
            // Add value from snapshot to postData if uid matches current user
            let goalName = snapshot.key
            for goal in snapshot.children {
                let goalSnap = goal as! DataSnapshot
                if (goalSnap.key == "uids"){
                    for uid in goalSnap.children {
                        let uidSnap = uid as! DataSnapshot
                        if (uidSnap.key == currentUserId){
                            self.postData.append(goalName)
                        }
                    }
                }
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
            self.ref!.child("goals").child(cellName!).child("uids").child(currentUserId!).setValue(["completed":"true"])
            
        }
        complete.backgroundColor = .lightGray
        
        let details = UITableViewRowAction(style: .normal, title: "Details") { action, index in
            print("details button tapped")
        }
        details.backgroundColor = .orange
        
        
        return [complete, details]
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
