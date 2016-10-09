//
//  OAuthClient.swift
//  Dyr
//
//  Created by Pieter Maene on 12/04/15.
//  Copyright (c) 2015. All rights reserved.
//

import Alamofire
import Foundation

class OAuthClient {
    struct NotificationNames {
        static var receivedAccessToken = NSNotification.Name(rawValue: "OAuthClientReceivedAccessToken")
        static var refreshedAcessToken = NSNotification.Name(rawValue: "OAuthClientRefreshedAccessToken")
        static var failed = NSNotification.Name(rawValue: "OAuthClientFailed")
    }
    
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
                NotificationCenter.default.post(name: NotificationNames.failed, object: nil)
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
                                
                            NotificationCenter.default.post(name: NotificationNames.refreshedAcessToken, object: self.accessToken)
                        } else {
                            OAuthAccessToken.remove()
                            NotificationCenter.default.post(name: NotificationNames.failed, object: nil)
                        }
                    }
                    
                case .failure:
                    NotificationCenter.default.post(name: NotificationNames.failed, object: self.accessToken)
                }
            }
    }
}
