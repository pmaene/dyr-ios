//
//  Constants.swift
//  Dyr
//
//  Created by Pieter Maene on 15/11/14.
//  Copyright (c) 2014. All rights reserved.
//

import Foundation

class Constants {    
    class func value(forKey key: String) -> String {
        let constantsPath = Bundle.main().pathForResource("Constants", ofType: "plist")!
        let constantsDictionary = NSDictionary(contentsOfFile: constantsPath)!
        
        return constantsDictionary.object(forKey: key) as! String
    }
}
