//
//  Door.swift
//  
//
//  Created by Pieter Maene on 14/04/15.
//
//

import CoreData
import Foundation
import SwiftyJSON

class Door: Accessory {
    class func insert(json: JSON, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> Door {
        let door: Door = NSEntityDescription.insertNewObjectForEntityForName("Door", inManagedObjectContext: managedObjectContext) as! Door
        
        door.identifier = json["id"].stringValue
        door.name = json["name"].stringValue
        door.descriptionString = json["description"].stringValue
        
        return door
    }
}
