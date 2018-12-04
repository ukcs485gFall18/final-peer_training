//
//  GoalDetailsViewController.swift
//  GoalShare
//
//  Created by Hurst, Conner on 12/2/18.
//  Copyright © 2018 Seanna Lea LoBue. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class GoalDetailsViewController: UIViewController {

    @IBOutlet weak var timeFrameSeg: UISegmentedControl!
    @IBOutlet weak var BarChart: BasicBarChart!
    @IBOutlet weak var GoalName: UILabel!
    @IBOutlet weak var GoalDes: UILabel!
    
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    var sentGoal: GoalModel?
    var barValues: [Int] = [1,1,1,1,1,1,1]
    var currentUserId = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        // ui element settings
        timeFrameSeg.addTarget(self, action: #selector(self.segmentedControlValueChanged), for: .valueChanged)
        timeFrameSeg.tintColor = #colorLiteral(red: 0.5576759543, green: 0.3133929401, blue: 0.4060785278, alpha: 1)
        GoalName.textColor = #colorLiteral(red: 0.5576759543, green: 0.3133929401, blue: 0.4060785278, alpha: 1)
        GoalName.textAlignment = .center
        GoalName.font = UIFont(name: "HelveticaNeue-Bold", size: 30)
        GoalName.text = sentGoal?.goalName
        GoalDes.textColor = #colorLiteral(red: 0.5576759543, green: 0.3133929401, blue: 0.4060785278, alpha: 1)
        GoalDes.textAlignment = .center
        GoalDes.font = UIFont(name: GoalDes.font.fontName, size: 20)
        GoalDes.text = sentGoal?.goal_desc
        
        let dataEntries = self.generateWeekGraph(barValues: barValues)
        self.BarChart.dataEntries = dataEntries
    }
    
    // Function that generates week graph
    func generateWeekGraph(barValues: [Int]) -> [BarEntry] {
        let colors = [#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.5576759543, green: 0.3133929401, blue: 0.4060785278, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)]
        let defaultColor = #colorLiteral(red: 0.5576759543, green: 0.3133929401, blue: 0.4060785278, alpha: 1)
        var result: [BarEntry] = []
        BarChart.barWidth = 40
        BarChart.space = 10
        BarChart.textWidth = 50
        BarChart.isMonth = 0
        var textValue = ""
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/d"
        var date = Date()
        date.addTimeInterval(TimeInterval(-6*24*60*60))
        // Creates 7 bars with values from goal completion for each day over the past week
        for i in 0...6{
            if barValues[i] == 1{
                textValue = "✔️"
            }else{
                textValue = "✖️"
            }
            result.append(BarEntry(color: defaultColor, height: Float(barValues[i]), textValue: textValue, title: formatter.string(from: date)))
            date.addTimeInterval(TimeInterval(24*60*60))
        }
        return result
    }
    
    // Function that generates month graph
    func generateMonthGraph(barValues: [Int]) -> [BarEntry] {
        var useColor = #colorLiteral(red: 0.8392, green: 0.8392, blue: 0.8392, alpha: 1)
        let completeColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        let incompleteColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        var result: [BarEntry] = []
        BarChart.barWidth = 10
        BarChart.space = 1.5
        BarChart.textWidth = 60
        BarChart.isMonth = 1
        
        // get
        let calendar = Calendar.current
        let date = Date()
        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        var dateLabel = ""
        
        // Creates bars for every day of the month with values from goal completion for each month over the past month
        for i in 0...numDays-1{
            if ((i+1) % 5 == 1){
                dateLabel = String(i+1)
            }else{
                dateLabel = ""
            }
            if (i<barValues.count) {
                let value = barValues[i]
                if(value == 1){
                    useColor = completeColor
                }else{
                    useColor = incompleteColor
                }
            } else {
                useColor = #colorLiteral(red: 0.8392, green: 0.8392, blue: 0.8392, alpha: 1)
            }
            result.append(BarEntry(color: useColor, height: 1, textValue: "", title: dateLabel))
        }
        return result
    }
    
    // Function that generates year graph
    func generateYearGraph(barValues: [Int]) -> [BarEntry] {
        let colors = [#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.5576759543, green: 0.3133929401, blue: 0.4060785278, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.5576759543, green: 0.3133929401, blue: 0.4060785278, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)]
        //let defaultColor = #colorLiteral(red: 0.9098, green: 0.651, blue: 0, alpha: 1)
        var result: [BarEntry] = []
        BarChart.barWidth = 20
        BarChart.space = 10
        BarChart.textWidth = 30
        BarChart.isMonth = 0
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
//        var date = Date()
//        date.addTimeInterval(TimeInterval(-6*24*60*60))
        var date = Calendar.current.date(byAdding: .month, value: -12, to: Date())
        // Creates 12 bars with values from goal completion for each month over the past year
        for i in 0...11{
            date = Calendar.current.date(byAdding: .month, value: 1, to: date!)!
            let month = formatter.string(from: date!)
            let barHeight = Float(barValues[i])/31
            result.append(BarEntry(color: colors[i], height: barHeight, textValue: "\(barValues[i])", title: month))
        }
        return result
    }
    
    @objc func segmentedControlValueChanged(segment: UISegmentedControl) {
        if segment.selectedSegmentIndex == 0 {
            self.barValues = [Int](repeating: 0, count: 7)
            databaseHandle = self.ref!.child("goalHistory").child(currentUserId!).child(String(sentGoal!.gid)).observe(.value, with: {(dateSnapshot) in
                // Set the date of 7 days ago in proper format
                let todayDate = Date()
                let date_7 = todayDate.addingTimeInterval(TimeInterval(-7*24*60*60))
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyyMMdd"
                let currentDate_7 = formatter.string(from: date_7)
                // Loop through date logs
                for date in dateSnapshot.children{
                    let dateSnap = date as! DataSnapshot
                    // usedDate starts as today, columns are updated backwards
                    var dateToChange = Date()
                    var usedDate = formatter.string(from: todayDate)
                    var colToUpdate = self.barValues.count - 1
                    // if the log date matches any of the days in the past week, update that column
                    while(usedDate != currentDate_7){
                        if (dateSnap.key == usedDate){
                            self.barValues[colToUpdate] = 1
                        }
                        dateToChange.addTimeInterval(-24*60*60)
                        usedDate = formatter.string(from: dateToChange)
                        colToUpdate = colToUpdate - 1
                    }
                }
                let dataEntries = self.generateWeekGraph(barValues: self.barValues)
                self.BarChart.dataEntries = dataEntries
            })
        }
        if segment.selectedSegmentIndex == 1 {
            print("month button pressed")
            self.barValues = [0,1,1,1,1,0,0,1,0,0,1,0,1,0,1,0,1,0,1]
            //self.barValues = [Int](repeating: 1, count: 31)
            databaseHandle = self.ref!.child("goalHistory").child(currentUserId!).child(String(sentGoal!.gid)).observe(.value, with: {(dateSnapshot) in
                for date in dateSnapshot.children{
                    
                }
                let dataEntries = self.generateMonthGraph(barValues: self.barValues)
                self.BarChart.dataEntries = dataEntries
            })
        }
        if segment.selectedSegmentIndex == 2 {
            print("year button pressed")
            self.barValues = [2,4,4,5,7,8,21,30,12,15,20,5]
            //self.barValues = [Int](repeating: 0, count: 12)
            databaseHandle = self.ref!.child("goalHistory").child(currentUserId!).child(String(sentGoal!.gid)).observe(.value, with: {(dateSnapshot) in
                for date in dateSnapshot.children{

                }
                let dataEntries = self.generateYearGraph(barValues: self.barValues)
                self.BarChart.dataEntries = dataEntries
            })
        }
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
