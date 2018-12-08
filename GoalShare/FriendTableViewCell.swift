//
//  FriendTableViewCell.swift
//  GoalShare
//
//  Created by Seanna Lea LoBue on 12/7/18.
//  Copyright © 2018 Seanna Lea LoBue. All rights reserved.
//

import UIKit
import Firebase

class FriendTableViewCell: UITableViewCell {

    @IBOutlet weak var msgButton: UIButton!
    @IBOutlet weak var friendLabel : UILabel!
    @IBOutlet weak var friendDetailLabel : UILabel!
    @IBOutlet weak var friendIcon : UIImageView!
    
    var dbref : DatabaseReference!
    var userName = ""
    var fuid = ""
    var fname = ""
    // create alert to write notification to db
    @IBAction func msgFriend(_ sender: UIButton){
        // get information for logged in user
        guard let currentUser = Auth.auth().currentUser?.uid else{
            print("No authenticated user found. Please relogin.")
            return
        }
        _ = dbref?.child("users").child(currentUser).observe(.value, with: { (snapshot) in
            for snap in snapshot.children{
                let userSnap = snap as! DataSnapshot
                let userDict = userSnap.value as! [String: Any]
                self.userName = userDict["uname"] as! String
            }
        })
        
        // build message sender information from button
        _ = dbref?.child("users").child(sender.currentTitle!).observe(.value, with: { (snapshot) in
            for snap in snapshot.children{
                let friendSnap = snap as! DataSnapshot
                let friendDict = friendSnap.value as! [String : Any]
                self.fuid = friendDict["uid"] as! String
                self.fname = friendDict["uname"] as! String
            }
        })
        
        // set message date
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        let currentDate = formatter.string(from: date)
        
        let actionTitle = "Message to \(fname)"

        // create controller with additional text field
            let message = UIAlertController(title: "", message: "Send Message to \(userName)", preferredStyle: UIAlertController.Style.alert)
            message.addTextField(configurationHandler: { (textField) in
                textField.placeholder = "Message to \(self.fname)"
                textField.text = "Keep up the good work!"
            })
            
            let messageAction: UIAlertAction = UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default) { (alertAction) -> Void in
                let message = message.textFields![0].text!

                self.dbref.child("notifications").child(currentUser).child(self.fuid).child(currentDate).setValue(["nid": currentDate, "fname": self.fname, "message": message, "isRead":false])
            }
            
            message.addAction(messageAction)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
