//
//  OAuthClient+Credentials.swift
//  Dyr
//
//  Created by Pieter Maene on 12/04/15.
//  Copyright (c) 2015. All rights reserved.
//

import Alamofire
import Foundation

extension OAuthClient {
    func accessTokenWithCredentials(username username: String, password: String) {
        Alamofire.request(OAuthRouter.AccessTokenFromCredentials(username: username, password: password))
            .responseSwiftyJSON({(_, _, json, error) in
                if error == nil {
                    if json["error"].string == nil {
                        if let accessToken = OAuthAccessToken(json: json) {
                            accessToken.save()
                        }
                        
                        NSNotificationCenter.defaultCenter().postNotificationName(OAuthClientReceivedAccessTokenNotification, object: self.accessToken)
                    } else {
                        NSNotificationCenter.defaultCenter().postNotificationName(OAuthClientFailedNotification, object: self.accessToken)
                    }
                } else {
                    NSNotificationCenter.defaultCenter().postNotificationName(OAuthClientFailedNotification, object: self.accessToken)
                    NSLog("[\(String(self)), \(#function))] Error: \(error), \((error as? NSError)!.userInfo)")
                }
        })
    }
}