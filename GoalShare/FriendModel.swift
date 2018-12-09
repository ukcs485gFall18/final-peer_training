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
    var completePercent : Double
    private var _goals : [GoalModel]
    private var totalGoals : Int
    private var completeGoals : Int

    var goals : [GoalModel] {
        get { return _goals}
        set ( goalArray ) { _goals = goalArray }
    }
    
    // Constructor
    init(snap : DataSnapshot){
        self.uid = snap.key
        self.nickName = snap.value as! String
        completePercent = Double()
        _goals = [GoalModel]()
        totalGoals = Int()
        completeGoals = Int()
    }
    
    // functions
    func calculateCompletionRate ()  -> Double {
        let totalGoals = goals.count
        var completeGoals = 0
        var cRate : Double = 0.0
        if(goals.count > 0){
            for goal in goals{
                if goal.complete == "true" {
                    completeGoals += 1
                }
            }
            cRate = round(Double(completeGoals / totalGoals)) * 100
        }
        return cRate
    }
}
