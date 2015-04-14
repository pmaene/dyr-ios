//
//  ActivityTableViewCell.swift
//  Dyr
//
//  Created by Pieter Maene on 12/11/14.
//  Copyright (c) 2014 Student IT vzw. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    func updateOutlets(event: Event) {
        var dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        self.dateLabel.text = dateFormatter.stringFromDate(event.creationTime)
        self.timeLabel.text = dateFormatter.stringFromDate(event.creationTime)
        self.nameLabel.text = event.person.name
    }
}
