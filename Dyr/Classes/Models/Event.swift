//
//  Event.swift
//  Dyr
//
//  Created by Pieter Maene on 13/11/14.
//  Copyright (c) 2014 Student IT vzw. All rights reserved.
//

import CoreData

class Event: NSManagedObject {
    @NSManaged var identifier: NSNumber
    @NSManaged var creationTime: NSDate
    @NSManaged var person: Person
    
    func eventWithJsonData(jsonData: NSDictionary, managedObjectContext: NSManagedObjectContext) -> Event {
        var event: Event = Event()
        return event
    }
}
