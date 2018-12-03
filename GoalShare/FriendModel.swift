//
//  FriendModel.swift
//  GoalShare
//
//  Created by Seanna Lea LoBue on 12/1/18.
//  Copyright © 2018 Seanna Lea LoBue. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class FriendModel : NSObject {
    var uid : String = ""
    var nickName : String = ""
    private var _goals : [GoalModel]
    private var _completePercent : Double
    private var totalGoals = Int()
    private var completeGoals = Int()
    
    var goals : [GoalModel] {
        get { return _goals}
        set ( goalArray ) { _goals = goalArray }
    }
    
    var completeRate : Double {
        get { return _completePercent }
        set {
            if(_goals.count > 0){
                totalGoals = 0
                completeGoals = 0
                for goal in _goals{
                    totalGoals += 1
                    if goal.complete == "true" {
                        completeGoals += 1
                    }
                }
               _completePercent = round(Double(completeGoals / totalGoals)) * 100
            }else{
                _completePercent = 0.00
            }
        }
    }

    // Constructor
    init(snap : DataSnapshot){
        self.uid = snap.key
        self.nickName = snap.value as! String
        _goals = [GoalModel]()
        _completePercent = Double()
    }
}
