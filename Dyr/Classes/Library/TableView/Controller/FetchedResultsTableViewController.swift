//
//  FetchedResultsTableViewController.swift
//  Dyr
//
//  Created by Pieter Maene on 13/11/14.
//  Copyright (c) 2014. All rights reserved.
//

import CoreData
import Foundation
import UIKit

class FetchedResultsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    var managedObjectContext: NSManagedObjectContext? {
        let appDelegate = UIApplication.shared().delegate as! AppDelegate
        return appDelegate.managedObjectContext
    }
    
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = NSFetchedResultsController() {
        didSet {
            self.initFetchedResultsController()
        }
    }
    
    private func initFetchedResultsController() {
        self.fetchedResultsController.delegate = self
        self.performFetch()
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func performFetch() {
        do {
            try self.fetchedResultsController.performFetch()
        } catch let error as NSError? {
            fatalError("[\(String(self)), \(#function))] Error: \(error), \(error!.userInfo)")
        }
        
        self.tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections!.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows: Int = 0
        if self.fetchedResultsController.sections!.count > 0 {
            let sectionInfo = self.fetchedResultsController.sections![section] as NSFetchedResultsSectionInfo
            rows = sectionInfo.numberOfObjects
        }
        
        return rows
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionInfo = self.fetchedResultsController.sections![section] as NSFetchedResultsSectionInfo
        return sectionInfo.name
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
            case NSFetchedResultsChangeType.insert:
                self.tableView.insertSections(indexSet, with: UITableViewRowAnimation.fade)
            case NSFetchedResultsChangeType.delete:
                self.tableView.deleteSections(indexSet, with: UITableViewRowAnimation.fade)
            case NSFetchedResultsChangeType.update:
                break
            case NSFetchedResultsChangeType.move:
                break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: AnyObject, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
            case NSFetchedResultsChangeType.insert:
                self.tableView.insertRows(at: [newIndexPath!], with: UITableViewRowAnimation.fade)
            case NSFetchedResultsChangeType.delete:
                self.tableView.deleteRows(at: [indexPath!], with: UITableViewRowAnimation.fade)
            case NSFetchedResultsChangeType.update:
                self.tableView.reloadRows(at: [indexPath!], with: UITableViewRowAnimation.fade)
            case NSFetchedResultsChangeType.move:
                self.tableView.deleteRows(at: [indexPath!], with: UITableViewRowAnimation.fade)
                self.tableView.insertRows(at: [newIndexPath!], with: UITableViewRowAnimation.fade)
        }
    }
}
