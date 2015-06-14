//
//  TimelineView.swift
//  Dyr
//
//  Created by Pieter Maene on 26/04/15.
//  Copyright (c) 2015 Student IT vzw. All rights reserved.
//

import Foundation

class TimelineView: UIView {
    lazy var lineView: UIView = {
        let view = UIView(frame: self.frame)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.accentColor()
        
        return view
    }()
    
    lazy var circleView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.whiteColor()
        view.layer.borderColor = UIColor.lightPrimaryColor().CGColor
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 8
        
        return view
    }()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        addSubview(lineView)
        
        addConstraint(NSLayoutConstraint(item: lineView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: lineView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 2))
        addConstraint(NSLayoutConstraint(item: lineView, attribute: .Height, relatedBy: .Equal, toItem: self, attribute: .Height, multiplier: 1, constant: 0))
        
        addSubview(circleView)
        
        addConstraint(NSLayoutConstraint(item: circleView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: circleView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: circleView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 16))
        addConstraint(NSLayoutConstraint(item: circleView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 16))
    }
}