//
//  OAuthClient.swift
//  Dyr
//
//  Created by Pieter Maene on 12/04/15.
//  Copyright (c) 2015. All rights reserved.
//

import Alamofire
import Foundation

let OAuthClientReceivedAccessTokenNotification = NSNotification.Name(rawValue: "OAuthReceivedAccessTokenNotification")
let OAuthClientRefreshedAccessTokenNotification = NSNotification.Name(rawValue: "OAuthRefreshedAccessTokenNotification")
let OAuthClientFailedNotification = NSNotification.Name(rawValue: "OAuthFailedNotification")

class OAuthClient {
    static let sharedClient = OAuthClient()
    var accessToken: OAuthAccessToken? {
        get {
            if let accessToken = OAuthAccessToken.unarchive() {
                if accessToken.hasExpired() {
                    refreshAccessToken(accessToken)
                    return nil
                }
                
                return accessToken
            } else {
                NotificationCenter.default.post(name: OAuthClientFailedNotification, object: nil)
                return nil
            }
        }
    }
    
    func refreshAccessToken(_ accessToken: OAuthAccessToken) {
        if accessToken.refreshing {
            return
        }
        
        accessToken.refreshing = true
            
        Alamofire.request(OAuthRouter.accessTokenFromRefreshToken(refreshToken: accessToken.refreshToken))
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let json = response.result.value as? [String: Any] {
                        if let error = json["error"] as? String, error.isEmpty {
                            if let accessToken = OAuthAccessToken(json: json) {
                                accessToken.archive()
                            }
                                
                            NotificationCenter.default.post(name: OAuthClientRefreshedAccessTokenNotification, object: self.accessToken)
                        } else {
                            self.accessToken?.remove()
                            NotificationCenter.default.post(name: OAuthClientFailedNotification, object: nil)
                        }
                    }
                    
                case .failure:
                    NotificationCenter.default.post(name: OAuthClientFailedNotification, object: self.accessToken)
                }
            }
    }
}
