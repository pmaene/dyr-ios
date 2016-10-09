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
    static let baseURLString = Constants.value(forKey: "APIBaseURL") + "/oauth"
    static let clientParameters: [String: Any] = [
        "client_id": Constants.value(forKey: "APIClientID"),
        "client_secret": Constants.value(forKey: "APIClientSecret")
    ]
    
    case accessTokenFromCredentials(username: String, password: String)
    case accessTokenFromRefreshToken(refreshToken: String)
    
    var method: HTTPMethod {
        switch self {
        case .accessTokenFromCredentials:
            return .post
        case .accessTokenFromRefreshToken:
            return .post
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
    
    func asURLRequest() throws -> URLRequest {
        let result: (path: String, parameters: Parameters) = {
            switch self {
            case let .accessTokenFromCredentials(username, password):
                return (path, ["username": username, "password": password, "grant_type": "password"])
            case let .accessTokenFromRefreshToken(refreshToken):
                return (path, ["refresh_token": refreshToken, "grant_type": "refresh_token"])
            }
        }()
        
        let url = try OAuthRouter.baseURLString.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(result.path))
        urlRequest.httpMethod = method.rawValue
        
        return try URLEncoding.default.encode(urlRequest, with: result.parameters)
    }
}
