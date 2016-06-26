//
//  Event.swift
//  Dyr
//
//  Created by Pieter Maene on 13/11/14.
//  Copyright (c) 2014. All rights reserved.
//

import CoreData
import Foundation
import SwiftyJSON

class Event: NSManagedObject {
    @NSManaged var creationTime: Date
    @NSManaged var identifier: String
    
    @NSManaged var accessory: Accessory
    @NSManaged var user: User
    
    class func insert(_ json: JSON, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> Event {
        let event = NSEntityDescription.insertNewObject(forEntityName: "Event", into: managedObjectContext) as! Event
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
        
        event.creationTime = dateFormatter.date(from: json["creation_time"].stringValue)!
        event.identifier = json["id"].stringValue
        
        var request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Accessory")
        request.predicate = Predicate(format: "identifier = %@", json["accessory"].stringValue)
        
        let accessory: Accessory? = (try! managedObjectContext.fetch(request)).last as? Accessory
        if accessory != nil {
            event.accessory = accessory!
        }
        
        request = NSFetchRequest(entityName: "User")
        request.predicate = Predicate(format: "identifier = %@", json["user"]["id"].stringValue)
        
        let user: User? = (try! managedObjectContext.fetch(request)).last as? User
        if user != nil {
            event.user = user!
        } else {
            event.user = User.insert(json["user"], inManagedObjectContext: managedObjectContext)
        }
        
        return event
    }
}
