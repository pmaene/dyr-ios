//
//  Person.swift
//  Dyr
//
//  Created by Pieter Maene on 13/11/14.
//  Copyright (c) 2014 Student IT vzw. All rights reserved.
//

import CoreData

class Person: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var events: NSSet
    @NSManaged var identifier: NSNumber
    
    func personWithJsonData(jsonData: NSDictionary, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> Person {
        var person: Person = Person()
        return person
    }
}
