//
//  ScheduleTableViewCell.swift
//  schoology
//
//  Created by Ujjwal Nadhani on 9/29/18.
//  Copyright © 2018 Manoj M. All rights reserved.
//

import UIKit

class ScheduleTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = ScheduleViewController.hexStringToUIColor(hex: "#FCFCFC")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
