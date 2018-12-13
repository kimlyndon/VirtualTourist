//
//  DataController.swift
//  VirtualTourist
//
//  Created by Kim Lyndon on 12/13/18.
//  Copyright © 2018 Kim Lyndon. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    
    let persistentContainer: NSPersistentContainer
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    var backgroundContext: NSManagedObjectContext!
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func configureContexts() {
        backgroundContext = persistentContainer.newBackgroundContext()
        
        viewContext.automaticallyMergesChangesFromParent = true
        backgroundContext.automaticallyMergesChangesFromParent = true
        
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
        backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { NSPersistentStoreDescription, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            self.autoSaveViewContext()
            self.configureContexts()
            completion?()
        }
        
        func save() {
            if viewContext.hasChanges {
                do {
                    try viewContext.save()
                } catch {
                    print("Unable to save changes")
                }
        }
     }
  }
}

//Mark: Autosave function
    extension DataController {
        func autoSaveViewContext(interval: TimeInterval = 30) {
            print("autosaving")
            guard interval > 0 else {
                print("Can't autosave on negative interval")
                return
            }
            
            if viewContext.hasChanges {
                do {
                    try viewContext.save()
                } catch {
                    print("Unable to autosave changes")
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + interval, execute: {(
                self.autoSaveViewContext(interval: interval)
                )})
        }
}

// MARK: - Background processing
// Outside help from Bruce Bookman.
extension DataController {
    
    typealias Batch = (_ workerContext: NSManagedObjectContext) -> ()
    
    func performBackgroundOperation(_ batch: @escaping Batch) {
        
        backgroundContext.perform() {
            
            batch(self.backgroundContext)
            
            do {
                try self.backgroundContext.save()
            } catch {
                fatalError("Error while saving backgroundContext: \(error)")
            }
        }
    }
}

