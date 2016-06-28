//
//  OAuthAccessToken.swift
//  Dyr
//
//  Created by Pieter Maene on 12/04/15.
//  Copyright (c) 2015. All rights reserved.
//

import Foundation
import Lockbox
import SwiftyJSON

enum TokenType: String {
    case Bearer = "bearer"
}

let OAuthKeychainKey: String = "OAuthAccessToken"

class OAuthAccessToken: CustomStringConvertible {
    var accessToken: String
    var expiresAt: Date?
    var tokenType: TokenType?
    var refreshToken: String
    
    var refreshing: Bool = false
    
    var description: String {
        return "<OAuthAccessToken accessToken:\(accessToken) expiresAt:\(expiresAt) tokenType:\(tokenType?.rawValue) refreshToken:\(refreshToken)>"
    }
    
    init?() {
        if let data = Lockbox.unarchiveObject(forKey: OAuthKeychainKey) as? [String: AnyObject] {
            accessToken = data["accessToken"] as! String
            expiresAt = data["expiresAt"] as? Date
            tokenType = TokenType(rawValue: data["tokenType"] as! String)
            refreshToken = data["refreshToken"] as! String
        } else {
            return nil
        }
    }
    
    init?(json: JSON) {
        if json != nil {
            accessToken = json["access_token"].stringValue
            expiresAt = NSDate(timeIntervalSinceNow: json["expires_in"].rawValue as! TimeInterval) as Date
            tokenType = TokenType(rawValue: json["token_type"].stringValue)!
            refreshToken = json["refresh_token"].stringValue
        } else {
            return nil
        }
    }

    func hasExpired() -> Bool {
        return expiresAt!.compare(Date()) == ComparisonResult.orderedAscending;
    }
    
    // MARK: - Keychain
    
    func save() {
        let data: [String: AnyObject] = [
            "accessToken": accessToken,
            "expiresAt": expiresAt!,
            "tokenType": tokenType!.rawValue,
            "refreshToken": refreshToken
        ]
        
        Lockbox.archiveObject(data, forKey: OAuthKeychainKey)
        
        NSLog("[\(String(self)), \(#function))] Saved to Keychain")
    }
    
    func remove() {
        Lockbox.archiveObject(nil, forKey: OAuthKeychainKey)
    }
}
