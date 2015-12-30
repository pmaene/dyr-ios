//
//  OAuthRouter.swift
//  Dyr
//
//  Created by Pieter Maene on 12/04/15.
//  Copyright (c) 2015. All rights reserved.
//

import Alamofire
import Foundation

enum OAuthRouter: URLRequestConvertible {
    static let baseURL = Constants.value(forKey: "APIBaseURL") + "/oauth"
    static let clientParameters: [String: AnyObject] = [
        "client_id": Constants.value(forKey: "APIClientID"),
        "client_secret": Constants.value(forKey: "APIClientSecret")
    ]
    
    case AccessTokenFromCredentials(username: String, password: String)
    case AccessTokenFromRefreshToken(refreshToken: String)
    
    var method: Alamofire.Method {
        switch self {
            case .AccessTokenFromCredentials:
                return .POST
            case .AccessTokenFromRefreshToken:
                return .POST
        }
    }
    
    var path: String {
        switch self {
            case .AccessTokenFromCredentials:
                return "/token"
            case .AccessTokenFromRefreshToken:
                return "/token"
        }
    }
    
    // MARK: - URLRequestConvertible
    
    var URLRequest: NSMutableURLRequest {
        let encoding = Alamofire.ParameterEncoding.URL
        
        let (path, parameters): (String, [String: AnyObject]?) = {
            switch self {
                case .AccessTokenFromCredentials(let username, let password):
                    return ("/token", ["username": username, "password": password, "grant_type": "password"])
                case .AccessTokenFromRefreshToken(let refreshToken):
                    return ("/token", ["refresh_token": refreshToken, "grant_type": "refresh_token"])
            }
        }()
        
        let URL = NSURL(string: OAuthRouter.baseURL)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = Alamofire.Method.POST.rawValue
        
        return encoding.encode(mutableURLRequest, parameters: OAuthRouter.clientParameters + parameters!).0
    }
}
