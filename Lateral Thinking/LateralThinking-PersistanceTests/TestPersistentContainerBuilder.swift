//
//  TestPersistentContainerBuilder.swift
//  LateralThinking-PersistanceTests
//
//  Created by Paul Wood on 8/10/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import CoreData
@testable import LateralThinking_Persistance

/// Just a Holder for a persistentContainer that is lazily loaded
class TestPersistentContainer {
  lazy var persistentContainer: NSPersistentContainer = {
    let bundle = Bundle(for: CoreDataService.self)
    let modelURL = bundle.url(forResource: CoreDataModelName, withExtension: "momd")!
    let mom = NSManagedObjectModel(contentsOf: modelURL)!
    let container = NSPersistentContainer(name: "LateralModel",
                                          managedObjectModel: mom)
    let description = container.persistentStoreDescriptions.first!
    description.url = URL(fileURLWithPath: "/dev/null")
    try! container.persistentStoreCoordinator
      .destroyPersistentStore(at: URL(fileURLWithPath: "/dev/null"),
                              ofType: NSSQLiteStoreType,
                              options: [:])
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    
    return container
  }()
}
