//
//  OAuthClient.swift
//  Dyr
//
//  Created by Pieter Maene on 12/04/15.
//  Copyright (c) 2015. All rights reserved.
//

import Alamofire
import Foundation
import SwiftyJSON

let OAuthClientReceivedAccessTokenNotification: String = "OAuthReceivedAccessTokenNotification"
let OAuthClientRefreshedAccessTokenNotification: String = "OAuthRefreshedAccessTokenNotification"
let OAuthClientFailedNotification: String = "OAuthFailedNotification"

class OAuthClient {
    static let sharedClient = OAuthClient()
    var accessToken: OAuthAccessToken? {
        get {
            if let accessToken = OAuthAccessToken() {
                if accessToken.hasExpired() {
                    refreshAccessToken(accessToken)
                    return nil
                }
                
                return accessToken
            } else {
                NotificationCenter.default().post(name: NSNotification.Name(rawValue: OAuthClientFailedNotification), object: nil)
                return nil
            }
        }
    }
    
    func refreshAccessToken(_ accessToken: OAuthAccessToken) {
        Alamofire.request(OAuthRouter.accessTokenFromRefreshToken(refreshToken: accessToken.refreshToken))
            .responseJSON { response in
                switch response.result {
                    case .success:
                        if let jsonData = response.result.value {
                            let json = JSON(jsonData)
                            if json["error"].string == nil {
                                if let accessToken = OAuthAccessToken(json: json) {
                                    accessToken.save()
                                }
                                
                                NotificationCenter.default().post(name: NSNotification.Name(rawValue: OAuthClientRefreshedAccessTokenNotification), object: self.accessToken)
                            } else {
                                self.accessToken?.remove()
                                NotificationCenter.default().post(name: NSNotification.Name(rawValue: OAuthClientFailedNotification), object: self.accessToken)
                            }
                        }
                    
                    case .failure(let error):
                        NotificationCenter.default().post(name: NSNotification.Name(rawValue: OAuthClientFailedNotification), object: self.accessToken)
                        NSLog("[\(String(self)), \(#function))] Error: \(error), \(error.userInfo)")
                }
            }
    }
}
