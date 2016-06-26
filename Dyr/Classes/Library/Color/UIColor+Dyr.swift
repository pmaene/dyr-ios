//
//  UIColor+Dyr.swift
//  Dyr
//
//  Created by Pieter Maene on 08/11/14.
//  Copyright (c) 2014. All rights reserved.
//

import UIKit

extension UIColor {
    class func base() -> UIColor {
        return UIColor(hex: "#607D8B")
    }
    
    class func lightBase() -> UIColor {
        return UIColor(hex: "#CFD8DC")
    }
    
    class func accent() -> UIColor {
        return UIColor(hex: "#FF5722")
    }
    
    class func primaryText() -> UIColor {
        return UIColor.black()
    }
    
    class func secondaryText() -> UIColor {
        return UIColor(hex: "#727272")
    }
}
