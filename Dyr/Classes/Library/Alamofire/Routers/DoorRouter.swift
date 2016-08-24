//
//  DoorRouter.swift
//  Dyr
//
//  Created by Pieter Maene on 12/04/15.
//  Copyright (c) 2015. All rights reserved.
//

import Alamofire
import Foundation

enum DoorRouter: URLRequestConvertible {
    static let baseURL = Constants.value(forKey: "APIBaseURL") + "/api/v1/accessories/doors"
    static let clientParameters: [String: Any] = [
        "client_id": Constants.value(forKey: "APIClientID"),
        "client_secret": Constants.value(forKey: "APIClientSecret")
    ]
    
    case doors()
    case `switch`(door: Door)
    
    var method: HTTPMethod {
        switch self {
        case .doors:
            return .get
        case .switch:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .doors:
            return "/"
        case .switch:
            return "/switch"
        }
    }
    
    // MARK: - URLRequestConvertible
    
    var urlRequest: URLRequest {
        get {
            let encoding = Alamofire.ParameterEncoding.url
        
            let url = Foundation.URL(string: DoorRouter.baseURL)!
            var urlRequest = URLRequest(url: url.appendingPathComponent(path))
            urlRequest.httpMethod = method.rawValue
        
            var OAuthParameters = Dictionary<String, Any>()
            if let accessToken = OAuthClient.sharedClient.accessToken {
                OAuthParameters = ["access_token": accessToken.accessToken]
            }
        
            let parameters: [String: Any]? = {
                switch self {
                case .switch(let door):
                    return ["id": door.identifier]
                default:
                    return nil
                }
            }()
        
            if parameters == nil {
                return encoding.encode(urlRequest, parameters: DoorRouter.clientParameters + OAuthParameters).0
            } else {
                return encoding.encode(urlRequest, parameters: DoorRouter.clientParameters + OAuthParameters + parameters!).0
            }
        }
    }
}
