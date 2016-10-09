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
import UIKit

enum State {
    case open
    case closed
}

class DoorViewController: FetchedResultsTableViewController, CLLocationManagerDelegate {
    @IBOutlet var toggleButton: UIBarButtonItem!
    
    private var door: Door?
    private var dataRefreshing = false
    private var locationManager: CLLocationManager?
    private var state = State.closed
    
    private func initDoor() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Door")
        
        do {
            let results = try managedObjectContext!.fetch(request) as! [Door]
            
            // TODO: Allow the user to select the correct door...
            if results.count > 1 {}
            
            door = results.last
            
            if door == nil {
                Alamofire.request(DoorRouter.doors())
                    .responseJSON { response in
                        switch response.result {
                        case .success:
                            if let json = response.result.value as? [[String: Any]] {
                                // TODO: Figure out what to do when a user has multiple doors
                                if json.count > 1 {}
                                
                                self.door = Door.insert(json[0], inManagedObjectContext: self.managedObjectContext!)
                                
                                do {
                                    try self.managedObjectContext?.save()
                                    self.initFetchedResultsController()
                                    
                                    if self.door != nil {
                                        self.title = self.door!.descriptionString
                                        self.getLastEvents()
                                    }
                                } catch {
                                    fatalError()
                                }
                            }
                            
                        case .failure:
                            // TODO: Post notification and show banner
                            if OAuthAccessToken.unarchive() != nil {
                                fatalError()
                            }
                        }
                    }
            } else {
                title = door!.descriptionString
            }
        } catch {
            fatalError()
        }
    }
    
    private func initFetchedResultsController() {
        if let door = door {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Event")
            fetchRequest.predicate = NSPredicate(format: "accessory == %@", door)
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "creationTime", ascending: false)]
            
            self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        }
    }
    
    private func initLocationManager() {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus == .restricted || authorizationStatus == .denied {
            return
        }

        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        
        if authorizationStatus == .notDetermined {
            locationManager?.requestWhenInUseAuthorization()
        }
        
        locationManager?.startUpdatingLocation()
    }
    
    private func getLastEvents() {
        if self.dataRefreshing {
            return
        }
        
        dataRefreshing = true
        
        Alamofire.request(EventRouter.events(door: door!))
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let json = response.result.value as? [[String: Any]] {
                        for event in json {
                            if let id = event["id"] as? String {
                                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Event")
                                request.predicate = NSPredicate(format: "identifier = %@", id)
                
                                if let results = try! self.managedObjectContext!.fetch(request) as? [Event], results.count == 0 {
                                    // TODO: Verify whether insert returned nil
                                    _ = Event.insert(event, inManagedObjectContext: self.managedObjectContext!)
                                }
                            }
                        }
                
                        do {
                            try self.managedObjectContext?.save()
                            self.dataRefreshing = false
                        } catch {
                            fatalError()
                        }
                    }
                    
                case .failure:
                    // TODO: Post notification and show banner
                    if OAuthAccessToken.unarchive() != nil {
                        fatalError()
                    }
                }
            }
    }
    
    private func enableToggleButton() {
        if OAuthClient.sharedClient.accessToken != nil {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    private func disableToggleButton() {
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @IBAction func toggle(_ sender: UIBarButtonItem) {        
        Alamofire.request(DoorRouter.switch(door: door!))
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let json = response.result.value as? [String: Any] {
                        if let error = json["error"] as? String, error.isEmpty {
                            self.getLastEvents()
                        }
                    }
                    
                case .failure:
                    // TODO: Post notification and show banner
                    if OAuthAccessToken.unarchive() != nil {
                        fatalError()
                    }
                }
            }
        
        if state == State.closed {
            sender.image = UIImage(named: "Close")
            state = State.open
        } else {
            sender.image = UIImage(named: "Open")
            state = State.closed
        }
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(DoorViewController.OAuthClientDidRefreshAccessToken(_:)), name: OAuthClient.NotificationNames.refreshedAcessToken, object: nil)
        
        initDoor()
        initFetchedResultsController()
        initLocationManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        disableToggleButton()
        if door != nil {
            getLastEvents()
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = fetchedResultsController.object(at: indexPath) as! Event
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventTableViewCell
        cell.updateOutlets(event)
        
        return cell
    }
    
    // MARK: - OAuthClient
    
    func OAuthClientDidRefreshAccessToken(_ notification: Notification) {
        initDoor()
        initFetchedResultsController()
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if door != nil {
            if let currentLocation = locations.last {
                let doorLocation = CLLocation.init(latitude: door!.latitude, longitude: door!.longitude)
            
                if currentLocation.distance(from: doorLocation) < door!.maxDistance {
                    enableToggleButton()
                } else {
                    disableToggleButton()
                }
            }
        }
    }
}
