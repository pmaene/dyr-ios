//
//  JWTClient+Credentials.swift
//  Dyr
//
//  Created by Pieter Maene on 12/04/15.
//  Copyright (c) 2015. All rights reserved.
//

import Alamofire
import Foundation

extension JWTClient {
    func login(withCredentials username: String, password: String) {
        Alamofire.request(JWTRouter.login(username: username, password: password))
            .responseJSON { response in
                switch response.result {
                case .success:
                    guard let json = response.result.value as? [String : Any], let jwtToken = JSONWebToken(json: json), jwtToken.archive() else {
                        NotificationCenter.default.post(name: JWTClient.NotificationNames.failed, object: self.token)
                        return
                    }
                        
                    NotificationCenter.default.post(name: JWTClient.NotificationNames.receivedToken, object: self.token)

                case .failure:
                    NotificationCenter.default.post(name: JWTClient.NotificationNames.failed, object: self.token)
                }
            }
    }
}
