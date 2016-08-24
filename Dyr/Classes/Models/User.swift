//
//  User.swift
//  Dyr
//
//  Created by Pieter Maene on 13/11/14.
//  Copyright (c) 2014. All rights reserved.
//

import CoreData
import Foundation

class User: NSManagedObject {
    @NSManaged var identifier: String
    @NSManaged var name: String
    
    @NSManaged var events: NSSet
    
    class func insert(_ json: [String: String], inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> User? {
        let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: managedObjectContext) as! User
        
        guard let id = json["id"], let name = json["name"] else {
            return nil
        }
        
        user.identifier = id
        user.name = name
        
        return user
    }
}
