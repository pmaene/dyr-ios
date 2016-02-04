//
//  UIColor+Dyr.swift
//  Dyr
//
//  Created by Pieter Maene on 08/11/14.
//  Copyright (c) 2014. All rights reserved.
//

import UIKit

extension UIColor {
    class func baseColor() -> UIColor {
        return UIColor(hex: "#607D8B")
    }
    
    class func lightBaseColor() -> UIColor {
        return UIColor(hex: "#CFD8DC")
    }
    
    class func accentColor() -> UIColor {
        return UIColor(hex: "#FF5722")
    }
    
    class func primaryTextColor() -> UIColor {
        return UIColor.blackColor()
    }
    
    class func secondaryTextColor() -> UIColor {
        return UIColor(hex: "#727272")
    }
}
