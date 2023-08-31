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
    
    func fetchAll<T>(entity: T.Type, query: String?) -> [T]? where T : NSManagedObject {
        let items = dataStore[String(describing: entity)]?.values.compactMap{$0 as? T} ?? []
        guard let predicate =  castQueryToPredicate(with: query) else {return items}
        var result: [T] = []
        items.forEach{ item in
            guard let value = item.value(forKey: predicate.property) else {return}
          _ =  String(describing: value) == predicate.value ? result.append(item) : ()
        }
        return result
    }
    
    func deleteAll<T: NSManagedObject>(entity: T.Type)  {
        dataStore[String(describing: entity)] = nil
    }
    
    func deleteAll<T>(entity: T.Type, query: String?) where T : NSManagedObject {
        let items = dataStore[String(describing: entity)]?.values.compactMap{$0 as? T} ?? []
        guard let predicate =  castQueryToPredicate(with: query) else {return}
        items.forEach{ item in
            guard let value = item.value(forKey: predicate.property),
                  String(describing: value) == predicate.value else {return}
            dataStore[String(describing: T.self)]?[item.hashValue] = nil
        }
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

typealias Predicate = (property: String, value: String)

extension MockedCasheManager{
    func castQueryToPredicate(with value: String?) -> Predicate?{
        guard let parts = value?.split(separator: "=="), parts.count == 2 else {return nil}
        let property = String(parts.first!.trimmingCharacters(in: .whitespaces))
        let value = String(parts.last!.replacingOccurrences(of: "'", with: ""))
        return Predicate(property, value)
    }
}
