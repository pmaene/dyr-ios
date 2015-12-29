//
//  EventRouter.swift
//  Dyr
//
//  Created by Pieter Maene on 26/04/15.
//  Copyright (c) 2015 Student IT vzw. All rights reserved.
//

import Alamofire
import Foundation

enum EventRouter: URLRequestConvertible {
    static let baseURL = Constants.value(forKey: "APIBaseURL") + "/api/v1/events"
    static let clientParameters: [String: AnyObject] = [
        "client_id": Constants.value(forKey: "APIClientID"),
        "client_secret": Constants.value(forKey: "APIClientSecret")
    ]
    
    case Events(door: Door)
    
    var method: Alamofire.Method {
        switch self {
            case .Events:
                return .GET
        }
    }
    
    var path: String {
        switch self {
            case .Events:
                return "/"
        }
    }
    
    // MARK: - URLRequestConvertible
    
    var URLRequest: NSMutableURLRequest {
        let encoding = Alamofire.ParameterEncoding.URL
        
        let URL = NSURL(string: EventRouter.baseURL)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue
        
        var OAuthParameters: [String: AnyObject] = Dictionary<String, AnyObject>()
        if let accessToken = OAuthClient.sharedClient.accessToken {
            OAuthParameters = ["access_token": accessToken.accessToken]
        }
        
        let parameters: [String: AnyObject]? = {
            switch self {
                case .Events(let door):
                    return ["door": door.identifier]
            }
        }()
        
        return encoding.encode(mutableURLRequest, parameters: EventRouter.clientParameters + OAuthParameters + parameters!).0
    }
}
