//
//  NavigationController.swift
//  Dyr
//
//  Created by Pieter Maene on 08/11/14.
//  Copyright (c) 2014. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.barStyle = UIBarStyle.black
        self.navigationBar.barTintColor = UIColor.base
        self.navigationBar.tintColor = UIColor.white
    }
}
