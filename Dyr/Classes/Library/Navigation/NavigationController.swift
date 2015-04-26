//
//  DyrNavigationController.swift
//  Dyr
//
//  Created by Pieter Maene on 08/11/14.
//  Copyright (c) 2014 Student IT vzw. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.barStyle = UIBarStyle.Black
        self.navigationBar.barTintColor = UIColor.primaryColor()
        self.navigationBar.tintColor = UIColor.whiteColor()
    }
}
