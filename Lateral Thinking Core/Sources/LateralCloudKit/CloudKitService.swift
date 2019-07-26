//
//  CloudKitService.swift
//  Lateral Thinking Core
//
//  Created by Paul Wood on 7/23/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import Foundation
import Combine
import CloudKit
import LateralThinkingCore


extension CKContainer {
  static let lateralThinkingShared = CKContainer(identifier: "iCloud.com.paulwoodiii.lateralthinking")
}

let LateralListCloud = "LateralListCloud"
let LateralCloud = "LateralCloud"

enum LateralTypeKeys: String {
  case body, lateralList
}

enum LateralListTypeKeys: String {
  case title, body, items
}

extension CKRecord {
  
  subscript(_ key: LateralTypeKeys) -> CKRecordValue {
    get {
      return self[key.rawValue]!
    }
    set {
      self[key.rawValue] = newValue
    }
  }
  
  subscript(_ key: LateralListTypeKeys) -> CKRecordValue {
    get {
      return self[key.rawValue]!
    }
    set {
      self[key.rawValue] = newValue
    }
  }
  
}

public class CloudKitService {
  
  public static let shared = CloudKitService()
  
  public enum Error: Swift.Error {
    case error
  }
  
  static let container: CKContainer = CKContainer.lateralThinkingShared
  
  @Published public var cloudLaterals: [LateralType] = []
  
  public func cloudKitAvailable() -> Bool {
    //TODO check for connectivity and cloudkit access
    return true
  }
  
  public func retrieveAllLaterals() -> AnyPublisher<[LateralType], Error> {
    return Deferred { () -> AnyPublisher<[LateralType], Error> in
      return Future { promise in
        let query = CKQuery(recordType: LateralCloud, predicate: NSPredicate(value: true))
        CloudKitService.container.publicCloudDatabase
          .perform(query,
                   inZoneWith: nil) { (records: [CKRecord]?, err: Swift.Error?) in
                    guard err == nil else {
                      return promise(.failure(.error))
                    }
                    if let records = records {
                      let types = records.compactMap { (record: CKRecord) -> LateralType? in
                        if let body = record[LateralTypeKeys.body] as? String {
                          return LateralType(stringLiteral: body)
                        }
                        return nil
                      }
                      self.cloudLaterals = types
                      return promise(.success(types))
                    }
                    return promise(.success([]))
        }
      }.eraseToAnyPublisher()
    }.eraseToAnyPublisher()
  }
}
