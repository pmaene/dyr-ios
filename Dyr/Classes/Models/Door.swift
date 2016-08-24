//
//  Door.swift
//  
//
//  Created by Pieter Maene on 14/04/15.
//  Copyright (c) 2015. All rights reserved.
//

import CoreData
import Foundation

class Door: Accessory {
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var maxDistance: Double
    
    class func insert(_ json: [String: Any], inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> Door? {
        let door = NSEntityDescription.insertNewObject(forEntityName: "Door", into: managedObjectContext) as! Door
        
        guard let id = json["id"] as? String,
            let name = json["name"] as? String,
            let description = json["description"] as? String,
            let latitude = json["latitude"] as? Double,
            let longitude = json["longitude"] as? Double,
            let maxDistance = json["maxDistance"] as? Double
        else {
            return nil
        }
        
        door.identifier = id
        door.name = name
        door.descriptionString = description
        door.latitude = latitude
        door.longitude = longitude
        door.maxDistance = maxDistance
        
        return door
    }
}
