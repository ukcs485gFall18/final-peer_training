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
    
    var goals : [GoalModel] {
        get { return _goals}
        set { _goals = [GoalModel]() }
    }

    init(snap : DataSnapshot){
        self.uid = snap.key
        self.nickName = snap.value as! String
        _goals = [GoalModel]()
    }
}
