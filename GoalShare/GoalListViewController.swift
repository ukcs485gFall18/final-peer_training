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
    
    var postData = [String]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = postData[indexPath.row]
        
        return cell!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //Set the firebase reference
        ref = Database.database().reference()
        
        // GET CURRENT USER'S ID
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
            //self.postData.append()
        })
    
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
