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
    @NSManaged var descriptionString: String
    @NSManaged var identifier: String
    @NSManaged var name: String
    
    @NSManaged var events: NSSet
}
