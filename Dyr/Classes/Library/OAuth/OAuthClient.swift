//
//  OAuthClient.swift
//  Dyr
//
//  Created by Pieter Maene on 12/04/15.
//  Copyright (c) 2015 Student IT vzw. All rights reserved.
//

import Alamofire
import Alamofire_SwiftyJSON
import Foundation

let OAuthClientReceivedAccessTokenNotification: String = "OAuthReceivedAccessTokenNotification"
let OAuthClientRefreshedAccessTokenNotification: String = "OAuthRefreshedAccessTokenNotification"
let OAuthClientFailedNotification: String = "OAuthFailedNotification"

class OAuthClient {
    static let sharedClient = OAuthClient()
    var accessToken: OAuthAccessToken? = OAuthAccessToken()
    
    func refreshAccessToken() {
        Alamofire.request(OAuthRouter.AccessTokenFromRefreshToken(refreshToken: accessToken!.refreshToken))
            .responseSwiftyJSON {(_, _, json, error) in
                if (error == nil) {
                    self.accessToken = OAuthAccessToken(json: json)
                    self.accessToken?.save()
                    
                    NSNotificationCenter.defaultCenter().postNotificationName(OAuthClientRefreshedAccessTokenNotification, object: self.accessToken)
                } else {
                    NSNotificationCenter.defaultCenter().postNotificationName(OAuthClientFailedNotification, object: self.accessToken)
                    NSLog("Error: \(error), \(error?.userInfo)")
                }
        }
    }
}
