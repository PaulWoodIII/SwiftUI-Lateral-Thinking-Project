//
//  SyncService.swift
//  
//
//  Created by Paul Wood on 7/24/19.
//

import Foundation
import Combine
import CombineFeedback
import CombineFeedbackUI
import LateralThinkingCore
import LateralCloudKit

/// handles the creation of the CoreData store and manages syncing the CoreData Store with the CloudKit Store
/// Basically this is the Sync Service
public class SyncService {
    
  private var monitor: Cancellable?
  private var fetchCloud: Cancellable?
  
  @Published var coalescedLaterals: [LateralType] = []
  public func coalescedLateralsPublisher() -> AnyPublisher<[LateralType], Never> {
    return self.$coalescedLaterals.share().eraseToAnyPublisher()
  }
  
  private var coreDataCreate: (_: LateralType) -> Void
  
  private var careDataSave: () -> AnyPublisher<Void, CoreDataError>
  
  public init(
    cloudLaterals: AnyPublisher<ArrayHolder<LateralType>, Never>,
    coreDataLaterals: AnyPublisher<[LateralType], Never>,
    coreDataCreate: @escaping (_: LateralType) -> Void,
    careDataSave: @escaping () -> AnyPublisher<Void, CoreDataError>,
    fetchCloudLaterals: @escaping () -> AnyPublisher<[LateralType], CloudKitServiceError>
  ) {
    self.coreDataLaterals = coreDataLaterals
    self.cloudLaterals = cloudLaterals
    self.coreDataCreate = coreDataCreate
    self.careDataSave = careDataSave
    monitorServices()
    fetchCloud = fetchCloudLaterals().replaceError(with: []).makeConnectable().connect()
  }
  
  private var coreDataLaterals: AnyPublisher<[LateralType], Never> {
    didSet {
      monitorServices()
    }
  }
  
  private var cloudLaterals: AnyPublisher<ArrayHolder<LateralType>, Never> {
    didSet {
      monitorServices()
    }
  }
  
  // MARK: - Sync from Cloud
  func monitorServices() {
    guard monitor == nil else {
      return
    }
    monitor = Publishers.CombineLatest(coreDataLaterals, cloudLaterals)
      .map({ (cdLats, cloudLats) -> [LateralType] in
        let all = Set(self.coalescedLaterals).union(cdLats).union(cloudLats.array)
        self.coalescedLaterals = Array(all)
        let toUpdate = Set(cloudLats.array).subtracting(cdLats)
        return Array(toUpdate)
      })
      .map({ (lats) in
        _ = lats.map { (lat) in
          self.coreDataCreate(lat)
        }
      })
      .setFailureType(to: CoreDataError.self)
      .receive(on: RunLoop.main)
      .flatMap({ _ in
        self.careDataSave()
      })
      .replaceError(with: ())
      .makeConnectable()
      .connect()
  }
}
