//
//  OAuthAccessToken.swift
//  Dyr
//
//  Created by Pieter Maene on 12/04/15.
//  Copyright (c) 2015. All rights reserved.
//

import Foundation
import Lockbox

enum TokenType: String {
    case Bearer = "bearer"
}

let OAuthKeychainKey: String = "OAuthAccessToken"

class OAuthAccessToken: NSObject, NSSecureCoding {
    var accessToken: String
    var expiresAt: NSDate
    var tokenType: TokenType
    var refreshToken: String
    
    var refreshing: Bool = false
    
    override var description: String {
        return "<OAuthAccessToken accessToken:\(accessToken) expiresAt:\(expiresAt) tokenType:\(tokenType.rawValue) refreshToken:\(refreshToken)>"
    }
    
    init(accessToken: String, expiresAt: NSDate, tokenType: TokenType, refreshToken: String) {
        self.accessToken = accessToken
        self.expiresAt = expiresAt
        self.tokenType = tokenType
        self.refreshToken = refreshToken
    }
    
    // TOOD: Use createdAt to calculate expiresAt
    convenience init?(json: [String: Any]) {
        guard let accessToken = json["access_token"] as? String,
            let expiresIn = json["expires_in"] as? TimeInterval,
            let rawTokenType = json["token_type"] as? String,
            let tokenType = TokenType(rawValue: rawTokenType),
            let refreshToken = json["refresh_token"] as? String
        else {
            return nil
        }
        
        self.init(
            accessToken: accessToken,
            expiresAt: NSDate(timeIntervalSinceNow: expiresIn),
            tokenType: tokenType,
            refreshToken: refreshToken
        )
    }

    func hasExpired() -> Bool {
        return expiresAt.compare(Date()) == ComparisonResult.orderedAscending;
    }
    
    // MARK: - NSSecureCoding
    
    static var supportsSecureCoding = true
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let accessToken = aDecoder.decodeObject(of: NSString.self, forKey: "accessToken") as String?,
            let expiresAt = aDecoder.decodeObject(of: NSDate.self, forKey: "expiresAt") as NSDate?,
            let rawTokenType = aDecoder.decodeObject(of: NSString.self, forKey: "tokenType") as String?,
            let tokenType = TokenType(rawValue: rawTokenType),
            let refreshToken = aDecoder.decodeObject(of: NSString.self, forKey: "refreshToken") as? String
        else {
            return nil
        }
        
        self.init(
            accessToken: accessToken,
            expiresAt: expiresAt,
            tokenType: tokenType,
            refreshToken: refreshToken
        )
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(accessToken, forKey: "accessToken")
        aCoder.encode(expiresAt, forKey: "expiresAt")
        aCoder.encode(tokenType.rawValue, forKey: "tokenType")
        aCoder.encode(refreshToken, forKey: "refreshToken")
    }
    
    // MARK: - Keychain
    
    func archive() {
        Lockbox.archiveObject(self, forKey: OAuthKeychainKey)
    }
    
    class func unarchive() -> OAuthAccessToken? {
        return Lockbox.unarchiveObject(forKey: OAuthKeychainKey) as? OAuthAccessToken
    }
    
    class func remove() {
        Lockbox.archiveObject(nil, forKey: OAuthKeychainKey)
    }
}
