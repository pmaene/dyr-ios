//
//  Accessory.swift
//  
//
//  Created by Pieter Maene on 14/04/15.
//
//

import Foundation
import CoreData
import SwiftyJSON

class Accessory: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var descriptionString: String
    @NSManaged var events: NSSet

    class func insert(json: JSON, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> Accessory {
        let accessory: Accessory = NSEntityDescription.insertNewObjectForEntityForName("Accessory", inManagedObjectContext: managedObjectContext)
        
        accessory.name = json["name"].stringValue
        accessory.descriptionString = json["description"].stringValue
        
        return accessory
    }
}
