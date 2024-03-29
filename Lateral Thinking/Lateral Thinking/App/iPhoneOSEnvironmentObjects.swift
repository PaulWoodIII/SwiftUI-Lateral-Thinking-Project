//
//  EnvironmentObjects.swift
//  Lateral Thinking
//
//  Created by Paul Wood on 7/27/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import Foundation
import Combine
import LateralCloudKit
import LateralThinkingCore
import LateralBusinessLogic
import LateralThinking_Persistance

class iPhoneOSEnvironmentObjects {
  static let shared = iPhoneOSEnvironmentObjects()
  
  let coreDataService: CoreDataServiceType
  let cloudKitService: CloudKitService
  let syncService: SyncService
    
  init() {
    let coreDataService = CoreDataService.shared
    let cloudKitService = CloudKitService.shared
    let syncService = SyncService(
      cloudLaterals:cloudKitService.$cloudLaterals.eraseToAnyPublisher(),
      coreDataLaterals: coreDataService.$allLateralTypes.eraseToAnyPublisher(),
      coreDataCreate: coreDataService.create(lateralType:),
      careDataSave: coreDataService.saveViewContext,
      fetchCloudLaterals: cloudKitService.retrieveAllLaterals
    )
    self.coreDataService = coreDataService
    self.cloudKitService = cloudKitService
    self.syncService = syncService
  }
}
