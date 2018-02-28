//
//  AppDelegate.swift
//  Dyr
//
//  Created by Pieter Maene on 08/11/14.
//  Copyright (c) 2014. All rights reserved.
//

import CoreData
import Foundation
import SwiftDate
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    private func presentLoginViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        if let window = window, !(window.rootViewController is LoginViewController) {
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
    
    func JWTClientFailed(_ notification: Notification) {
        presentLoginViewController()
    }
    
    // MARK: - UIApplicationDelegate
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        Date.setDefaultRegion(Region(tz: NSTimeZone.local, cal: .current, loc: .current))
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.JWTClientFailed(_:)), name: JWTClient.NotificationNames.failed, object: nil)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        do {
            guard let managedObjectContext = managedObjectContext else {
                return
            }
            
            try managedObjectContext.save()
        } catch {
            // TODO: Error
            fatalError()
        }
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
}
