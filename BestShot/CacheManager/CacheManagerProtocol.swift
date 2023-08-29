//
//  CacheManagerProtocol.swift
//  BestShot
//
//  Created by Mohannad on 29/08/2023.
//

import Foundation
import CoreData

protocol CacheManagerProtocol {
    func add<T:NSManagedObject , S: AnyObject> (info : S , entity : T.Type)
    func fetchAll<T:NSManagedObject>(entity : T.Type) -> [T]?
    func deleteAll<T:NSManagedObject>(entity : T.Type)
    func delete<T:NSManagedObject>(entity : T)
    func recordsCount<T:NSManagedObject>(entity : T.Type) -> Int
    func setup(completion:(() ->Void)?)
}
