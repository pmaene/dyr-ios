//
//  UIColor+Dyr.swift
//  Dyr
//
//  Created by Pieter Maene on 08/11/14.
//  Copyright (c) 2014. All rights reserved.
//

import UIKit

extension UIColor {
    class var base: UIColor {
        get {
            return UIColor(hex: "#607D8B")
        }
    }

    class var lightBase: UIColor {
        get {
            return UIColor(hex: "#CFD8DC")
        }
    }
    
    class var accent: UIColor {
        get {
            return UIColor(hex: "#FF5722")
        }
    }
    
    class var primaryText: UIColor {
        get {
            return UIColor.black
        }
    }
    
    class var error: UIColor {
        get {
            return UIColor(hex: "#F44336")
        }
    }
    
    class var secondaryText: UIColor {
        get {
            return UIColor(hex: "#727272")
        }
    }
}
