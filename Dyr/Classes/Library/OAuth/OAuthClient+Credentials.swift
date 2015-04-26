//
//  OAuthClient+Credentials.swift
//  Dyr
//
//  Created by Pieter Maene on 12/04/15.
//  Copyright (c) 2015 Student IT vzw. All rights reserved.
//

import Alamofire
import Alamofire_SwiftyJSON
import Foundation

extension OAuthClient {
    func accessTokenWithCredentials(#username: String, password: String) {
        Alamofire.request(OAuthRouter.AccessTokenFromCredentials(username: username, password: password))
            .responseSwiftyJSON {(_, _, json, error) in
                if (error == nil) {
                    self.accessToken = OAuthAccessToken(json: json)
                    self.accessToken?.save()
                    
                    NSNotificationCenter.defaultCenter().postNotificationName(OAuthClientReceivedAccessTokenNotification, object: self.accessToken)
                } else {
                    NSNotificationCenter.defaultCenter().postNotificationName(OAuthClientFailedNotification, object: self.accessToken)
                    NSLog("[\(NSStringFromClass(self.dynamicType)), \(__FUNCTION__))] Error: \(error), \(error!.userInfo)")
                }
        }
    }
}