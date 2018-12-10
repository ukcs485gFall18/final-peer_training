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
    var barValues: [Int] = [Int](repeating: 0, count: 7)
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
        
        getWeekData()
    }
    
    // Function that generates week graph
    func generateWeekGraph(barValues: [Int]) -> [BarEntry] {
        var completedColor = #colorLiteral(red: 0.3869009155, green: 0.696799651, blue: 0.3262433093, alpha: 0.9021476506)
        let incompleteColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
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
                completedColor = #colorLiteral(red: 0.3869009155, green: 0.696799651, blue: 0.3262433093, alpha: 0.9021476506)
            }else{
                textValue = "✖️"
                completedColor = incompleteColor
            }
            result.append(BarEntry(color: completedColor, height: 1, textValue: textValue, title: formatter.string(from: date)))
            date.addTimeInterval(TimeInterval(24*60*60))
        }
        return result
    }
    
    // Function that generates month graph
    func generateMonthGraph(barValues: [Int]) -> [BarEntry] {
        var useColor = #colorLiteral(red: 0.8392, green: 0.8392, blue: 0.8392, alpha: 1)
        let completeColor = #colorLiteral(red: 0.3869009155, green: 0.696799651, blue: 0.3262433093, alpha: 0.9021476506)
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
        let colors = [#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1),#colorLiteral(red: 0.7189426104, green: 0.71675867, blue: 0.27614689, alpha: 0.9021476506),#colorLiteral(red: 0.21545305, green: 0.4786607049, blue: 0.5639418172, alpha: 0.9021476506),#colorLiteral(red: 0.3869009155, green: 0.696799651, blue: 0.3262433093, alpha: 0.9021476506),#colorLiteral(red: 0.3182998379, green: 0.3019897466, blue: 0.4855987017, alpha: 0.9021476506),#colorLiteral(red: 0.696799651, green: 0.04511301659, blue: 0.0009451018385, alpha: 0.9021476506)]
        var useColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
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
        for i in 0...(self.barValues.count-1){
            date = Calendar.current.date(byAdding: .month, value: 1, to: date!)!
            let month = formatter.string(from: date!)
            let barHeight = Float(barValues[i])/31
            if (barValues[i] >= 20){
                useColor = colors[3]
            } else if (barValues[i] >= 10){
                useColor = colors[2]
            } else if (barValues[i] > 0){
                useColor = colors[1]
            } else {
                useColor = colors[0]
            }
            result.append(BarEntry(color: useColor, height: barHeight, textValue: "\(barValues[i])", title: month))
        }
        return result
    }
    
    // Controls what happens when segmented control is pressed
    @objc func segmentedControlValueChanged(segment: UISegmentedControl) {
        if segment.selectedSegmentIndex == 0 {
            self.barValues = [Int](repeating: 0, count: 7)
            getWeekData()
        }
        if segment.selectedSegmentIndex == 1 {
            let calendar = Calendar.current
            let todayDate = Date()
            let numDays = calendar.component(.day, from: todayDate)
            self.barValues = [Int](repeating: 0, count: numDays)
            getMonthData(today: todayDate)
        }
        if segment.selectedSegmentIndex == 2 {
            self.barValues = [Int](repeating: 0, count: 12)
            getYearData()
        }
    }
    
    // gets goal completion data over the past week and passes into graphing function
    func getWeekData(){
        databaseHandle = self.ref!.child("goalHistory").child(currentUserId!).child(String(sentGoal!.gid)).observe(.value, with: {(dateSnapshot) in
            // Set the date of 6 days ago in proper format
            let todayDate = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMdd"
            // Loop through date logs
            for date in dateSnapshot.children{
                let dateSnap = date as! DataSnapshot
                // usedDate starts as today, columns are updated backwards
                var dateToChange = Date()
                var usedDate = formatter.string(from: todayDate)
                // if the log date matches any of the days in the past week, update that column
                for day in (0...(self.barValues.count-1)).reversed(){
                    if (dateSnap.key == usedDate){
                        self.barValues[day] = 1
                    }
                    dateToChange.addTimeInterval(-24*60*60)
                    usedDate = formatter.string(from: dateToChange)
                }
            }
            let dataEntries = self.generateWeekGraph(barValues: self.barValues)
            self.BarChart.dataEntries = dataEntries
        })
    }
    
    // gets goal completion data over the past month and passes into graphing function
    func getMonthData(today: Date){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        databaseHandle = self.ref!.child("goalHistory").child(currentUserId!).child(String(sentGoal!.gid)).observe(.value, with: {(dateSnapshot) in
            for date in dateSnapshot.children{
                let dateSnap = date as! DataSnapshot
                var dateToChange = Date()
                var usedDate = formatter.string(from: today)
                //var colToUpdate = self.barValues.count - 1
                for day in (0...(self.barValues.count - 1)).reversed() {
                    if (dateSnap.key == usedDate) {
                        self.barValues[day] = 1
                    }
                    dateToChange.addTimeInterval(-24*60*60)
                    usedDate = formatter.string(from: dateToChange)
                }
            }
            let dataEntries = self.generateMonthGraph(barValues: self.barValues)
            self.BarChart.dataEntries = dataEntries
        })
    }
    
    func getYearData(){
        let todayDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMM"
        databaseHandle = self.ref!.child("goalHistory").child(currentUserId!).child(String(sentGoal!.gid)).observe(.value, with: {(dateSnapshot) in
            for date in dateSnapshot.children{
                let dateSnap = date as! DataSnapshot
                var dateToChange = Date()
                var usedDate = formatter.string(from: todayDate)
                for day in (0...(self.barValues.count-1)).reversed(){
                    let logDate = dateSnap.key
                    let removeDays = logDate.index(logDate.endIndex, offsetBy: -2)
                    let logYearMonth = logDate.substring(to: removeDays)
                    if(logYearMonth == usedDate){
                        self.barValues[day] += 1
                    }
                    dateToChange = Calendar.current.date(byAdding: .month, value: -1, to: dateToChange)!
                    usedDate = formatter.string(from: dateToChange)
                }
            }
            self.barValues = [2,4,4,5,7,8,21,30,12,15,20,5]
            let dataEntries = self.generateYearGraph(barValues: self.barValues)
            self.BarChart.dataEntries = dataEntries
        })
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
