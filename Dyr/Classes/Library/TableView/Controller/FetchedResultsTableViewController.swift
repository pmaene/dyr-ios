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
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            return appDelegate.managedObjectContext
        }
        
        return nil
    }
    
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = NSFetchedResultsController() {
        didSet {
            fetchedResultsController.delegate = self
            performFetch()
        }
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
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
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
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
    
    func performFetch() {
        do {
            try fetchedResultsController.performFetch()
            tableView.reloadData()
        } catch {
            fatalError()
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = fetchedResultsController.sections else {
            return 0
        }
        
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 0
        if let sections = fetchedResultsController.sections, sections.count > 0 {
            if let sections = self.fetchedResultsController.sections {
                rows = (sections[section] as NSFetchedResultsSectionInfo).numberOfObjects
            }
        }
        
        return rows
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sections = fetchedResultsController.sections else {
            return nil
        }
        
        return (sections[section] as NSFetchedResultsSectionInfo).name
    }
}
