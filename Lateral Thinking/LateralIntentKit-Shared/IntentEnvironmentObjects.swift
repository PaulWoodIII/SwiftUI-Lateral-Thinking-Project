//
//  IntentEnvironmentObjects.swift
//  Lateral Thinking
//
//  Created by Paul Wood on 8/15/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//


import Foundation
import Combine
import LateralThinkingCore
import LateralBusinessLogic
#if os(iOS)
    import LateralThinking_Persistance
#elseif os(watchOS)
    import LateralThinking_Persistance_watchOS
#endif

class IntentEnvironmentObjects {
  
  static let shared = IntentEnvironmentObjects()
  
  let coreDataService: CoreDataServiceType
    
  init() {
    let coreDataService = CoreDataService.shared
    self.coreDataService = coreDataService
  }
}
