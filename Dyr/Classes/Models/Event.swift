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
    @NSManaged var identifier: NSNumber
    @NSManaged var creationTime: NSDate
    @NSManaged var person: Person
    
    class func insert(json: JSON, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> Event {
        let event: Event = NSEntityDescription.insertNewObjectForEntityForName("Event", inManagedObjectContext: managedObjectContext) as! Event
        
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
        
        event.identifier = json["identifier"].numberValue
        event.creationTime = dateFormatter.dateFromString(json["creationTime"].stringValue)!
        
        let request: NSFetchRequest = NSFetchRequest(entityName: "Person")
        request.predicate = NSPredicate(format: "identifier = %@", json["person"]["id"].stringValue)
        
        var error: NSError? = NSError?()
        let person: Person? = managedObjectContext.executeFetchRequest(request, error: &error)!.last as? Person
        
        if (error != nil && person != nil) {
            event.person = person!
        } else {
            event.person = Person.insert(json["person"], inManagedObjectContext: managedObjectContext)
        }
        
        return event
    }
}
