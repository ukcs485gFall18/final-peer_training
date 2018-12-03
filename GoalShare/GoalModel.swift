//
//  GoalModel.swift
//  GoalShare
//
//  Created by Seanna Lea LoBue on 12/1/18.
//  Copyright © 2018 Seanna Lea LoBue. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class GoalModel : NSObject {
    var gid : Int
    var goalName : String
    var goal_desc : String
    var complete : String
    
    init(snap: DataSnapshot){
        let goalDict = snap.value as! [String : Any]
        self.gid = goalDict["gid"] as! Int
        self.goalName = goalDict["gname"] as! String
        self.goal_desc = goalDict["goal_des"] as! String
        self.complete = goalDict["completed"] as! String
    }
}
