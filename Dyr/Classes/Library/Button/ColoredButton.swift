//
//  ColoredButton.swift
//  Dyr
//
//  Created by Pieter Maene on 06/04/15.
//  Copyright (c) 2015. All rights reserved.
//

import UIKit

class ColoredButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        setTitleColor(UIColor.base, for: UIControlState())
    }
}
