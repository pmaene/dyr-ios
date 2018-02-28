//
//  Door.swift
//  
//
//  Created by Pieter Maene on 14/04/15.
//  Copyright (c) 2015. All rights reserved.
//

import Alamofire
import CoreData
import Foundation

class Door: Accessory {
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var maxDistance: Double
    
    // MARK: - Alamofire
    
    class func get(success: (([String : Any]) -> Void)?, failure: ((Error) -> Void)?) {
        Alamofire.request(DoorRouter.doors())
            .validate()
            .stream { data in
                if let dataString = String(data: data, encoding: .utf8) {
                    dataString.enumerateLines { (line, _) -> () in
                        do {
                            if let data = dataString.data(using: .utf8) {
                                guard let json = try JSONSerialization.jsonObject(with: data) as? [String : Any] else {
                                    return
                                }
                                
                                success?(json)
                            }
                        } catch let error {
                            failure?(error)
                        }
                    }
                }
        }
    }
    
    // MARK: - Core Data
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<Door> {
        return NSFetchRequest<Door>(entityName: "Door");
    }
    
    class func insert(_ json: [String : Any], in managedObjectContext: NSManagedObjectContext) -> Door? {
        guard let door = NSEntityDescription.insertNewObject(forEntityName: "Door", into: managedObjectContext) as? Door,
            let name = json["name"] as? String,
            let description = json["description"] as? String,
            let latitude = json["latitude"] as? Double,
            let longitude = json["longitude"] as? Double,
            let maxDistance = json["maxDistance"] as? Double else {
            return nil
        }
        
        door.name = name
        door.descriptionString = description
        door.latitude = latitude
        door.longitude = longitude
        door.maxDistance = maxDistance
        
        return door
    }
}
