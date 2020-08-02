//
//  StudyViewController.swift
//  schoology
//
//  Created by Ujjwal Nadhani on 10/7/18.
//  Copyright © 2018 Manoj M. All rights reserved.
//

import UIKit

class StudyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DataInterfacerVC {
    var dataIntefacer : DataInterfacer?
    var assignments = [Assignment]()
    var totalHeight = 0
    var lastCellHeight = 0
    func handleInit(currentInterfacer: DataInterfacer) {
//        let sampleAssignment = Assignment(context: CoreDataManager.context)
//        sampleAssignment.name = "Reading due(diff: 3, time: 60 min)"
//        var calendar = Calendar(identifier: .gregorian)
//        var dateComponents = DateComponents()
//        dateComponents.day = 15
//        dateComponents.month = 10
//        dateComponents.year = 2018
//        sampleAssignment.dueDate = calendar.date(from: dateComponents)! as NSDate
//        sampleAssignment.period = 1
//        CoreDataManager.saveContext()
//
//        let sampleAssignment2 = Assignment(context: CoreDataManager.context)
//        sampleAssignment2.name = "Lab #4 (diff: 4, time: 30 min)"
//        sampleAssignment2.dueDate = calendar.date(from: dateComponents)! as NSDate
//        sampleAssignment2.period = 6
//        CoreDataManager.saveContext()
        
        dataIntefacer = currentInterfacer
        dataIntefacer?.fetchAssignments()
        let currentDate = Date()
        for item in dataIntefacer!.assignments{
            for assignment in item.value{
                if((!assignment.userCompleted && (assignment.dueDate as Date) > currentDate) && assignments.count <= 4){
                    assignments.append(assignment)
                }else{
//                    assignment.userCompleted = false
//                    CoreDataManager.saveContext()
//                    assignments.append(assignment)
                }
            }
        }
        assignments = assignments.sorted(by: {($0.dueDate as Date) < ($1.dueDate as Date)})
    }
    //0-28
    func updateAssignmentsArray(row: Int){
        assignments[row].userCompleted = true
        CoreDataManager.saveContext()
        assignments.remove(at: row)
        assignments = assignments.sorted(by: {($0.dueDate as Date) < ($1.dueDate as Date)})
        
        table.reloadData()
        
    }
    
    @IBOutlet var heightCons: NSLayoutConstraint!
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet var nextStudySessionLabel: UILabel!
    func handleSections(currentInterfacer: DataInterfacer) {}
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assignments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell") as! AssignmentTableViewCell
        cell.name.text = assignments[indexPath.row].name
        let date : Date = assignments[indexPath.row].dueDate as Date
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        //var tempDate = formatter.string(from: date)
        
        cell.dueDate.text = formatter.string(from: date)
        let border = CALayer()
        border.backgroundColor = colors[(Int(assignments[indexPath.row].period))]
        border.frame = CGRect(x: 13, y: 2.5, width: 3.5, height: 35)
        cell.layer.addSublayer(border)
        cell.selectionStyle = .none
        totalHeight += Int(cell.frame.height)
        lastCellHeight = Int(cell.frame.height)
        return cell
    }
    
    var colors = [UIColor.cyan.cgColor,UIColor.cyan.cgColor,UIColor.cyan.cgColor,UIColor.cyan.cgColor,UIColor.cyan.cgColor,UIColor.cyan.cgColor,UIColor.cyan.cgColor,UIColor.cyan.cgColor]
    override func viewDidLoad() {
        super.viewDidLoad()
        dataIntefacer = DataInterfacer(token: UserDefaults.standard.string(forKey: "token")!, tokenSecret: UserDefaults.standard.string(forKey: "tokenSecret")!, topVC: self)
        colors[1] = ScheduleViewController.hexStringToUIColor(hex: "3BCEAC").cgColor
        colors[5]  = ScheduleViewController.hexStringToUIColor(hex: "F2DC5D").cgColor
        colors[4] = ScheduleViewController.hexStringToUIColor(hex: "3772FF").cgColor
        colors[3]  = ScheduleViewController.hexStringToUIColor(hex: "F2A359").cgColor
        colors[6] = ScheduleViewController.hexStringToUIColor(hex: "FFD23F").cgColor
        colors[2] = ScheduleViewController.hexStringToUIColor(hex: "55DDE0").cgColor
        colors[7] = ScheduleViewController.hexStringToUIColor(hex: "3AB795").cgColor
        
        
        
        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let share = UITableViewRowAction(style: .normal, title: "Mark as Complete") { action, index in
            self.updateAssignmentsArray(row: index.row)
            action.backgroundColor = .red
            print("completed button tapped")
        }
        
        share.backgroundColor = ScheduleViewController.hexStringToUIColor(hex: "3BCEAC")
        
        return [share]
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    @IBOutlet var assignmentsLeft: UILabel!
    override func viewDidAppear(_ animated: Bool) {
        heightCons.constant = CGFloat(totalHeight + lastCellHeight)
        let studyTimes = DataInterfacer.fetchStudyTimes()
        let todaysDate = Date()
        let calendar = Calendar(identifier: .gregorian)
        var weekDay = calendar.component(.weekday, from: todaysDate)
        var done = false
        var i = 0
        let days = ["","Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
        var finalString = ""
        if(weekDay == 7){
            weekDay = 0
        }
        while(!done && i < studyTimes.count){
            let finalDay = Int(studyTimes[i].day)
            if(finalDay > weekDay){
                finalString = days[Int(studyTimes[i].day)]
                done = true
            }
            i += 1
        }
        
        let str = "Next Study Session: \(finalString) at 8 PM."
        let attributedText : NSMutableAttributedString = NSMutableAttributedString(string: str)
        let length = str.count - nextStudySessionLabel.text!.count
        let range = NSRange(location: nextStudySessionLabel.text!.count, length: length)
        attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: range)
        attributedText.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir", size: 17.0) as! UIFont, range: range)
        
        nextStudySessionLabel.attributedText = attributedText
        
        let str2 = "Assignments Left For Today: 2"
        let attributedText2 = NSMutableAttributedString(string: str2)
        let length2 = str2.count - assignmentsLeft.text!.count
        let range2 = NSRange(location: assignmentsLeft.text!.count, length: length2)
        attributedText2.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: range2)
        attributedText2.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir", size: 17.0) as! UIFont, range: range2)
        
        assignmentsLeft.attributedText = attributedText2
        
        
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
      
    }
 

}
