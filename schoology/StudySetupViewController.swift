//
//  StudySetupViewController.swift
//  schoology
//
//  Created by Ujjwal Nadhani on 10/8/18.
//  Copyright © 2018 Manoj M. All rights reserved.
//

import UIKit

class StudySetupViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    let daysArray = ["Sundays","Mondays","Tuesdays","Wednesdays","Thursdays","Fridays","Saturdays"]
    var fromArray = [String]()
    var toArray = [String]()
    var originalArray = [String]()
    var startIndex = 0
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0{
            return daysArray.count
        }else if component == 1{
            return fromArray.count
        }
        return toArray.count
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "Avenir", size: 19)
            pickerLabel?.textAlignment = .center
        }
        if component == 0{
            pickerLabel?.text = daysArray[row]
        }else if component == 1{
            pickerLabel?.text = fromArray[row]
        }else{
            pickerLabel?.text = toArray[row]
        }
        pickerLabel?.textColor = UIColor.black
        
        return pickerLabel!
    }
    func populateTimes(){
        if fromArray.isEmpty{
            fromArray.removeAll()
            toArray.removeAll()
            fromArray.append("12:00 PM")
            fromArray.append("12:30 PM")
            toArray.append("12:00 PM")
            toArray.append("12:30 PM")
            for i in 2...23{
                if (i % 2 == 0){
                    toArray.append("\(i/2):00 PM")
                    fromArray.append("\(i/2):00 PM")
                }else{
                    toArray.append("\((i - 1)/2):30 PM")
                    fromArray.append("\((i - 1)/2):30 PM")
                }
            }
            originalArray = toArray
            toArray.removeAll()
            for i in (startIndex + 1)...23{
                if (i % 2 == 0){
                    toArray.append("\(i/2):00 PM")
                }else{
                    toArray.append("\((i - 1)/2):30 PM")
                }
            }
        }else{
            toArray.removeAll()
            for i in (startIndex + 1)...23{
                if (i % 2 == 0){
                    toArray.append("\(i/2):00 PM")
                }else{
                    toArray.append("\((i - 1)/2):30 PM")
                }
            }
        }

    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 1{
            startIndex = row
            populateTimes()
            pickerView.reloadComponent(2)
            pickerView.selectRow(0, inComponent: 2, animated: false)
        }
    }
    @IBOutlet weak var timingsLabel: UILabel!
    @IBOutlet var timePicker: UIPickerView!
    
    @IBOutlet var addTimeButton: UIButton!
    
    @IBOutlet var done: UIButton!
    @IBAction func addTime(_ sender: Any) {
        let day = daysArray[timePicker.selectedRow(inComponent: 0)]
        let from = fromArray[timePicker.selectedRow(inComponent: 1)]
        print(startIndex)
        print(timePicker.selectedRow(inComponent: 2))
        let to = originalArray[timePicker.selectedRow(inComponent: 2) + startIndex + 1]
        
        if let currentText = timingsLabel.text{
            timingsLabel.text = currentText + "\n" + "\(day), between \(from) and \(to)"
        }else{
            timingsLabel.text = "\(day), between \(from) and \(to)"
        }
        DataInterfacer.saveStudyTimes(day: (timePicker.selectedRow(inComponent: 0) + 1), startTime: timePicker.selectedRow(inComponent: 1), endTime: (timePicker.selectedRow(inComponent: 2) + startIndex + 1))
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        startIndex = 7
        populateTimes()
        DataInterfacer.deleteStudyTimes()
        let studyTimes = DataInterfacer.fetchStudyTimes()
        for time in studyTimes{
            print(time.day)
        }
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        timingsLabel.text = ""
        timePicker.delegate = self
        timePicker.dataSource = self
        timePicker.selectRow(7, inComponent: 1, animated: false)
        timePicker.selectRow(0, inComponent: 2, animated: false)
        addTimeButton.layer.borderColor = UIColor.clear.cgColor
        done.layer.borderColor = UIColor.clear.cgColor
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

