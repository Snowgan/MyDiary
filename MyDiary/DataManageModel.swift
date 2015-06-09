//
//  DataManageModel.swift
//  CoreLockBySwift
//
//  Created by Jennifer on 28/5/15.
//  Copyright (c) 2015 Jennifer. All rights reserved.
//

import Foundation
import CoreData

class DataManageModel {
    
    static let sharedDataManager = DataManageModel()
    
    private init() {
        
    }
    
    // MARK: - Core Data stack
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("MyDiary", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
        }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = FileDirectoryModel.searchUrlForDirectory(.DocumentDirectory).URLByAppendingPathComponent("MyDiary.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
        }()
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
        }()
    
    func saveContext () -> Bool {
        var success = false
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                NSLog("Unresolved error \(error), \(error!.userInfo)")
            } else {
                success = true
            }
        }
        return success
    }
    
    // MARK: - Data Managed Methods
    
    /**
        Fetch data for specified entity and fetch option
    
        :param: entityName Specitied entity name
        :param: option Dictionary of option for setting fetch Request. option key is a property name of NSFetchRequest class.
        :returns: Returns a array of fetched data
    */
    func fetchDataForEntityName(entityName: String, withFetchOption option: [String : AnyObject]?) -> [AnyObject]? {
        var result: [AnyObject]?
        var error: NSError?
        let fetchReq = NSFetchRequest(entityName: entityName)
        if let opt = option {
            fetchReq.settingRequestWithOption(opt)
        }
        // If no data, return an empty array
        result = managedObjectContext?.executeFetchRequest(fetchReq, error: &error)
        if result == nil {
            println("Could not fetch: \(error), \(error?.userInfo)")
        }
        return result
    }
    
    /**
        Insert new data for specified entity and attributes
    
        :param: data Dictionary of attributes name and its value
        :param: entityName Specitied entity name
        :returns: True if successfully save the data; otherwise, false
    */
    func insertData(data: [String : AnyObject?], withEntityName entityName: String) -> Bool {
        let entity = NSEntityDescription.entityForName(entityName, inManagedObjectContext: managedObjectContext!)
        let managedObj = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
        for (key, value) in data {
            managedObj.setValue(value, forKey: key)
        }
        return saveContext()
    }
    
    // update
    /**
        Update the exist data for specified entity and attributes
    
        :param: data The new data to update. Dictionary of attributes name and its value
        :param: entityName Specitied entity name
        :param: option Dictionary of fetch option for specifing which data to be updated
        :returns: True if successfully update the data; otherwise, false
    */
    func updateData(data: [String : AnyObject?], forEntityName entityName: String, withFetchOption option: [String : AnyObject]?) -> Bool {
        var result = fetchDataForEntityName(entityName, withFetchOption: option)
        if let item = result?.last as? NSManagedObject {
            for (key, value) in data {
                item.setValue(value, forKey: key)
            }
        }
        return saveContext()
    }
    
    // Delete data
    func deleteDataForEntityName(entityName: String, withFetchOption option: [String : AnyObject]?) -> Bool {
        var result = fetchDataForEntityName(entityName, withFetchOption: option)
        if let items = result {
            for item in items {
                managedObjectContext?.deleteObject(item as! NSManagedObject)
            }
            return saveContext()
        } else {
            return false
        }
    }
}

extension NSFetchRequest {
    // FIXME:
    // Setting the fetch request property, but is temporary, must optimise
    func settingRequestWithOption(option: [String : AnyObject]) {
        for key in option.keys {
            switch key {
            case "predicate":
                self.predicate = NSPredicate(format: option[key] as! String)
            case "sortDescriptors":
                self.sortDescriptors = option[key] as? Array
            default:
                break
            }
        }
    }
}

