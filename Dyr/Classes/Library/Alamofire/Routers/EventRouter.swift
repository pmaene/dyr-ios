//
//  EventRouter.swift
//  Dyr
//
//  Created by Pieter Maene on 26/04/15.
//  Copyright (c) 2015. All rights reserved.
//

import Alamofire
import Foundation

enum EventRouter: URLRequestConvertible {
    static let baseURL = Constants.value(forKey: "APIBaseURL") + "/api/v1/events"
    static let clientParameters: [String: Any] = [
        "client_id": Constants.value(forKey: "APIClientID"),
        "client_secret": Constants.value(forKey: "APIClientSecret")
    ]
    
    case events(door: Door)
    
    var method: HTTPMethod {
        switch self {
        case .events:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .events:
            return "/"
        }
    }
    
    // MARK: - URLRequestConvertible
    
    var urlRequest: URLRequest {
        let encoding = Alamofire.ParameterEncoding.url
        
        let url = Foundation.URL(string: EventRouter.baseURL)!
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        var OAuthParameters = Dictionary<String, Any>()
        if let accessToken = OAuthClient.sharedClient.accessToken {
            OAuthParameters = ["access_token": accessToken.accessToken]
        }
        
        let parameters: [String: Any]? = {
            switch self {
            case .events(let door):
                return ["door": door.identifier]
            }
        }()
        
        return encoding.encode(urlRequest, parameters: EventRouter.clientParameters + OAuthParameters + parameters!).0
    }
}
