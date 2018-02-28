//
//  User.swift
//  Dyr
//
//  Created by Pieter Maene on 13/11/14.
//  Copyright (c) 2014. All rights reserved.
//

import Alamofire
import CoreData
import Foundation

class User: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var username: String
    
    @NSManaged var events: NSSet
    
    // MARK: - Alamofire
    
    class func get(_ username: String, success: (([String : Any]) -> Void)?, failure: ((Error) -> Void)?) {
        Alamofire.request(UserRouter.users(username: username))
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    guard let json = value as? [String : Any] else {
                        return
                    }
                    
                    success?(json)
                case .failure(let error):
                    failure?(error)
                }
        }
    }
    
    // MARK: - Core Data
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User");
    }
    
    @objc(addEventsObjects:)
    @NSManaged public func addToEvents(_ value: Event)
    
    @objc(removeEventsObject:)
    @NSManaged public func removeFromEvents(_ value: Event)
    
    class func insert(_ json: [String : Any], in managedObjectContext: NSManagedObjectContext) -> User? {
        guard let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: managedObjectContext) as? User,
            let username = json["username"] as? String,
            let name = json["name"] as? String else {
            return nil
        }
        
        user.username = username
        user.name = name
        
        return user
    }
}
