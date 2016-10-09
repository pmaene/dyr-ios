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
    static let baseURLString = Constants.value(forKey: "APIBaseURL") + "/api/v1/events"
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
    
    func asURLRequest() throws -> URLRequest {
        var OAuthParameters = Dictionary<String, Any>()
        if let accessToken = OAuthClient.sharedClient.accessToken {
            OAuthParameters = ["access_token": accessToken.accessToken]
        }
        
        let result: (path: String, parameters: Parameters) = {
            switch self {
            case let .events(door):
                return (path, DoorRouter.clientParameters + OAuthParameters + ["door": door.identifier])
            }
        }()
        
        let url = try DoorRouter.baseURLString.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(result.path))
        urlRequest.httpMethod = method.rawValue
        
        return try URLEncoding.default.encode(urlRequest, with: result.parameters)
    }
}
