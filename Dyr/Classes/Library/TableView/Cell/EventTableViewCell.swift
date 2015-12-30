//
//  ActivityTableViewCell.swift
//  Dyr
//
//  Created by Pieter Maene on 12/11/14.
//  Copyright (c) 2014. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    func updateOutlets(event: Event) {
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = NSDateFormatter.dateFormatFromTemplate("d/MM/YYYY", options: 0, locale: dateFormatter.locale)
        
        dateLabel.text = dateFormatter.stringFromDate(event.creationTime)
        
        dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        timeLabel.text = dateFormatter.stringFromDate(event.creationTime)
        timeLabel.textColor = UIColor.secondaryTextColor()
        
        nameLabel.text = event.user.name
    }
}
