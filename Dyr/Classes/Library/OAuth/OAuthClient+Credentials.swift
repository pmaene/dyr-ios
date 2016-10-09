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
    func accessTokenWithCredentials(username: String, password: String) {
        Alamofire.request(OAuthRouter.accessTokenFromCredentials(username: username, password: password))
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let json = response.result.value as? [String: Any] {
                        if json["error"] == nil {
                            if let accessToken = OAuthAccessToken(json: json) {
                                accessToken.archive()
                            }
                        
                            NotificationCenter.default.post(name: OAuthClient.NotificationNames.receivedAccessToken, object: self.accessToken)
                        } else {
                            NotificationCenter.default.post(name: OAuthClient.NotificationNames.failed, object: nil)
                        }
                    }

                case .failure:
                    NotificationCenter.default.post(name: OAuthClient.NotificationNames.failed, object: self.accessToken)
                }
            }
    }
}
