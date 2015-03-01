//
//  HTTPManager.swift
//  Dyr
//
//  Created by Pieter Maene on 15/11/14.
//  Copyright (c) 2014 Student IT vzw. All rights reserved.
//

class HTTPManager {
    class var sessionManager: AFHTTPSessionManager {
        struct SessionManager {
            static let instance: AFHTTPSessionManager = AFHTTPSessionManager()
        }
        
        return SessionManager.instance
    }
    
    class var requestOperationManager: AFHTTPRequestOperationManager {
        struct RequestOperationManager {
            static let instance: AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        }
        
        return RequestOperationManager.instance
    }
}
