//
//  MockedCasheManager.swift
//  BestShotTests
//
//  Created by Mohannad on 30/08/2023.
//

import XCTest
import CoreData
@testable import BestShot

/* MockedCasheManager is going to leverage the power of
 the dictionary data structure, Using it as a DataBase*/

class MockedCasheManager: CacheManagerProtocol{
  
    private var dataStore : [String: [Int: NSManagedObject]]
    /*This ObjectContext won't be used to store objects, it functions only to facilitate initializing NSManagedObject */
    var testContext: NSManagedObjectContext = {
        let container = NSPersistentContainer(name: DefaultSettings.modelName)
        let description = NSPersistentStoreDescription()
        description.type = StorageType.memory
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Failed to load store for test: \(error)")
            }
        }
        return container.newBackgroundContext()
    }()
    

    init() {
        self.dataStore = [:]
    }
    
    func add<T: NSManagedObject, S: AnyObject>(info: S, entity: T.Type)   {
        let description = NSEntityDescription.entity(forEntityName: entity.description(), in: testContext)
        let item = NSManagedObject.init(entity: description!, insertInto: nil)
        item.populate(with: info)
        dataStore[String(describing: entity), default: [:]][item.hashValue] = item
    }
    
    func fetchAll<T: NSManagedObject>(entity: T.Type) -> [T]? {
        return dataStore[String(describing: entity)]?.values.compactMap{$0 as? T}
    }
    
    func deleteAll<T: NSManagedObject>(entity: T.Type)  {
        dataStore[String(describing: entity)] = nil
    }
    
    func delete<T>(entity: T) where T : NSManagedObject {
        dataStore[String(describing: T.self)]?[entity.hashValue] = nil
    }
    
    func recordsCount<T: NSManagedObject>(entity: T.Type) -> Int   {
         dataStore[String(describing: entity)]?.count ?? 0
    }
    
    func setup(completion: (() -> Void)?) {

    }    
}

