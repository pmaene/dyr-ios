//
//  Person.swift
//  Dyr
//
//  Created by Pieter Maene on 13/11/14.
//  Copyright (c) 2014 Student IT vzw. All rights reserved.
//

import CoreData
import Foundation
import SwiftyJSON

class Person: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var events: NSSet
    @NSManaged var identifier: NSNumber
    
    class func insert(json: JSON, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> Person {
        let person: Person = NSEntityDescription.insertNewObjectForEntityForName("Person", inManagedObjectContext: managedObjectContext) as! Person
        
        person.name = json["name"].stringValue
        person.identifier = json["id"].numberValue
        
        return person
    }
}
