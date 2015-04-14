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
    override class func insert(json: JSON, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> Door {
        return super.insert(json, inManagedObjectContext: managedObjectContext) as! Door
    }
}
