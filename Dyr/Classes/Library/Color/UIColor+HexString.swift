//
//  UIColor+HexString.swift
//  Dyr
//
//  Created by Pieter Maene on 08/11/14.
//  Copyright (c) 2014. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 1
        
        var intValue: CUnsignedInt = 0x0
        scanner.scanHexInt32(&intValue)
        
        self.init(red: CGFloat((intValue & 0xFF0000) >> 16)/255.0, green: CGFloat((intValue & 0xFF00) >> 8)/255.0, blue: CGFloat((intValue & 0xFF))/255.0, alpha: 1.0)
    }
}
