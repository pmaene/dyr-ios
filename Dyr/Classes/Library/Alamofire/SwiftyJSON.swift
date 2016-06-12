//
//  AlamofireSwiftyJSON.swift
//  AlamofireSwiftyJSON
//
//  Created by Pinglin Tang on 14-9-22.
//  Copyright (c) 2014 SwiftyJSON. All rights reserved.
//

import Alamofire
import Foundation
import SwiftyJSON

// MARK: - Request for Swift JSON

extension Request {
    
    /**
    Adds a handler to be called once the request has finished.
    
    :param: completionHandler A closure to be executed once the request has finished. The closure takes 4 arguments: the URL request, the URL response, if one was received, the SwiftyJSON enum, if one could be created from the URL response and data, and any error produced while creating the SwiftyJSON enum.
    
    :returns: The request.
    */
    public func responseSwiftyJSON(completionHandler: (NSURLRequest, NSHTTPURLResponse?, SwiftyJSON.JSON, ErrorType?) -> Void) -> Self {
        return responseSwiftyJSON(nil, options:NSJSONReadingOptions.AllowFragments, completionHandler:completionHandler)
    }
    
    /**
    Adds a handler to be called once the request has finished.
    
    :param: queue The queue on which the completion handler is dispatched.
    :param: options The JSON serialization reading options. `.AllowFragments` by default.
    :param: completionHandler A closure to be executed once the request has finished. The closure takes 4 arguments: the URL request, the URL response, if one was received, the SwiftyJSON enum, if one could be created from the URL response and data, and any error produced while creating the SwiftyJSON enum.
    
    :returns: The request.
    */
    public func responseSwiftyJSON(queue: dispatch_queue_t? = nil, options: NSJSONReadingOptions = .AllowFragments, completionHandler: (NSURLRequest, NSHTTPURLResponse?, JSON, ErrorType?) -> Void) -> Self {
        return response(queue: queue, responseSerializer: Request.JSONResponseSerializer(options: options), completionHandler: { (response) -> Void in
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                var responseJSON = JSON.null
                switch response.result {
                    case .Success:
                        responseJSON = SwiftyJSON.JSON(response.result.value!)
                    case .Failure(let error):
                        NSLog("Error: \(error), \(error.userInfo)")
                }
                
                dispatch_async(queue ?? dispatch_get_main_queue(), {
                    completionHandler(response.request!, response.response, responseJSON, response.result.error)
                })
            })
        })
    }
}
