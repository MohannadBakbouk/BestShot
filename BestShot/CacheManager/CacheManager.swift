//
//  CacheManager.swift
//  BestShot
//
//  Created by Mohannad on 29/08/2023.
//

import Foundation
import CoreData
import class UIKit.UIApplication

final class CacheManager {
    
    private let modelName : String
    private let storageType : String
    
    private lazy var managedObjectModel : NSManagedObjectModel! = {
        guard let modelURL = Bundle.init(identifier: DefaultSettings.modelBundleIdentifier)?.url(forResource: modelName, withExtension:"momd") else {
            print("Error loading model from bundle")
            return nil
        }
        guard let managedModel = NSManagedObjectModel(contentsOf: modelURL) else {
            print("Error initializing NSManagedObjectModel ")
            return nil
        }
        return managedModel
    }()
    
    private lazy var persistenContainer : NSPersistentContainer! = {
        guard let modelManaged = managedObjectModel else {return nil}
        let container = NSPersistentContainer(name: modelName , managedObjectModel: managedObjectModel)
        let description = container.persistentStoreDescriptions.first
        description?.type = storageType
        return container
    }()
    
    lazy var backgroundContext : NSManagedObjectContext = {
        let context = self.persistenContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }()
    
    lazy var mainContext : NSManagedObjectContext = {
        let context = self.persistenContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        return context
    }()
    
    init(modelName : String , storageType : String = StorageType.disk) {
        self.modelName = modelName
        self.storageType = storageType
    }
    
    func loadPersistentStore(completion: (() -> Void)? = nil){
        persistenContainer.loadPersistentStores { description, error in
            guard error == nil else {return}
            completion?()
        }
    }
    
    @objc func saveChanges(){
        if backgroundContext.hasChanges {
            do{
                try backgroundContext.save()
            }
            catch{
               print("error occured while trying save data")
            }
        }
    }
    
    private func setupNotifications(){
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector : #selector(saveChanges), name: UIApplication.willResignActiveNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(saveChanges), name: UIApplication.willTerminateNotification, object: nil)
    }
    
    func setup(completion: (() -> Void)? = nil){
        loadPersistentStore {
            completion?()
        }
    }
 }

extension CacheManager : CacheManagerProtocol {

    func add<T, S>(info: S, entity: T.Type) where T : NSManagedObject, S : AnyObject {
         backgroundContext.perform {[weak self] in
             guard let self = self else {return}
             let item = T.init(context: self.backgroundContext)
             item.populate(with: info)
             self.saveChanges()
         }
     }
     
    func fetchAll<T>(entity: T.Type , query: String? = nil) -> [T]? where T : NSManagedObject {
         var results : [T]? = nil
         let entityName = String(describing: T.self)
         let request = NSFetchRequest<T>(entityName: entityName)
         request.predicate = query != nil ? NSPredicate(format: query!) : nil
         request.sortDescriptors = []
         backgroundContext.performAndWait {
             results = try? request.execute()
         }
         return results
     }
    
    func fetchAll<T>(entity: T.Type) -> [T]? where T : NSManagedObject {
        return fetchAll(entity: entity, query: nil)
    }
    
    func deleteAll<T>(entity: T.Type, query: String?) where T : NSManagedObject {
        let entityName = String(describing: T.self)
        let request  = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.predicate = query != nil ? NSPredicate(format: query!) : nil
        request.sortDescriptors = []
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        _ = try? backgroundContext.execute(deleteRequest)
    }

     func deleteAll<T>(entity: T.Type) where T : NSManagedObject {
        deleteAll(entity: entity, query: nil)
     }
    
      func delete<T>(entity: T) where T : NSManagedObject {
         backgroundContext.performAndWait {[weak self] in
             self?.backgroundContext.delete(entity)
             try? self?.backgroundContext.save()
         }
     }
     
     func recordsCount<T>(entity: T.Type) -> Int where T : NSManagedObject {
         var count = 0
         backgroundContext.performAndWait {
             let entityName = String(describing: T.self)
             let request  = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
             request.sortDescriptors = []
             let results = try? request.execute()
             count = results?.count ?? count
         }
         return count
     }
}

