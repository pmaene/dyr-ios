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
    @NSManaged var identifier: Int64
    
    @NSManaged var accessory: Accessory
    @NSManaged var user: User
    
    // MARK: - Core Data
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event");
    }
    
    class func insert(_ json: [String : Any], in managedObjectContext: NSManagedObjectContext) -> Event? {
        guard let event = NSEntityDescription.insertNewObject(forEntityName: "Event", into: managedObjectContext) as? Event,
            let id = json["id"] as? Int64,
            let accessory = json["accessory"] as? String,
            let user = json["user"] as? String,
            let creationTimeString = json["creation_time"] as? String, let creationTime = creationTimeString.date(format: .iso8601Auto) else {
            return nil
        }
        
        event.identifier = id
        event.creationTime = creationTime.absoluteDate
        
        var request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Accessory")
        request.predicate = NSPredicate(format: "name = %@", accessory)
        
        do {
            guard let accessory = (try managedObjectContext.fetch(request)).last as? Accessory else {
                return nil
            }
            
            event.accessory = accessory
        } catch {
            return nil
        }
        
        request = NSFetchRequest(entityName: "User")
        request.predicate = NSPredicate(format: "username = %@", user)
        
        do {
            if let user = (try managedObjectContext.fetch(request)).last as? User {
                event.user = user
            } else {
                User.get(user, success: { json in
                    do {
                        if let user = (try managedObjectContext.fetch(request)).last as? User {
                            event.user = user
                        } else {
                            guard let user = User.insert(json, in: managedObjectContext) else {
                                return
                            }
                    
                            event.user = user
                        }
                    } catch {
                        return
                    }
                }, failure: nil)
            }
        } catch {
            return nil
        }
        
        return event
    }
}
