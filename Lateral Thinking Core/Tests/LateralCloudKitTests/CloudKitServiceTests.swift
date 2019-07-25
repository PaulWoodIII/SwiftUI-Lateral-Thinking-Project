//
//  File.swift
//  
//
//  Created by Paul Wood on 7/24/19.
//

import XCTest
import Combine
import Entwine
import EntwineTest
import CoreData
@testable import LateralThinkingCore
@testable import LateralCloudKit

class CloudKitServiceTests: XCTestCase {
  func testRetrieveAllLaterals() {
    let scheduler = TestScheduler()
    let results = scheduler.start {
      return CloudKitService().retrieveAllLaterals()
    }
    print(results)
  }
  
  static var allTests = [
    ("testRetrieveAllLaterals", testRetrieveAllLaterals),
  ]
}


