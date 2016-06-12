//
//  OAuthClient.swift
//  Dyr
//
//  Created by Pieter Maene on 12/04/15.
//  Copyright (c) 2015. All rights reserved.
//

import Alamofire
import Foundation

let OAuthClientReceivedAccessTokenNotification: String = "OAuthReceivedAccessTokenNotification"
let OAuthClientRefreshedAccessTokenNotification: String = "OAuthRefreshedAccessTokenNotification"
let OAuthClientFailedNotification: String = "OAuthFailedNotification"

class OAuthClient {
    static let sharedClient = OAuthClient()
    var accessToken: OAuthAccessToken? {
        get {
            if let accessToken = OAuthAccessToken() {
                if !accessToken.hasExpired() {
                    return accessToken
                }
            }
            
            return nil
        }
    }
    
    func refreshAccessToken() {
        Alamofire.request(OAuthRouter.AccessTokenFromRefreshToken(refreshToken: self.accessToken!.refreshToken))
            .responseSwiftyJSON({(_, _, json, error) in
                if error == nil {
                    if json["error"].string == nil {
                        if let accessToken = OAuthAccessToken(json: json) {
                            accessToken.save()
                        }
                        
                        NSNotificationCenter.defaultCenter().postNotificationName(OAuthClientRefreshedAccessTokenNotification, object: self.accessToken)
                    } else {
                        self.accessToken?.remove()
                        NSNotificationCenter.defaultCenter().postNotificationName(OAuthClientFailedNotification, object: self.accessToken)
                    }
                } else {
                    NSNotificationCenter.defaultCenter().postNotificationName(OAuthClientFailedNotification, object: self.accessToken)
                    NSLog("[\(String(self)), \(#function))] Error: \(error), \((error as? NSError)!.userInfo)")
                }
        })
    }
}
