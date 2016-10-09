//
//  LoginViewController.swift
//  Dyr
//
//  Created by Pieter Maene on 06/04/15.
//  Copyright (c) 2015. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginFailed: UILabel!
    
    @IBAction func login(_ sender: AnyObject) {
        OAuthClient.sharedClient.accessTokenWithCredentials(username: username.text!, password: password.text!)
    }
    
    func OAuthClientFailed(_ notification: Notification) {
        showLoginFailed()
    }
    
    func presentNavigationController(_ notification: Notification) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! NavigationController

        self.present(navigationController, animated: true, completion: nil)
    }
    
    // TODO: Extend UILabel to set isHidden animated
    private func hideLoginFailed() {
        UIView.transition(
            with: loginFailed,
            duration: 0.5,
            options: .transitionCrossDissolve,
            animations: {
                self.loginFailed.isHidden = true
            },
            completion: { (finished: Bool) -> () in }
        )
    }
    
    private func initLoginFailed() {
        loginFailed.textColor = UIColor.error
    }
    
    // TODO: Extend UILabel to set isHidden animated
    private func showLoginFailed() {
        UIView.transition(
            with: loginFailed,
            duration: 0.5,
            options: .transitionCrossDissolve,
            animations: {
                self.loginFailed.isHidden = false
            },
            completion: { (finished: Bool) -> () in }
        )
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initLoginFailed()
        username.delegate = self
        password.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.OAuthClientFailed(_:)), name: OAuthClient.NotificationNames.failed, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.presentNavigationController(_:)), name: OAuthClient.NotificationNames.receivedAccessToken, object: nil)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        hideLoginFailed()
        return true
    }
}
