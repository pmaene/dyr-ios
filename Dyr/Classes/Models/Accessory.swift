//
//  Accessory.swift
//  
//
//  Created by Pieter Maene on 14/04/15.
//  Copyright (c) 2015. All rights reserved.
//

import Foundation
import CoreData

class Accessory: NSManagedObject {
    @NSManaged var descriptionString: String
    @NSManaged var name: String
    
    @NSManaged var events: NSSet
}
