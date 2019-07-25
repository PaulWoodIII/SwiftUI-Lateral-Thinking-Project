//
//  DataStoreViewModel.swift
//  
//
//  Created by Paul Wood on 7/24/19.
//

import Foundation
import Combine
import CombineFeedback
import CombineFeedbackUI
import LateralThinkingCore
import LateralCoreData
import LateralCloudKit

/// handles the creation of the CoreData store and manages syncing the CoreData Store with the CloudKit Store
/// Basically this is the Sync Service
public class DataStoreViewModel: ViewModel<DataStoreViewModel.State, DataStoreViewModel.Event> {
  
  public static let shared = DataStoreViewModel()
  
  public struct State: Builder {
    public init() {
      
    }
    var coreDataStatus: CoreDataStatus = .loaded
    var coreDataLaterals: [LateralType] = []
    var cloudKitStatus: CloudKitStatus = .loaded
    var cloudLaterals: [LateralType] = []
  }
  
  public enum Event {
    case fetchCloudLaterals
    case retrievedCoreDataLaterals(_: [LateralType])
    case retrievedCloudLaterals(_: [LateralType])
  }
  
  public enum CoreDataStatus {
    case loaded
    case loading
  }
  
  public enum CloudKitStatus {
    case loaded
    case loading
  }
  
  private static func reduce(state: State, event: Event) -> State {
    switch event {
      
    case .retrievedCoreDataLaterals(let lats):
      return state
        .set(\.coreDataStatus, .loaded)
        .set(\.coreDataLaterals, lats)
      
    case .retrievedCloudLaterals(let lats):
      return state
        .set(\.cloudKitStatus, .loaded)
        .set(\.cloudLaterals, lats)
    case .fetchCloudLaterals:
      return state.set(\.cloudKitStatus, .loading)
    }
  }
  
  public init(initial: State = State(),
              cloudKitService: CloudKitService = CloudKitService.shared,
              coreDataService: CoreDataService = CoreDataService.shared) {
    super.init(
      initial: initial,
      feedbacks: [
        DataStoreViewModel.monitorCloudKit(cloudKitService: CloudKitService.shared),
        DataStoreViewModel.monitorCoreData(coreDataService: CoreDataService.shared)
      ],
      scheduler: RunLoop.main,
      reducer: DataStoreViewModel.reduce
    )
  }
  
  static func monitorCoreData(coreDataService: CoreDataService) -> Feedback<State, Event>  {
    return Feedback { (state: DataStoreViewModel.State) -> AnyPublisher<Event, Never> in
      switch state.coreDataStatus {
      case .loading:
        return Empty().eraseToAnyPublisher()
      case .loaded:
        return Empty().eraseToAnyPublisher()
      }
    }
  }
  
  static func monitorCloudKit(cloudKitService: CloudKitService) -> Feedback<State, Event> {
    return Feedback(predicate: { (state: State) -> Bool in
      state.cloudKitStatus == .loading
    }){ (state: DataStoreViewModel.State) -> AnyPublisher<Event, Never> in
      return cloudKitService.retrieveAllLaterals()
        .replaceError(with: [])
        .map { lats -> Event in
          return Event.retrievedCloudLaterals(lats)
      }.eraseToAnyPublisher()
    }
  }
}
