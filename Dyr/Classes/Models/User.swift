//
//  User.swift
//  Dyr
//
//  Created by Pieter Maene on 13/11/14.
//  Copyright (c) 2014. All rights reserved.
//

import CoreData
import Foundation
import SwiftyJSON

class User: NSManagedObject {
    @NSManaged var identifier: String
    @NSManaged var name: String
    
    @NSManaged var events: NSSet
    
    class func insert(_ json: JSON, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> User {
        let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: managedObjectContext) as! User
        
        user.identifier = json["id"].stringValue
        user.name = json["name"].stringValue
        
        return user
    }
}
