//
//  GroupDetailsSegue.swift
//  GoalShare
//
//  Created by Willis, Bryan A on 12/9/18.
//  Copyright © 2018 Seanna Lea LoBue. All rights reserved.
//

import UIKit

class GroupDetailsSegue: UIStoryboardSegue {
    override func perform() {
        let source = self.source as! FriendsListTableViewController
        if(source.valueToPass != "None" && source.valueToPass != "nil" && source.valueToPass != nil) {
            scale()
        }
    }
    func scale() {
        let toViewController = self.destination
        let fromViewController = self.source
        
        let containerView = fromViewController.view.superview
        let originalCenter = fromViewController.view.center
        
        toViewController.view.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
        toViewController.view.center = originalCenter
        
        containerView?.addSubview(toViewController.view)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            toViewController.view.transform = CGAffineTransform.identity
        }, completion: { success in
            fromViewController.present(toViewController, animated: false, completion: nil)
        })
    }
}
