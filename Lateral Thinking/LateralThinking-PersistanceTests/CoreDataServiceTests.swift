//
//  LateralTypeTests.swift
//  Lateral Thinking CoreTests
//
//  Created by Paul Wood on 7/23/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import XCTest
import Combine
import Entwine
import EntwineTest
import CoreData
import LateralThinkingCore
@testable import LateralThinking_Persistance

class CoreDataServiceTests: XCTestCase {
  
  var sut: CoreDataService!
  
  func testIsEmptyOnInit() {
    let testScheduler = TestScheduler(initialClock: 0)
    
    sut = CoreDataService()
    sut.persistentContainer = TestPersistentContainer().persistentContainer
    
    let results = testScheduler.start {
      self.sut
        .checkForLaterals()
        .map{return $0.count > 0}
    }
    
    XCTAssertEqual(results.recordedOutput, [
      (200, .subscription),
      (200, .input(false)),
      (200, .completion(.finished))
    ])
  }
  
  func testIsLoadsFromDiskWhenStartup() {
    
    let testScheduler = TestScheduler(initialClock: 0)
    
    sut = CoreDataService()
    let testContainer = TestPersistentContainer()
    sut.persistentContainer = testContainer.persistentContainer
    let moc = testContainer.persistentContainer.viewContext
    
    let mo = LateralMO(context: moc)
    mo.body = InitialLateralTypes.obliques[0].body
    try! sut.persistentContainer.viewContext.save()
    
    let results = testScheduler.start {
      self.sut
        .checkForLaterals()
        .map{return $0.count == 1}
    }
    
    XCTAssertEqual(results.recordedOutput, [
      (200, .subscription),
      (200, .input(true)),
      (200, .completion(.finished))
    ])
  }
  
  func testInitialCommandsAdded() {
    let testScheduler = TestScheduler(initialClock: 0)
    
    sut = CoreDataService()
    let testContainer = TestPersistentContainer()
    sut.persistentContainer = testContainer.persistentContainer
    
    // schedules a subscription at 200, to be cancelled at 900
    let results: TestableSubscriber<Bool, CoreDataError> = testScheduler.start {
      self.sut.startup()
    }
    let expected: TestSequence<Bool, CoreDataError> = [
      (200, .subscription),
      (200, .input(true)),
      (200, .completion(.finished)),
    ]
    let res: TestSequence<Bool, CoreDataError> = results.recordedOutput
    XCTAssertEqual(res, expected)
  }
  
  func testDeleteAllCommandsAdded() {
    let testScheduler = TestScheduler(initialClock: 0)
    
    sut = CoreDataService()
    let testContainer = TestPersistentContainer()
    sut.persistentContainer = testContainer.persistentContainer
    let testLateral = InitialLateralTypes.obliques[1]
    let mo = LateralMO(context: testContainer.persistentContainer.viewContext)
    mo.body = testLateral.body
    try! sut.persistentContainer.viewContext.save()
    
    /*TestableSubscriber<[Command], Never>*/
    let _: TestableSubscriber<Void, CoreDataError> = testScheduler.start { () -> AnyPublisher<Void, CoreDataError> in
      
      let startupToDelete: AnyPublisher<Void, CoreDataError> =
        self.sut.startup().map { _ in
          XCTAssertEqual(self.sut.allLaterals.count, 1)
          XCTAssertNotNil(self.sut.allLaterals.first?.body ?? nil)
          XCTAssertEqual(self.sut.allLaterals.first?.body ?? "NOT",
                         testLateral.body)
        }.flatMap { _ in
          return self.sut.deleteAll()
        }.eraseToAnyPublisher()
      
      return startupToDelete
    }
    
    XCTAssertEqual(sut.allLaterals.count, 0)
  }
  
  func testSaveInitialToCoreData() {
    let testScheduler = TestScheduler(initialClock: 0)
    sut = CoreDataService()
    let testContainer = TestPersistentContainer()
    sut.persistentContainer = testContainer.persistentContainer
    let sorter = NSSortDescriptor(key: "body", ascending: true)
    let results = testScheduler.start {
      self.sut.startup()
        .flatMap({ _ in
          self.sut.saveInitialToCoreData()
        }).flatMap { _ in
          self.sut.$allLateralTypes
            .map({ lats in
              return lats.count
//              return lats.map({ return $0.body })
            }).setFailureType(to: CoreDataError.self)
      }
    }
        
//    let allLaterals = InitialLateralTypes.obliques
//      .sorted()
//      .map { lat -> String in
//        return lat.body
//      }
    
    let expected: TestSequence<Int, CoreDataError> = [
      (200, .subscription),
      (200, .input(114)),
//      (200, .input(allLaterals)),
    ]
    XCTAssertEqual(results.recordedOutput, expected)
  }
  
  func testCreate() {
    let testScheduler = TestScheduler(initialClock: 0)
    sut = CoreDataService()
    let testContainer = TestPersistentContainer()
    sut.persistentContainer = testContainer.persistentContainer
    let testLateral = InitialLateralTypes.obliques[2]
    
    let results = testScheduler.start {
      self.sut.startup()
        .flatMap({ _ -> AnyPublisher<Bool, CoreDataError> in
          self.sut.create(lateralType: testLateral)
          return Just(true)
            .setFailureType(to: CoreDataError.self)
            .eraseToAnyPublisher()
        })
    }
    
    let expected: TestSequence<Bool, CoreDataError> = [
      (200, .subscription),
      (200, .input(true)),
      (200, .completion(.finished)),
    ]
    XCTAssertEqual(results.recordedOutput, expected)
  }
  
  static var allTests = [
    ("testCreate", testCreate),
    ("testSaveInitialToCoreData", testSaveInitialToCoreData),
    ("testDeleteAllCommandsAdded", testDeleteAllCommandsAdded),
    ("testInitialCommandsAdded", testInitialCommandsAdded),
    ("testIsLoadsFromDiskWhenStartup", testIsLoadsFromDiskWhenStartup),
    ("testIsEmptyOnInit", testIsEmptyOnInit),
  ]
  
}

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

