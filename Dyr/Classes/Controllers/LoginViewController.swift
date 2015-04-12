//
//  LoginViewController.swift
//  Dyr
//
//  Created by Pieter Maene on 06/04/15.
//  Copyright (c) 2015 Student IT vzw. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBAction func login(sender: AnyObject) {
        OAuthClient.sharedClient.accessTokenWithCredentials(username.text, password: password.text)
    }
}