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
    static let baseURLString = Constants.value(forKey: "APIBaseURL") + "/api/v1/accessories/doors"
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
    
    func asURLRequest() throws -> URLRequest {
        var OAuthParameters = Dictionary<String, Any>()
        if let accessToken = OAuthClient.sharedClient.accessToken {
            OAuthParameters = ["access_token": accessToken.accessToken]
        }
        
        let result: (path: String, parameters: Parameters) = {
            switch self {
            case .doors:
                return (path, DoorRouter.clientParameters + OAuthParameters)
            case let .switch(door):
                return (path, DoorRouter.clientParameters + OAuthParameters + ["id": door.identifier])
            }
        }()
        
        let url = try DoorRouter.baseURLString.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(result.path))
        urlRequest.httpMethod = method.rawValue
        
        return try URLEncoding.default.encode(urlRequest, with: result.parameters)
    }
}
