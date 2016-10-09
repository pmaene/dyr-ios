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
        
        if !(window?.rootViewController is LoginViewController) {
            if let window = window {
                UIView.transition(
                    with: window,
                    duration: 0.5,
                    options: .transitionFlipFromLeft,
                    animations: {
                        window.rootViewController = loginViewController
                    },
                    completion: { (finished: Bool) -> () in }
                )
            }
        }
    }
    
    func OAuthClientFailed(_ notification: Notification) {
        presentLoginViewController()
    }
    
    // MARK: - UIApplicationDelegate
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.OAuthClientFailed(_:)), name: OAuthClient.NotificationNames.failed, object: nil)
        
        return true
    }
    
    // MARK: - Core Data Stack
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        let managedObjectModel = NSManagedObjectModel(contentsOf: Bundle.main.url(forResource: "Dyr", withExtension: "momd")!)
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel!)
        
        let applicationDocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last! as URL
        let store = applicationDocumentsDirectory.appendingPathComponent("Dyr.sqlite")
        
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: store, options: nil)
            
            // TODO: Check out contextQueueConcurrencyType
            var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
            
            return managedObjectContext
        } catch {
            fatalError()
        }
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
