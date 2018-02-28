//
//  OAuthClient.swift
//  Dyr
//
//  Created by Pieter Maene on 12/04/15.
//  Copyright (c) 2015. All rights reserved.
//

import Alamofire
import Foundation
import JWTDecode

class JWTClient {
    struct NotificationNames {
        static var receivedToken = NSNotification.Name(rawValue: "JWTClientReceivedToken")
        static var refreshedToken = NSNotification.Name(rawValue: "JWTClientRefreshedToken")
        static var failed = NSNotification.Name(rawValue: "JWTClientFailed")
    }
    
    static let sharedClient = JWTClient()
    
    var token: JSONWebToken? {
        get {
            if let token = JSONWebToken.unarchive() {
                if token.willExpire() {
                    refreshToken(token)
                    return nil
                }
                
                return token
            } else {
                NotificationCenter.default.post(name: NotificationNames.failed, object: nil)
                return nil
            }
        }
    }
    
    func refresh(withToken token: JSONWebToken) {
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
