//
//  AssignmentTableViewCell.swift
//  schoology
//
//  Created by Ujjwal Nadhani on 10/7/18.
//  Copyright © 2018 Manoj M. All rights reserved.
//

import UIKit

class AssignmentTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var dueDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.
        // Initialization code
        self.backgroundColor = ScheduleViewController.hexStringToUIColor(hex: "#FCFCFC")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
