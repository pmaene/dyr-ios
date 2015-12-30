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
        let loginViewController = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        
        window?.rootViewController = loginViewController
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let accessToken: OAuthAccessToken? = OAuthClient.sharedClient.accessToken
        if (accessToken == nil) {
            presentLoginViewController()
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "OAuthClientFailed:", name: OAuthClientFailedNotification, object: nil)
        
        return true
    }
    
    func OAuthClientFailed(notification: NSNotification) {
        presentLoginViewController()
    }
    
    // MARK: - Core Data Stack
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        let managedObjectModel = NSManagedObjectModel(contentsOfURL: NSBundle.mainBundle().URLForResource("Dyr", withExtension: "momd")!)
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel!)
        
        let applicationDocumentsDirectory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last! as NSURL
        let storeURL = applicationDocumentsDirectory.URLByAppendingPathComponent("Dyr.sqlite")
        
        var error: NSError? = nil
        
        var store: NSPersistentStore?
        do {
            store = try persistentStoreCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)
        } catch var error as NSError {
            store = nil
            
            NSLog("Error: \(error)")
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
                if (managedObjectContext.hasChanges) {
                    try managedObjectContext.save()
                }
            } catch {
                fatalError()
            }
        }
    }
}
