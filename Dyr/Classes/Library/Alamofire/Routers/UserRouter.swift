//
//  UserRouter.swift
//  Dyr
//
//  Created by Pieter Maene on 17/04/2017.
//
//

import Alamofire
import Foundation

enum UserRouter: URLRequestConvertible {
    static let baseURLString = Constants.value(forKey: "APIBaseURL") + "/api/v1/users/"
    
    case users(username: String)
    
    var method: HTTPMethod {
        switch self {
        case .users:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .users:
            return "/"
        }
    }
    
    // MARK: - URLRequestConvertible
    
    func asURLRequest() throws -> URLRequest {
        let result: (path: String, parameters: Parameters) = {
            switch self {
            case let .users(username):
                return (path + "/\(username)", [:])
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
