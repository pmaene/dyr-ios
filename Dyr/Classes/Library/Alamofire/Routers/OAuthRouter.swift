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
    
    case accessTokenFromCredentials(username: String, password: String)
    case accessTokenFromRefreshToken(refreshToken: String)
    
    var method: Alamofire.Method {
        switch self {
            case .accessTokenFromCredentials:
                return .POST
            case .accessTokenFromRefreshToken:
                return .POST
        }
    }
    
    var path: String {
        switch self {
            case .accessTokenFromCredentials:
                return "/token"
            case .accessTokenFromRefreshToken:
                return "/token"
        }
    }
    
    // MARK: - URLRequestConvertible
    
    var urlRequest: URLRequest {
        let encoding = Alamofire.ParameterEncoding.url
        
        let (path, parameters): (String, [String: AnyObject]?) = {
            switch self {
                case .accessTokenFromCredentials(let username, let password):
                    return ("/token", ["username": username, "password": password, "grant_type": "password"])
                case .accessTokenFromRefreshToken(let refreshToken):
                    return ("/token", ["refresh_token": refreshToken, "grant_type": "refresh_token"])
            }
        }()
        
        let url = Foundation.URL(string: OAuthRouter.baseURL)!
        var urlRequest = URLRequest(url: try! url.appendingPathComponent(path))
        urlRequest.httpMethod = Alamofire.Method.POST.rawValue
        
        return encoding.encode(urlRequest, parameters: OAuthRouter.clientParameters + parameters!).0
    }
}
