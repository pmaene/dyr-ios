//
//  ViewController.swift
//  Dyr
//
//  Created by Pieter Maene on 08/11/14.
//  Copyright (c) 2014. All rights reserved.
//

import Alamofire
import CoreData
import CoreLocation
import SwiftyJSON
import UIKit

enum State {
    case Open
    case Closed
}

class DoorViewController: FetchedResultsTableViewController, CLLocationManagerDelegate {
    @IBOutlet var toggleButton: UIBarButtonItem!
    
    private var door: Door?
    private var dataRefreshing = false
    private var locationManager: CLLocationManager?
    private var state = State.Closed
    
    private func initDoor() {
        let request = NSFetchRequest(entityName: "Door")
        
        var results: [Door]
        do {
            results = try managedObjectContext!.executeFetchRequest(request) as! [Door]
        } catch let error as NSError? {
            fatalError("[\(String(self)), \(#function))] Error: \(error), \(error!.userInfo)")
        }
            
        // TODO: Allow the user to select the correct door...
        if results.count > 1 {}
            
        door = results.last
            
        if door == nil {
            Alamofire.request(DoorRouter.Doors())
                .responseSwiftyJSON({(_, _, json, error) in
                    if error == nil {
                        if json.count > 0 {
                            // TODO: Figure out what to do when a user has multiple doors
                            if json.count > 1 {}
                            
                            self.door = Door.insert(json[0], inManagedObjectContext: self.managedObjectContext!)
                            
                            try! self.managedObjectContext?.save()
                            self.initFetchedResultsController()
                                    
                            if self.door != nil {
                                self.title = self.door!.descriptionString
                                self.getLastEvents()
                            }
                        }
                    } else {
                        NSLog("[\(String(self)), \(#function))] Error: \(error), \((error as? NSError)!.userInfo)")
                    }
                })
        } else {
            title = door!.descriptionString
        }
    }
    
    private func initFetchedResultsController() {
        let fetchRequest = NSFetchRequest(entityName: "Event")
        if door != nil {
            fetchRequest.predicate = NSPredicate(format: "accessory == %@", door!)
        }
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "creationTime", ascending: false)]

        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    private func initLocationManager() {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus == .Restricted || authorizationStatus == .Denied {
            return
        }

        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        
        if authorizationStatus == .NotDetermined {
            locationManager?.requestWhenInUseAuthorization()
        }
        
        locationManager?.startUpdatingLocation()
    }
    
    private func getLastEvents() {
        if self.dataRefreshing {
            return
        }
        
        dataRefreshing = true
        
        Alamofire.request(EventRouter.Events(door: door!))
            .responseSwiftyJSON({(_, _, json, error) in
                if error == nil {
                    for (_, event): (String, JSON) in json {
                        let request = NSFetchRequest(entityName: "Event")
                        request.predicate = NSPredicate(format: "identifier = %@", event["id"].stringValue)
                        
                        let results = try! self.managedObjectContext!.executeFetchRequest(request) as! [Event]
                        if results.count == 0 {
                            Event.insert(event, inManagedObjectContext: self.managedObjectContext!)
                        }
                    }
                    
                    try! self.managedObjectContext?.save()
                    
                    self.dataRefreshing = false
                } else {
                    NSLog("[\(String(self)), \(#function))] Error: \(error), \((error as? NSError)!.userInfo)")
                }
            })
    }
    
    private func enableToggleButton() {
        navigationItem.rightBarButtonItem?.enabled = true
    }
    
    private func disableToggleButton() {
        navigationItem.rightBarButtonItem?.enabled = false
    }
    
    @IBAction func toggle(sender: UIBarButtonItem) {
        Alamofire.request(DoorRouter.Switch(door: door!))
            .responseSwiftyJSON({(_, _, json, error) in
                self.getLastEvents()
                
                if error != nil {
                    NSLog("[\(String(self)), \(#function))] Error: \(error), \((error as? NSError)!.userInfo)")
                }
            })
        
        if state == State.Closed {
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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DoorViewController.OAuthClientDidRefreshAccessToken(_:)), name: OAuthClientRefreshedAccessTokenNotification, object: nil)
        
        initDoor()
        initFetchedResultsController()
        initLocationManager()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if door != nil {
            getLastEvents()
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let event = fetchedResultsController.objectAtIndexPath(indexPath) as! Event
        let cell = tableView.dequeueReusableCellWithIdentifier("EventCell", forIndexPath: indexPath) as! EventTableViewCell
        cell.updateOutlets(event)
        
        return cell
    }
    
    // MARK: - OAuthClient
    
    func OAuthClientDidRefreshAccessToken(notification: NSNotification) {
        initDoor()
        initFetchedResultsController()
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if door != nil {
            let currentLocation = locations.last
            let doorLocation = CLLocation.init(latitude: door!.latitude, longitude: door!.longitude)
            
            print(currentLocation?.distanceFromLocation(doorLocation))
            if currentLocation?.distanceFromLocation(doorLocation) < door!.maxDistance {
                enableToggleButton()
            } else {
                disableToggleButton()
            }
        }
    }
}
