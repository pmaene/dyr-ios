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
            return "/"
        }
    }
    
    // MARK: - URLRequestConvertible
    
    func asURLRequest() throws -> URLRequest {
        let result: (path: String, parameters: Parameters) = {
            switch self {
            case .doors:
                return (path, [:])
            case let .switch(door):
                return (path + , [:])
            }
        }()
        
        let url = try DoorRouter.baseURLString.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(result.path))
        urlRequest.httpMethod = method.rawValue
        
        if let token = JWTClient.sharedClient.token {
            urlRequest.setValue("Bearer \(token.rawValue)", forHTTPHeaderField: "Authorization")
        }
        
        return try URLEncoding.default.encode(urlRequest, with: result.parameters)
    }
}
