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
    static let clientParameters: [String: AnyObject] = [
        "client_id": Constants.value(forKey: "APIClientID"),
        "client_secret": Constants.value(forKey: "APIClientSecret")
    ]
    
    case Doors()
    case Switch(door: Door)
    
    var method: Alamofire.Method {
        switch self {
            case .Doors:
                return .GET
            case .Switch:
                return .POST
        }
    }
    
    var path: String {
        switch self {
            case .Doors:
                return "/"
            case .Switch:
                return "/switch"
        }
    }
    
    // MARK: - URLRequestConvertible
    
    var URLRequest: NSMutableURLRequest {
        let encoding = Alamofire.ParameterEncoding.URL
        
        let URL = NSURL(string: DoorRouter.baseURL)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue
        
        var OAuthParameters: [String: AnyObject] = Dictionary<String, AnyObject>()
        if let accessToken = OAuthClient.sharedClient.accessToken {
            OAuthParameters = ["access_token": accessToken.accessToken]
        }
        
        let parameters: [String: AnyObject]? = {
            switch self {
                case .Switch(let door):
                    return ["id": door.identifier]
                default:
                    return nil
            }
        }()
        
        if (parameters == nil) {
            return encoding.encode(mutableURLRequest, parameters: DoorRouter.clientParameters + OAuthParameters).0
        } else {
            return encoding.encode(mutableURLRequest, parameters: DoorRouter.clientParameters + OAuthParameters + parameters!).0
        }
    }
}
