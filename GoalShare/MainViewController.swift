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
    
    // setting datasource for summary
    var friendData = [String]()
    var goalData = [String]()
    let sections = ["Friends",
                    "My Goals"]
    let items = [[String](),
                 [String]()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        summaryTableView.delegate = self
        summaryTableView.dataSource = self
        
        // build reference to Firebase
        dbref = Database.database().reference()
        friendHandle = dbref?.child("friends").observe(.childChanged, with: { (snapshot) in
            let name = snapshot.key
            for friend in snapshot.children{
                let friendSnap = friend as! DataSnapshot
                if(friendSnap.key == "uids"){
                    for uid in friendSnap.children{
                        let uidSnap = uid as! DataSnapshot
                        if(uidSnap.key == self.currentUser){
                            self.friendData.append(name)
                        }
                    }
                }
            }
            self.summaryTableView.reloadData()
        })
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let maxRows = 5
        if items[section].count > 5{
            return maxRows
        }else{
            return items[section].count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = summaryTableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = items[indexPath.section][indexPath.row]
        
        return cell!
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
}
