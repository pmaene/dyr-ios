//
//  Constants.swift
//  Dyr
//
//  Created by Pieter Maene on 15/11/14.
//  Copyright (c) 2014 Student IT vzw. All rights reserved.
//

import Foundation

class Constants {
    let apiBaseUrl: String = {
        let constantsDictionary: NSDictionary = NSDictionary(contentsOfFile: "Constants.plist")!
        return constantsDictionary.objectForKey("APIBaseURL") as String
    }()
    
    let apiClientID: String = {
        let constantsDictionary: NSDictionary = NSDictionary(contentsOfFile: "Constants.plist")!
        return constantsDictionary.objectForKey("APIClientID") as String
    }()
}
