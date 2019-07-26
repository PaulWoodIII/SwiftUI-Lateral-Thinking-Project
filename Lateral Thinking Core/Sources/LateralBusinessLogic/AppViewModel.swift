//
//  AppViewModel.swift
//  
//
//  Created by Paul Wood on 7/25/19.
//

import Foundation
import Combine
import CombineFeedback
import CombineFeedbackUI
import LateralCoreData
import LateralCloudKit

public class AppViewModel: ViewModel<AppViewModel.State, AppViewModel.Event> {
  
  var coreDataService: CoreDataService
  var cloudKitService: CloudKitService
  
  public init(initial: State = State(),
              coreDataService: CoreDataService = CoreDataService.shared,
                cloudKitService: CloudKitService = CloudKitService.shared
              ) {
    self.coreDataService = coreDataService
    self.cloudKitService = cloudKitService
      super.init(
          initial: initial,
          feedbacks: [],
          scheduler: RunLoop.main,
          reducer: AppViewModel.reduce
      )
  }
  
  private static func reduce(state: State, event: Event) -> State {
    switch event {
    default:
      return state
    }
  }
  
  public struct State {
    public init() {}
  }
  
  public enum Event {
    
  }
}
