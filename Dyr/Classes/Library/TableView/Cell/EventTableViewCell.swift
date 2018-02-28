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
    
    var event: Event? {
        didSet {
            updateOutlets()
        }
    }
    
    func updateOutlets() {
        if let event = event {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "d/MM/YYYY", options: 0, locale: dateFormatter.locale)
        
            dateLabel.text = dateFormatter.string(from: event.creationTime as Date)
        
            dateFormatter.dateStyle = DateFormatter.Style.none
            dateFormatter.timeStyle = DateFormatter.Style.short
        
            timeLabel.text = dateFormatter.string(from: event.creationTime as Date)
            timeLabel.textColor = UIColor.secondaryText
        
            nameLabel.text = event.user.name
        }
    }
}
