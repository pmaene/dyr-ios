//
//  JWTRouter
//  Dyr
//
//  Created by Pieter Maene on 12/04/15.
//  Copyright (c) 2015. All rights reserved.
//

import Alamofire
import Foundation

enum JWTRouter: URLRequestConvertible {
    static let baseURLString = Constants.value(forKey: "APIBaseURL") + "/api/v1/auth"
    
    case login(username: String, password: String)
    case refresh(token: String)
    
    var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        case .refresh:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .login:
            return "/login"
        case .refresh:
            return "/refresh"
        }
    }
    
    // MARK: - URLRequestConvertible
    
    func asURLRequest() throws -> URLRequest {
        let result: (path: String, parameters: Parameters) = {
            switch self {
            case let .login(username, password):
                return (path, ["username": username, "password": password])
            case .refresh(_):
                return (path, [:])
            }
        }()
        
        let url = try JWTRouter.baseURLString.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(result.path))
        urlRequest.httpMethod = method.rawValue
        
        if case let .refresh(token) = self {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        return try URLEncoding.default.encode(urlRequest, with: result.parameters)
    }
}
