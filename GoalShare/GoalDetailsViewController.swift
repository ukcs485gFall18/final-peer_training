//
//  GoalDetailsViewController.swift
//  GoalShare
//
//  Created by Hurst, Conner on 12/2/18.
//  Copyright © 2018 Seanna Lea LoBue. All rights reserved.
//

import UIKit

class GoalDetailsViewController: UIViewController {

    @IBOutlet weak var timeFrameSeg: UISegmentedControl!
    @IBOutlet weak var BarChart: BasicBarChart!
    
    var sentgid: Int?
    
    // bar values
    var barValues: [Int] = [1,0,1,1,1,0,1]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(sentgid)
        timeFrameSeg.tintColor = #colorLiteral(red: 0.5576759543, green: 0.3133929401, blue: 0.4060785278, alpha: 1)
        
        let dataEntries = self.generateDataEntries(barValues: barValues)
        self.BarChart.dataEntries = dataEntries
    }
    
    // Function that generates graph
    func generateDataEntries(barValues: [Int]) -> [BarEntry] {
        let colors = [#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)]
        var result: [BarEntry] = []
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMd"
        var date = Date()
        date.addTimeInterval(TimeInterval(-6*24*60*60))
        // Creates 7 bars with values from workoutNums for each day over the past week
        for i in 0...6{
            print(barValues[i])
            result.append(BarEntry(color: colors[i], height: Float(barValues[i])/10, textValue: "\(barValues[i])", title: formatter.string(from: date)))
            date.addTimeInterval(TimeInterval(24*60*60))
        }
        return result
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
