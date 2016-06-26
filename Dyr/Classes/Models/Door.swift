//
//  Door.swift
//  
//
//  Created by Pieter Maene on 14/04/15.
//  Copyright (c) 2015. All rights reserved.
//

import CoreData
import Foundation
import SwiftyJSON

class Door: Accessory {
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var maxDistance: Double
    
    class func insert(_ json: JSON, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> Door {
        let door = NSEntityDescription.insertNewObject(forEntityName: "Door", into: managedObjectContext) as! Door
        
        door.identifier = json["id"].stringValue
        door.name = json["name"].stringValue
        door.descriptionString = json["description"].stringValue
        
        door.latitude = json["latitude"].doubleValue
        door.longitude = json["longitude"].doubleValue
        door.maxDistance = json["maxDistance"].doubleValue
        
        return door
    }
}
