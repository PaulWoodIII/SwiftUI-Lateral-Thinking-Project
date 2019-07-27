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
@testable import LateralThinking_Persistance

class CoreDataServiceTests: XCTestCase {
  
  var sut: CoreDataService!
  
  func testIsEmptyOnInit() {
    let testScheduler = TestScheduler(initialClock: 0)
    
    sut = CoreDataService()
    sut.persistentContainer = TestPersistentContainer().persistentContainer
    
    // schedules a subscription at 200, to be cancelled at 900
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
    
    _ = LateralMO.create(moc, lateralType: InitialLateralTypes.obliques[0])
    try! sut.persistentContainer.viewContext.save()
    
    let results = testScheduler.start {
      self.sut
        .checkForLaterals()
        .map{return $0.count > 0}
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
    let results: TestableSubscriber<Bool, CoreDataService.Error> = testScheduler.start {
      self.sut.startup()
    }
    let expected: TestSequence<Bool, CoreDataService.Error> = [
      (200, .subscription),
      (200, .input(true)),
      (200, .completion(.finished)),
    ]
    let res: TestSequence<Bool, CoreDataService.Error> = results.recordedOutput
    XCTAssertEqual(res, expected)
  }
  
  func testDeleteAllCommandsAdded() {
    let testScheduler = TestScheduler(initialClock: 0)
    
    sut = CoreDataService()
    let testContainer = TestPersistentContainer()
    sut.persistentContainer = testContainer.persistentContainer
    let testLateral = InitialLateralTypes.obliques[1]
    _ = LateralMO.create(testContainer.persistentContainer.viewContext,
                         lateralType: testLateral)
    try! sut.persistentContainer.viewContext.save()
    
    /*TestableSubscriber<[Command], Never>*/
    let _: TestableSubscriber<Void, CoreDataService.Error> = testScheduler.start { () -> AnyPublisher<Void, CoreDataService.Error> in
      
      let startupToDelete: AnyPublisher<Void, CoreDataService.Error> =
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
            }).setFailureType(to: CoreDataService.Error.self)
      }
    }
        
//    let allLaterals = InitialLateralTypes.obliques
//      .sorted()
//      .map { lat -> String in
//        return lat.body
//      }
    
    let expected: TestSequence<Int, CoreDataService.Error> = [
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
        .flatMap({ _ -> AnyPublisher<Bool, CoreDataService.Error> in
          self.sut.create(lateralType: testLateral)
          return Just(true)
            .setFailureType(to: CoreDataService.Error.self)
            .eraseToAnyPublisher()
        })
    }
    
    let expected: TestSequence<Bool, CoreDataService.Error> = [
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
    let container = NSPersistentContainer(name: "LateralModel",
                                          managedObjectModel: LateralManagedObjectModel)
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

