//
//  ViewController.swift
//  Dyr
//
//  Created by Pieter Maene on 08/11/14.
//  Copyright (c) 2014 Student IT vzw. All rights reserved.
//

import Alamofire
import CoreData
import UIKit

enum State {
    case Open
    case Closed
}

class DoorViewController: FetchedResultsTableViewController {
    private var dataRefreshing : Bool = false
    var state: State = State.Closed
    
    private func initFetchedResultsController() {
        var fetchRequest: NSFetchRequest = NSFetchRequest(entityName: "Event")
        fetchRequest.predicate = NSPredicate(format: "creationTime > %@", NSDate())
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "creationTime", ascending: false)]
        
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    private func getLastEvents() {
        if (self.dataRefreshing) {
            return
        }
        
        self.dataRefreshing = true
    }
    
    @IBAction func toggle(sender: UIBarButtonItem) {
        Alamofire.request(DoorRouter.Switch(id: ""))
            .responseSwiftyJSON {(_, _, json, error) in
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
        self.initFetchedResultsController()
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let event: Event = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Event
        
        var cell: EventTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("EventCell", forIndexPath: indexPath) as! EventTableViewCell
        cell.updateOutletsWithEvent(event)
        
        return cell
    }
}
