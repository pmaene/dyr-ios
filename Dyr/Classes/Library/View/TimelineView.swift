//
//  TimelineView.swift
//  Dyr
//
//  Created by Pieter Maene on 26/04/15.
//  Copyright (c) 2015. All rights reserved.
//

import Foundation
import PureLayout
import UIKit

class TimelineView: UIView {
    lazy var circleView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        
        view.layer.borderColor = UIColor.accent.cgColor
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 8
        
        return view
    }()
    
    lazy var lineView: UIView = {
        let view = UIView(frame: self.frame)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.lightBase
        
        return view
    }()
    
    // MARK: - UIView
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(circleView)
        addSubview(lineView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        lineView.autoAlignAxis(toSuperviewAxis: .vertical)
        lineView.autoSetDimension(.width, toSize: 2)
        lineView.autoMatch(.height, to: .height, of: self)
        
        
        circleView.autoCenterInSuperview()
        circleView.autoSetDimensions(to: CGSize(width: 16, height: 16))
    }
}
