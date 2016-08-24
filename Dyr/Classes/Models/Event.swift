//
//  Event.swift
//  Dyr
//
//  Created by Pieter Maene on 13/11/14.
//  Copyright (c) 2014. All rights reserved.
//

import CoreData
import Foundation

class Event: NSManagedObject {
    @NSManaged var creationTime: Date
    @NSManaged var identifier: String
    
    @NSManaged var accessory: Accessory
    @NSManaged var user: User
    
    // TODO: Throw an exception when JSON deserialization fails
    class func insert(_ json: [String: Any], inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> Event? {
        let event = NSEntityDescription.insertNewObject(forEntityName: "Event", into: managedObjectContext) as! Event
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
        
        guard let creationTime = json["creation_time"] as? String, let id = json["id"] as? String else {
            return nil
        }
        
        if let creationTime = dateFormatter.date(from: creationTime) {
            event.creationTime = creationTime
        }
        
        event.identifier = id
        
        guard let accessory = json["accessory"] as? String else {
            return nil
        }
        
        var request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Accessory")
        request.predicate = NSPredicate(format: "identifier = %@", accessory)
            
        if let accessory = (try! managedObjectContext.fetch(request)).last as? Accessory {
            event.accessory = accessory
        }
        
        guard let user = json["user"] as? [String: String], let userId = user["id"] else {
            return nil
        }
        
        request = NSFetchRequest(entityName: "User")
        request.predicate = NSPredicate(format: "identifier = %@", userId)
        
        if let user = (try! managedObjectContext.fetch(request)).last as? User {
            event.user = user
        } else {
            guard let user = User.insert(user, inManagedObjectContext: managedObjectContext) else {
                return nil
            }
            
            event.user = user
        }
        
        return event
    }
}
