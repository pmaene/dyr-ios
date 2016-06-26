//
//  OAuthClient+Credentials.swift
//  Dyr
//
//  Created by Pieter Maene on 12/04/15.
//  Copyright (c) 2015. All rights reserved.
//

import Alamofire
import Foundation
import SwiftyJSON

extension OAuthClient {
    func accessTokenWithCredentials(username: String, password: String) {
        Alamofire.request(OAuthRouter.accessTokenFromCredentials(username: username, password: password))
            .responseJSON { response in
                switch response.result {
                    case .success:
                        if let jsonData = response.result.value {
                            let json = JSON(jsonData)
                            if json["error"].string == nil {
                                if let accessToken = OAuthAccessToken(json: json) {
                                    accessToken.save()
                                }
                        
                                NotificationCenter.default().post(name: NSNotification.Name(rawValue: OAuthClientReceivedAccessTokenNotification), object: self.accessToken)
                            } else {
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
