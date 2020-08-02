//
//  AuthenticatedViewController.swift
//  schoology
//
//  Created by Ujjwal Nadhani on 9/15/18.
//  Copyright © 2018 Manoj M. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreData
class AuthenticatedViewController: UIViewController, DataInterfacerVC {

    
    func handleInit(currentInterfacer : DataInterfacer) {
        print("init handled")
        interfacer = currentInterfacer
        interfacer!.retriveSections(topVC: self)
    }
    func handleSections(currentInterfacer : DataInterfacer){
        for section in currentInterfacer.sections{
            print(section.preferredName)
        }
        sections = currentInterfacer.sections
        interfacer?.fetchClasses()
        DispatchQueue.main.async {
            self.coursesLabel.text = self.sections[self.currentCourseId].preferredName
        }
        
    }
    var sections = [Section]()
    var interfacer : DataInterfacer?
    @IBOutlet weak var coursesLabel: UILabel!
    
    @IBOutlet weak var difficulySlider: UISlider!
    @IBOutlet weak var difficultySliderLabel: UILabel!
    
    @IBOutlet weak var homeworkTimeSlider: UISlider!
    @IBOutlet weak var homeworkTimeSliderLabel: UILabel!
    
    @IBAction func difficultySliderChanged(_ sender: UISlider) {
        let roundedValue = round(sender.value / 1) * 1
        sender.value = roundedValue
        difficultySliderLabel.text = "\(Int(roundedValue))"
    }
    
    @IBAction func homeworkTimeSliderChanged(_ sender: UISlider) {
        
        let roundedValue = round(sender.value / 0.5) * 0.5
        sender.value = roundedValue
        homeworkTimeSliderLabel.text = "\(Int(roundedValue * 60)) min"
    }
    var currentCourseId = 0
    override func viewDidLoad() {
        super.viewDidLoad()



        // Do any additional setup after loading the view.
    }
    func updateClassesWithUserInputs() {
            interfacer!.getRelevantAssignments(id: currentCourseId)
            sections[currentCourseId].difficulty = Int16(difficulySlider.value)
            sections[currentCourseId].averageHomeworkTime = Int16(homeworkTimeSlider.value)
            CoreDataManager.saveContext()
            difficulySlider.value = 0.0
            homeworkTimeSlider.value = 0.0
            difficultySliderLabel.text = "1"
            homeworkTimeSliderLabel.text = "0 min"
            if currentCourseId < (sections.count - 1){
                currentCourseId = currentCourseId + 1
            }else{
                print("DONE DONE DONE DONE DONE")
                
                interfacer?.fetchAssignments()
                for assignmentx in interfacer!.assignments{
                    print(assignmentx.value)
                }
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "setupDone", sender: self)
                }
            }
            coursesLabel.text = sections[currentCourseId].preferredName
    }

    @IBAction func nextCourse(_ sender: UIButton) {
        updateClassesWithUserInputs()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        if let exists = UserDefaults.standard.string(forKey: "token"){
            interfacer = DataInterfacer(token: exists, tokenSecret: UserDefaults.standard.string(forKey: "tokenSecret")!, topVC: self as DataInterfacerVC)
        }else{
            //get id
        }
        
        

    }

    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
extension UIColor {
    public convenience init?(hexString: String) {
        let r, g, b, a: CGFloat
        
        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = String(hexString[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
}
