//
//  TimelineView.swift
//  Dyr
//
//  Created by Pieter Maene on 13/11/14.
//  Copyright (c) 2014 Student IT vzw. All rights reserved.
//

import UIKit

class TimelineView: UIView {
    override func drawRect(rect: CGRect) {
        var contextRef: CGContextRef  = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(contextRef, 2.5)
        CGContextSetStrokeColorWithColor(contextRef, UIColor.defaultInterfaceColor().CGColor)
        var center: CGRect = CGRectMake(self.center.x, self.center.y, 5.0, 5.0)
        
        CGContextStrokeEllipseInRect(contextRef, center)
    }
}
