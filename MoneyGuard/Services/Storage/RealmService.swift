//
//  RealmService.swift
//  MoneyGuard
//
//  Created by Zhenya Suharevich on 23.08.2021.
//

import Foundation

public struct BlockObject<T: Any, R: Any> {
  public let execute: ((T) -> R)
  
  public init(_ execute: @escaping ((T) -> R)) {
    self.execute = execute
  }
}

public typealias EmptyBlock = BlockObject<(), Void>

public protocol StorableProtocol: Object {
  func createRuntimeModel() -> RunTimeModelProtocol
  func getIdentifier() -> String
}

public protocol RunTimeModelProtocol {
  static func storableType() -> StorableProtocol.Type
  func convertToStorable() -> StorableProtocol
}

public protocol RealmServiceProtocol {
  func setup(version: UInt64)
  
  func addOrUpdate<T>(object: T,
                      callbackQueue: DispatchQueue,
                      completion: EmptyBlock?) where T: RunTimeModelProtocol
  
  func addOrUpdate<T>(objects: [T],
                      callbackQueue: DispatchQueue,
                      completion: EmptyBlock?) where T: RunTimeModelProtocol
  
  func remove<T>(object: T,
                 callbackQueue: DispatchQueue,
                 completion: EmptyBlock?) where T: RunTimeModelProtocol
  
  func removeAll<T>(of type: T.Type,
                    callbackQueue: DispatchQueue,
                    completion: EmptyBlock?) where T: RunTimeModelProtocol
  
  func getAll<T>(of type: T.Type,
                 callbackQueue: DispatchQueue,
                 completion: BlockObject<[T], Void>) where T: RunTimeModelProtocol
  
  func get<T>(primaryKey: Any,
              callbackQueue: DispatchQueue,
              completion: BlockObject<T?, Void>) where T: RunTimeModelProtocol
}

public extension RealmServiceProtocol {
  func addOrUpdate<T>(object: T,
                      completion: EmptyBlock?) where T: RunTimeModelProtocol {
    addOrUpdate(object: object, callbackQueue: .main, completion: completion)
  }
  
  func addOrUpdate<T>(objects: [T],
                      completion: EmptyBlock?) where T: RunTimeModelProtocol {
    addOrUpdate(objects: objects, callbackQueue: .main, completion: completion)
  }
  
  func remove<T>(object: T,
                 completion: EmptyBlock?) where T: RunTimeModelProtocol {
    remove(object: object, callbackQueue: .main, completion: completion)
  }
  
  func removeAll<T>(of type: T.Type,
                    completion: EmptyBlock?) where T: RunTimeModelProtocol {
    removeAll(of: type, callbackQueue: .main, completion: completion)
  }
  
  func getAll<T>(of type: T.Type,
                 completion: BlockObject<[T], Void>) where T: RunTimeModelProtocol {
    getAll(of: type, callbackQueue: .main, completion: completion)
  }
  
  func get<T>(primaryKey: Any,
              completion: BlockObject<T?, Void>) where T: RunTimeModelProtocol {
    get(primaryKey: primaryKey, callbackQueue: .main, completion: completion)
  }
}

final class RealmService: RealmServiceProtocol {
  static let shared = RealmService()
  
  private let queue = DispatchQueue(label: "com.sukharevich.MoneyGuard.RealmDBService.queue")
  private var realm: Realm?
  
  private init() { }
  
  func setup(version: UInt64) {
    queue.sync {
      var configuration = Realm.Configuration.defaultConfiguration
      configuration.schemaVersion = version
      realm = try! Realm(configuration: configuration, queue: queue)
    }
  }
  
  public func addOrUpdate<T>(object: T,
                             callbackQueue: DispatchQueue = .main,
                             completion: EmptyBlock? = nil) where T: RunTimeModelProtocol {
    queue.async { [weak self] in
      guard let realm = self?.realm else {
        print("realm=nil")
        return
      }
      
      do {
        try realm.write {
          autoreleasepool {
            realm.add(object.convertToStorable(), update: .modified)
            
            callbackQueue.async {
              completion?.execute(())
            }
          }
        }
      } catch let error as NSError {
        print(error)
      }
    }
  }
  
  public func addOrUpdate<T>(objects: [T],
                             callbackQueue: DispatchQueue = .main,
                             completion: EmptyBlock? = nil) where T: RunTimeModelProtocol {
    queue.async { [weak self] in
      guard let realm = self?.realm else {
        print("realm=nil")
        return
      }
      
      do {
        try realm.write {
          autoreleasepool {
            let objectsToStore = objects.map { $0.convertToStorable() }
            realm.add(objectsToStore, update: .modified)
            
            callbackQueue.async {
              completion?.execute(())
            }
          }
        }
      } catch let error as NSError {
        print(error)
      }
    }
  }
  
  public func remove<T>(object: T,
                        callbackQueue: DispatchQueue = .main,
                        completion: EmptyBlock? = nil) where T: RunTimeModelProtocol {
    queue.async { [weak self] in
      guard let realm = self?.realm else {
        print("realm=nil")
        return
      }
      
      do {
        try realm.write {
          autoreleasepool {
            let predicate = NSPredicate(format: "identifier==%@", object.convertToStorable().getIdentifier())
            if let objectToDelete = realm.objects(T.storableType().self).filter(predicate).first {
              realm.delete(objectToDelete)
              
              callbackQueue.async {
                completion?.execute(())
              }
            } else {
              print("Error: obcject for deleting doesn't exist in DataBase")
            }
          }
        }
      } catch let error as NSError {
        print(error)
      }
    }
  }
  
  public func removeAll<T>(of type: T.Type,
                           callbackQueue: DispatchQueue = .main,
                           completion: EmptyBlock? = nil) where T: RunTimeModelProtocol {
    queue.async { [weak self] in
      guard let realm = self?.realm else {
        print("realm=nil")
        return
      }
      
      autoreleasepool {
        do {
          let objects = realm.objects(type.storableType())
          
          try realm.write {
            
            realm.delete(objects)
            
            callbackQueue.async {
              completion?.execute(())
            }
          }
        } catch let error as NSError {
          print(error)
        }
      }
    }
  }
  
  public func getAll<T>(of type: T.Type,
                        callbackQueue: DispatchQueue = .main,
                        completion: BlockObject<[T], Void>) where T: RunTimeModelProtocol {
    queue.async { [weak self] in
      guard let realm = self?.realm else {
        print("realm=nil")
        return
      }
      
      autoreleasepool {
        let results = realm.objects(type.storableType()).compactMap { ($0 as? StorableProtocol)?.createRuntimeModel() }
        let array = Array(results) as? [T] ?? []
        callbackQueue.async {
          completion.execute(array)
        }
      }
    }
  }
  
  public func get<T>(primaryKey : Any,
                     callbackQueue: DispatchQueue = .main,
                     completion: BlockObject<T?, Void>) where T: RunTimeModelProtocol{
    queue.async { [weak self] in
      guard let realm = self?.realm else {
        print("realm=nil")
        return
      }
      
      autoreleasepool {
        let result = realm.object(ofType: T.storableType(), forPrimaryKey: primaryKey) as? StorableProtocol
        let runtimeModel = result?.createRuntimeModel() as? T
        
        callbackQueue.async {
          completion.execute(runtimeModel)
        }
      }
    }
  }
}
