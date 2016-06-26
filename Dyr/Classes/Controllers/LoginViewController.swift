//
//  LoginViewController.swift
//  Dyr
//
//  Created by Pieter Maene on 06/04/15.
//  Copyright (c) 2015. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBAction func login(_ sender: AnyObject) {
        OAuthClient.sharedClient.accessTokenWithCredentials(username: username.text!, password: password.text!)
    }
    
    func presentNavigationController(_ notification: Notification) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! NavigationController

        self.present(navigationController, animated: true, completion: nil)
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default().addObserver(self, selector: #selector(LoginViewController.presentNavigationController(_:)), name: OAuthClientReceivedAccessTokenNotification, object: nil)
    }
}
