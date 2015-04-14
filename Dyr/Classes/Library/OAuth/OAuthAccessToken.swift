//
//  OAuthAccessToken.swift
//  Dyr
//
//  Created by Pieter Maene on 12/04/15.
//  Copyright (c) 2015 Student IT vzw. All rights reserved.
//

import Foundation
import Lockbox
import SwiftyJSON

enum TokenType: String {
    case Bearer = "bearer"
}

let OAuthKeychainKey: String = "OAuthAccessToken"

class OAuthAccessToken: Printable {
    var accessToken: String
    var expiresAt: NSDate?
    var tokenType: TokenType?
    var refreshToken: String
    
    var description: String {
        return "<OAuthAccessToken accessToken:\(accessToken) expiresAt:\(expiresAt!) tokenType:\(tokenType!.rawValue) refreshToken:\(refreshToken)>"
    }
    
    convenience init?(json: JSON) {
        self.init()
        
        accessToken = json["access_token"].stringValue
        expiresAt = NSDate(timeIntervalSinceNow: json["expires_in"].rawValue as! NSTimeInterval)
        tokenType = TokenType(rawValue: json["token_type"].stringValue)!
        refreshToken = json["refresh_token"].stringValue
    }

    func hasExpired() -> Bool {
        return expiresAt!.compare(NSDate()) == NSComparisonResult.OrderedAscending;
    }
    
    // MARK: - Keychain
    
    func save() {
        let data: [String: AnyObject] = [
            "accessToken": accessToken,
            "expiresAt": expiresAt!,
            "tokenType": tokenType!.rawValue,
            "refreshToken": refreshToken
        ]
        
        Lockbox.setDictionary(data, forKey: OAuthKeychainKey)
        
        NSLog("[\(NSStringFromClass(self.dynamicType)), \(__FUNCTION__))] Saved to Keychain")
    }
    
    func remove() {
        Lockbox.setDictionary(nil, forKey: OAuthKeychainKey)
    }
    
    init?() {
        if let data: [String: AnyObject]? = Lockbox.dictionaryForKey(OAuthKeychainKey) as? [String: AnyObject] {
            accessToken = data!["accessToken"] as! String
            
            // This is an ugly fix for Optionals mangling 
            let dateFormatter: NSDateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "%Y-%m-%d %H:%M:%S %z"
            expiresAt = dateFormatter.dateFromString((data!["expiresAt"] as? String)!)
            
            tokenType = TokenType(rawValue: data!["tokenType"] as! String)
            refreshToken = data!["refreshToken"] as! String
        } else {
            accessToken = ""
            expiresAt = nil
            tokenType = nil
            refreshToken = ""
            
            return nil
        }
    }
}
