//
//  ViewController.swift
//  Dyr
//
//  Created by Pieter Maene on 08/11/14.
//  Copyright (c) 2014 Student IT vzw. All rights reserved.
//

import Alamofire
import CoreData
import SwiftyJSON
import UIKit

enum State {
    case Open
    case Closed
}

class DoorViewController: FetchedResultsTableViewController {
    @IBOutlet var toggleButton: UIBarButtonItem!
    
    private var door : Door?
    private var dataRefreshing : Bool = false
    private var state: State = State.Closed
    
    private func initDoor() {
        if let accessToken = OAuthClient.sharedClient.accessToken {
            if (accessToken.hasExpired()) {
                OAuthClient.sharedClient.refreshAccessToken()

                hideToggleButton()
                return
            }
        }
        
        let request: NSFetchRequest = NSFetchRequest(entityName: "Door")
        
        var error: NSError? = NSError?()
        let results: [Door]? = managedObjectContext!.executeFetchRequest(request, error: &error) as! [Door]?
        
        // TODO: Allow the user to select the correct door...
        if (results!.count > 1) {}
        
        door = results?.last
        
        if (door == nil) {
            hideToggleButton()
            
            Alamofire.request(DoorRouter.Doors())
                .responseSwiftyJSON {(_, _, json, error) in
                    if (error == nil) {
                        if (json.count > 0) {
                            // TODO: Figure out what to do when a user has multiple doors
                            if (json.count > 1) {}
                        
                            self.door = Door.insert(json[0], inManagedObjectContext: self.managedObjectContext!)
                        
                            self.managedObjectContext?.save(nil)
                            self.initFetchedResultsController()
                        
                            if (self.door != nil) {
                                self.title = self.door!.descriptionString
                                self.showToggleButton()
                            
                                self.getLastEvents()
                            }
                        }
                    } else {
                        NSLog("Error: \(error), \(error!.userInfo)")
                    }
            }
        } else {
            title = door!.descriptionString
            showToggleButton()
        }
    }
    
    private func initFetchedResultsController() {
        var fetchRequest: NSFetchRequest = NSFetchRequest(entityName: "Event")
        if (door != nil) {
            fetchRequest.predicate = NSPredicate(format: "accessory == %@", door!)
        }
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "creationTime", ascending: false)]

        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    private func getLastEvents() {
        if (self.dataRefreshing) {
            return
        }
        
        dataRefreshing = true
        
        Alamofire.request(EventRouter.Events(door: door!))
            .responseSwiftyJSON {(_, _, json, error) in
                if (error == nil) {
                    for (key: String, event: JSON) in json {
                        let request: NSFetchRequest = NSFetchRequest(entityName: "Event")
                        request.predicate = NSPredicate(format: "identifier = %@", event["id"].stringValue)
                        
                        if (self.managedObjectContext!.executeFetchRequest(request, error: nil)!.count == 0) {
                            Event.insert(event, inManagedObjectContext: self.managedObjectContext!)
                        }
                    }
                    
                    self.managedObjectContext?.save(nil)
                    self.dataRefreshing = false
                } else {
                    NSLog("Error: \(error), \(error!.userInfo)")
                }
            }
    }
    
    private func hideToggleButton() {
        navigationItem.setRightBarButtonItem(nil, animated: true)
    }
    
    func OAuthClientDidReceiveAccessToken(notification: NSNotification) {
        initDoor()
        initFetchedResultsController()
    }
    
    private func showToggleButton() {
        navigationItem.setRightBarButtonItem(self.toggleButton, animated: true)
    }
    
    @IBAction func toggle(sender: UIBarButtonItem) {
        Alamofire.request(DoorRouter.Switch(door: door!))
            .responseSwiftyJSON {(_, _, json, error) in
                self.getLastEvents()
                
                if (error != nil) {
                    NSLog("[\(NSStringFromClass(self.dynamicType)), \(__FUNCTION__))] Error: \(error), \(error!.userInfo)")
                }
            }
        
        if (state == State.Closed) {
            sender.image = UIImage(named: "Close")
            state = State.Open
        } else {
            sender.image = UIImage(named: "Open")
            state = State.Closed
        }
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "OAuthClientDidReceiveAccessToken:", name: OAuthClientRefreshedAccessTokenNotification, object: nil)
        
        initDoor()
        initFetchedResultsController()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if (door != nil) {
            getLastEvents()
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let event: Event = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Event
        
        var cell: EventTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("EventCell", forIndexPath: indexPath) as! EventTableViewCell
        cell.updateOutlets(event)
        
        return cell
    }
}
