//
//  ScheduleViewController.swift
//  schoology
//
//  Created by Ujjwal Nadhani on 10/4/18.
//  Copyright © 2018 Manoj M. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DataInterfacerVC {
    var sections = [Section]()
    func handleInit(currentInterfacer: DataInterfacer) {
        interfacer = currentInterfacer
        interfacer!.fetchClasses()
        //print(sections)
        sections = interfacer!.sections
        print(sections)
        transformToScheldule()
    }
    var schedule = ["","","","","",""]
    var timing = ["8:20 ", "9:50 ","10:05","11:35","12:15","1:55 "]
    var colors = [UIColor.red.cgColor, UIColor.red.cgColor, UIColor.red.cgColor, UIColor.red.cgColor, UIColor.red.cgColor, UIColor.red.cgColor]
    func transformToScheldule(){
        schedule[0] = sections[1].preferredName
        schedule[1] = "Brunch"
        schedule[2] = sections[3].preferredName
        schedule[3] = "Lunch"
        schedule[4] = sections[5].preferredName
        schedule[5] = "Tutorial/Advisory"
        //540D6E - purple
        //3772FF - blue
        //FFD23F - golden yellow
        //3BCEAC - turquiose
        //0EAD69 - green
        let lightGray = UIColor.lightGray.withAlphaComponent(0.75)
        
        colors[0] = ScheduleViewController.hexStringToUIColor(hex: "55DDE0").cgColor
        colors[1]  = lightGray.cgColor
        colors[2] = ScheduleViewController.hexStringToUIColor(hex: "3772FF").cgColor
        colors[3]  = lightGray.cgColor
        colors[4] = ScheduleViewController.hexStringToUIColor(hex: "FFD23F").cgColor
        colors[5] = lightGray.cgColor
        
        //colors[0] = UIColor.
    }
    
    @IBAction func nextDay(_ sender: Any) {
        day.text = "Tomorrow"
        schedule[0] = sections[0].preferredName
        schedule[1] = "Brunch"
        schedule[2] = sections[2].preferredName
        schedule[3] = "Lunch"
        schedule[4] = sections[4].preferredName
        schedule[5] = sections[6].preferredName
        
        let lightGray = UIColor.lightGray.withAlphaComponent(0.75)
        colors[0] = ScheduleViewController.hexStringToUIColor(hex: "3BCEAC").cgColor
        colors[1]  = lightGray.cgColor
        colors[2] = ScheduleViewController.hexStringToUIColor(hex: "F2A359").cgColor
        colors[3]  = lightGray.cgColor
        colors[4] = ScheduleViewController.hexStringToUIColor(hex: "F2DC5D").cgColor
        colors[5] = ScheduleViewController.hexStringToUIColor(hex: "3AB795").cgColor
        table.reloadData()
    }
    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    func handleSections(currentInterfacer: DataInterfacer) {}
    
    var interfacer : DataInterfacer?
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet var day: UILabel!
    @IBOutlet var nextButton: UIButton!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedule.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell") as! ScheduleTableViewCell
        cell.classLabel.text = schedule[indexPath.row]
        cell.timeLabel.text = timing[indexPath.row]
        let border = CALayer()
        border.backgroundColor = colors[indexPath.row]
        border.frame = CGRect(x: 13, y: 2.5, width: 3.5, height: 35)
        cell.containerView.layer.addSublayer(border)
        cell.selectionStyle = .none
        return cell
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print("here")
        if (UserDefaults.standard.string(forKey: "userId") != nil){
            interfacer = DataInterfacer(token: UserDefaults.standard.string(forKey: "token")!, tokenSecret: UserDefaults.standard.string(forKey: "tokenSecret")!, topVC: self)
        }
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {

        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView()
        table.separatorStyle = .none
        table.backgroundColor = ScheduleViewController.hexStringToUIColor(hex: "#FCFCFC")
        nextButton.layer.borderColor = UIColor.black.cgColor
    }
    override func viewDidAppear(_ animated: Bool) {
        print("did Appear")
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
