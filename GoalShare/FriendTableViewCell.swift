//
//  FriendTableViewCell.swift
//  GoalShare
//
//  Created by Seanna Lea LoBue on 12/7/18.
//  Copyright © 2018 Seanna Lea LoBue. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell {

    @IBOutlet weak var msgButton: UIButton!
    @IBOutlet weak var friendLabel : UILabel!
    @IBOutlet weak var friendDetailLabel : UILabel!
    @IBOutlet weak var friendIcon : UIImageView!
    
    // create alert to write notification to db
    @IBAction func msgFriend(_ sender: Any){
        
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
