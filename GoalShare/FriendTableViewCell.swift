//
//  FriendTableViewCell.swift
//  GoalShare
//
//  Created by Seanna Lea LoBue on 12/7/18.
//  Copyright © 2018 Seanna Lea LoBue. All rights reserved.
//

import UIKit
import Firebase

class FriendTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var msgButton: UIButton!
    @IBOutlet weak var friendLabel : UILabel!
    @IBOutlet weak var friendDetailLabel : UILabel!
    @IBOutlet weak var friendIcon : UIImageView!
    
    var dbref : DatabaseReference!
    var userName = ""
    var fname = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
