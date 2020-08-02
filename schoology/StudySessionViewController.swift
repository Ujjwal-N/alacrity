//
//  StudySessionViewController.swift
//  schoology
//
//  Created by Ujjwal Nadhani on 10/12/18.
//  Copyright © 2018 Manoj M. All rights reserved.
//

import UIKit
import UICircularProgressRing

class StudySessionViewController: UIViewController {

    @IBOutlet var progressBar: UICircularProgressRing!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var assignmentLabel: UILabel!
    var assignmentText = "Assignment: "
    override func viewDidLoad() {
        super.viewDidLoad()
        assignmentLabel.text = "Assignment: Reading"
        progressBar.maxValue = 1500
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        timeLabel.text = "25:00"
    }
    @IBAction func startTimer(_ sender: UIButton) {
        var runCount = -1
        sender.titleLabel?.text = "Pause Timer"
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            //print("Timer fired!")
            runCount += 1
            self.progressBar.value = CGFloat(runCount)
            
            if runCount == 1500 {
                timer.invalidate()
            }else{
                let minuteCount = 24 - (runCount / 60)
                let secondCount = 59 - (runCount % 60)
                self.timeLabel.text = "\(minuteCount):\(secondCount)"
            }
            
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
