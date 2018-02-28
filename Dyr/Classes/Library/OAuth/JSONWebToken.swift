//
//  JWTToken.swift
//  Dyr
//
//  Created by Pieter Maene on 12/04/15.
//  Copyright (c) 2015. All rights reserved.
//

import Foundation
import JWTDecode
import Strongbox
import SwiftDate

class JSONWebToken: NSSecureCoding {
    static let keychainKey: String = "JSONWebToken"
    
    var expiresAt: Date? {
        get {
            do {
                let token = try decode(jwt: rawValue)
                return token.expiresAt
            } catch {
                return nil
            }
        }
    }
    var rawValue: String
    var subject: String? {
        get {
            do {
                let token = try decode(jwt: rawValue)
                return token.subject
            } catch {
                return nil
            }
        }
    }
    
    init(rawValue: String) {
        self.rawValue = rawValue
    }
    
    convenience init?(json: [String : Any]) {
        guard let rawValue = json["token"] as? String else {
            return nil
        }
        
        self.init(rawValue: rawValue)
    }
    
    func willExpire(in interval: DateComponents = 1.day) -> Bool {
        guard let expiresAt = expiresAt, expiresAt > (Date() - interval) else {
            return false
        }
            
        return true
    }
    
    // MARK: - NSSecureCoding
    
    static var supportsSecureCoding = true
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let rawValue = aDecoder.decodeObject(forKey: "rawValue") as? String else {
            return nil
        }
        
        self.init(rawValue: rawValue)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(rawValue, forKey: "rawValue")
    }
    
    // MARK: - Keychain
    
    func archive() -> Bool {
        return Strongbox().archive(self, key: JSONWebToken.keychainKey)
    }
    
    class func unarchive() -> JSONWebToken? {
        return Strongbox().unarchive(objectForKey: JSONWebToken.keychainKey) as? JSONWebToken
    }
    
    class func remove() -> Bool {
        return Strongbox().archive(nil, key: JSONWebToken.keychainKey)
    }
}
