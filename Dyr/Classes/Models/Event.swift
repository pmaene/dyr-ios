//
//  Event.swift
//  Dyr
//
//  Created by Pieter Maene on 13/11/14.
//  Copyright (c) 2014 Student IT vzw. All rights reserved.
//

import CoreData
import Foundation
import SwiftyJSON

class Event: NSManagedObject {
    @NSManaged var creationTime: NSDate
    @NSManaged var identifier: String
    
    @NSManaged var accessory: Accessory
    @NSManaged var user: User
    
    class func insert(json: JSON, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> Event {
        let event: Event = NSEntityDescription.insertNewObjectForEntityForName("Event", inManagedObjectContext: managedObjectContext) as! Event
        
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
        
        event.creationTime = dateFormatter.dateFromString(json["creation_time"].stringValue)!
        event.identifier = json["id"].stringValue
        
        var request: NSFetchRequest = NSFetchRequest(entityName: "Accessory")
        request.predicate = NSPredicate(format: "identifier = %@", json["accessory"].stringValue)
        
        let accessory: Accessory? = managedObjectContext.executeFetchRequest(request, error: nil)!.last as? Accessory
        if (accessory != nil) {
            event.accessory = accessory!
        }
        
        request = NSFetchRequest(entityName: "User")
        request.predicate = NSPredicate(format: "identifier = %@", json["user"]["id"].stringValue)
        
        let user: User? = managedObjectContext.executeFetchRequest(request, error: nil)!.last as? User
        if (user != nil) {
            event.user = user!
        } else {
            event.user = User.insert(json["user"], inManagedObjectContext: managedObjectContext)
        }
        
        return event
    }
}
