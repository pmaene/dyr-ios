//
//  DoorRouter.swift
//  Dyr
//
//  Created by Pieter Maene on 12/04/15.
//  Copyright (c) 2015 Student IT vzw. All rights reserved.
//

import Alamofire
import Foundation

enum DoorRouter: URLRequestConvertible {
    static let baseURL = Constants.value("APIBaseURL") + "/api/v1/accessories/doors"
    static let clientParameters: [String: AnyObject] = [
        "client_id": Constants.value("APIClientID"),
        "client_secret": Constants.value("APIClientSecret")
    ]
    
    case Switch(id: String)
    
    var method: Alamofire.Method {
        switch self {
            case .Switch:
                return .POST
        }
    }
    
    var path: String {
        switch self {
            case .Switch:
                return "/switch"
        }
    }
    
    // MARK: - URLRequestConvertible
    
    var URLRequest: NSURLRequest {
        let encoding = Alamofire.ParameterEncoding.URL
        
        let URL = NSURL(string: DoorRouter.baseURL)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue
        
        println(OAuthClient.sharedClient.accessToken)
        
        var OAuthParameters: [String: AnyObject] = Dictionary<String, AnyObject>()
        if let accessToken = OAuthClient.sharedClient.accessToken {
            OAuthParameters = ["access_token": accessToken.accessToken]
        }
        
        let parameters: [String: AnyObject]? = {
            switch self {
                case .Switch(let id):
                    return ["id": id]
            }
        }()
        
        return encoding.encode(mutableURLRequest, parameters: DoorRouter.clientParameters + OAuthParameters + parameters!).0
    }
}
