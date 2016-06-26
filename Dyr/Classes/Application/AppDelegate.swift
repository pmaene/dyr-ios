//
//  AppDelegate.swift
//  Dyr
//
//  Created by Pieter Maene on 08/11/14.
//  Copyright (c) 2014. All rights reserved.
//

import CoreData
import Foundation
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    private func presentLoginViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        window?.rootViewController = loginViewController
    }
    
    func OAuthClientFailed(_ notification: Notification) {
        presentLoginViewController()
    }
    
    // MARK: - UIApplicationDelegate
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        NotificationCenter.default().addObserver(self, selector: #selector(AppDelegate.OAuthClientFailed(_:)), name: OAuthClientFailedNotification, object: nil)
        
        return true
    }
    
    // MARK: - Core Data Stack
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        let managedObjectModel = NSManagedObjectModel(contentsOf: Bundle.main().urlForResource("Dyr", withExtension: "momd")!)
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel!)
        
        let applicationDocumentsDirectory = FileManager.default().urlsForDirectory(.documentDirectory, inDomains: .userDomainMask).last! as URL
        let storeURL = try! applicationDocumentsDirectory.appendingPathComponent("Dyr.sqlite")
        
        var error: NSError? = nil
        
        var store: NSPersistentStore?
        do {
            store = try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
        } catch var error as NSError {
            store = nil
            
            NSLog("[\(String(self)), \(#function))] Error: \(error), \(error.userInfo)")
            abort()
        } catch {
            fatalError()
        }
        
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        return managedObjectContext
    }()
    
    func saveContext () {
        if let managedObjectContext = self.managedObjectContext {
            do {
                if managedObjectContext.hasChanges {
                    try managedObjectContext.save()
                }
            } catch {
                fatalError()
            }
        }
    }
}
