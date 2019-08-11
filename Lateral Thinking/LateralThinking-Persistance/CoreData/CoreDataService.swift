//
//  CoreDataService.swift
//  LateralThinking-Persistance
//
//  Created by Paul Wood on 7/27/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import Foundation
import CoreData
import Combine
import LateralThinkingCore

public let CoreDataModelName = "LateralModel"

public class CoreDataService: NSObject, CoreDataServiceType {
  
  public static let shared = CoreDataService()
  
  // injectable Container Service for test to use in memeory stores
  let persistentContainer: NSPersistentContainer
  
  // MARK: - Init
  required public init(persistentContainer: NSPersistentContainer = AppPersistentContainerBuilder.persistentContainer ) {
    self.persistentContainer = persistentContainer
    super.init()
    _ = fetchedResultsController
    self.startupCancellable = self.startup().replaceError(with: true).makeConnectable().connect()
  }
  
  lazy private var fetchedResultsController: NSFetchedResultsController<LateralMO> = {
    let sort = NSSortDescriptor(key: "body", ascending: true)
    let req: NSFetchRequest<LateralMO> = LateralMO.fetchRequest()
    req.sortDescriptors = [sort]
    req.fetchBatchSize = 500
    let moc = persistentContainer.viewContext
    let controller: NSFetchedResultsController<LateralMO> =
      NSFetchedResultsController(fetchRequest: req,
                                 managedObjectContext: moc,
                                 sectionNameKeyPath: nil,
                                 cacheName: "LateralMO")
    controller.delegate = self
    
    return controller
  }()
  
  var initialCommands: [LateralType] = InitialLateralTypes.obliques
  
  @Published var allLaterals: [LateralMO] = []
  
  @Published public var allLateralTypes: [LateralType] = []
  
  var startupCancellable: Cancellable?

  // MARK: - Startup
  public func startup() -> AnyPublisher<Bool, CoreDataError> {
    return checkForLaterals()
      .map{ commands in
        self.allLateralTypes = commands
        return true
    }.eraseToAnyPublisher()
  }
  
  func checkForLaterals() -> AnyPublisher<[LateralType], CoreDataError> {
    // Set the batch size to a suitable number.
    return Future<[LateralType], CoreDataError>.init { promise in
      do {
        try self.fetchedResultsController.performFetch()
        if let fetched = self.fetchedResultsController.fetchedObjects as NSArray? {
          let mapped = Array<LateralMO>( fetched.compactMap({ $0 as? LateralMO}) )
          self.allLaterals = mapped
          print(Set(mapped))
          print(mapped)
          let lateralType = mapped.compactMap({ lateralMO -> LateralType? in
            guard let body = lateralMO.body else{
              return nil
            }
            return LateralType(stringLiteral: body)
          })
          promise(.success(lateralType))
        } else {
          promise(.success([]))
        }
      } catch {
        promise(.failure(CoreDataError()))
      }
    }.eraseToAnyPublisher()
  }
  
  public func saveInitialToCoreData() -> AnyPublisher<[LateralType], CoreDataError> {
    let commands = self.initialCommands.map { (lateralType) -> LateralMO in
      let mom = self.persistentContainer.viewContext
      let lateralMO = LateralMO(context: mom)
      lateralMO.body = lateralType.body
      return lateralMO
    }
    self.allLaterals = commands
    self.allLateralTypes = commands.map({ (mo) -> LateralType in
      return LateralType(stringLiteral: mo.body!)
    })
    return Just<[LateralType]>(self.allLateralTypes)
      .setFailureType(to: CoreDataError.self)
      .eraseToAnyPublisher()
  }
  
  // MARK: - Create
  
  public func create(lateralType: LateralType) {
    let mom = self.persistentContainer.viewContext
    let lateralMO = LateralMO(context: mom)
    lateralMO.body = lateralType.body
  }
  
  // MARK: - Delete
  public func deleteAll() -> AnyPublisher<Void, CoreDataError> {
    return Future<Void, CoreDataError>.init { promise in
      let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: LateralMO.self))
      let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
      deleteRequest.resultType = .resultTypeObjectIDs
      let context = self.persistentContainer.viewContext
      do {
        let result = try context.execute(deleteRequest) as? NSBatchDeleteResult
        let changes: [AnyHashable: Any] = [NSDeletedObjectsKey: result?.result as? [NSManagedObjectID] ?? []]
        NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [context])
        self.allLaterals = []
        promise(.success(()))
      } catch {
        promise(.failure(CoreDataError()))
      }
    }.eraseToAnyPublisher()
  }
  
  // MARK: - Core Data Saving support
  public func saveViewContext () -> AnyPublisher<Void, CoreDataError> {
    return Future<Void, CoreDataError>.init { promise in
      let context = self.persistentContainer.viewContext
      if context.hasChanges {
        do {
          try context.save()
          promise(.success(()))
        } catch {
          promise(.failure(CoreDataError()))
        }
      }
      promise(.success(()))
    }.eraseToAnyPublisher()
  }
}

// MARK: - NSFetchedResultsControllerDelegate

extension CoreDataService: NSFetchedResultsControllerDelegate {
  
  public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                  didChangeContentWith diff: CollectionDifference<NSManagedObjectID>) {
    if let newObjects = controller.fetchedObjects as? [LateralMO] {
      allLaterals = newObjects
      allLateralTypes = newObjects.map ({ mo in
        return LateralType(stringLiteral: mo.body!)
      })
    }
  }
}
