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
import LateralCoreData
import LateralCloudKit

/// handles the creation of the CoreData store and manages syncing the CoreData Store with the CloudKit Store
/// Basically this is the Sync Service
public class SyncService {
  
  public static let shared = SyncService()
  
  var monitor: Cancellable?
  
  @Published var coalescedLaterals: [LateralType] = []
  
  var coreDataCreate: (_: LateralType) -> Void
  
  var careDataSave: () -> AnyPublisher<Void, CoreDataService.Error>
  
  public init(
    cloudLaterals: AnyPublisher<[LateralType], Never> = CloudKitService.shared.$cloudLaterals.eraseToAnyPublisher(),
    coreDataLaterals: AnyPublisher<[LateralType], Never> = CoreDataService.shared.$allLateralTypes.eraseToAnyPublisher(),
    coreDataCreate: @escaping (_: LateralType) -> Void = CoreDataService.shared.create(lateralType:),
    careDataSave: @escaping () -> AnyPublisher<Void, CoreDataService.Error> = CoreDataService.shared.saveContext,
    fetchCloudLaterals: @escaping () -> AnyPublisher<[LateralType], CloudKitService.Error> = CloudKitService.shared.retrieveAllLaterals
  ) {
    self.coreDataLaterals = coreDataLaterals
    self.cloudLaterals = cloudLaterals
    self.coreDataCreate = coreDataCreate
    self.careDataSave = careDataSave
    monitorServices()
    _ = fetchCloudLaterals().replaceError(with: []).makeConnectable().connect()
  }
  
  private  var coreDataLaterals: AnyPublisher<[LateralType], Never> {
    didSet {
      monitorServices()
    }
  }
  
  private var cloudLaterals: AnyPublisher<[LateralType], Never> {
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
        let all = Set(self.coalescedLaterals).union(cdLats).union(cloudLats)
        self.coalescedLaterals = Array(all)
        let toUpdate = Set(cloudLats).subtracting(cdLats)
        return Array(toUpdate)
      })
      .map({ (lats) in
        _ = lats.map { (lat) in
          self.coreDataCreate(lat)
        }
      })
      .setFailureType(to: CoreDataService.Error.self)
      .flatMap({ _ in
        self.careDataSave()
      })
      .replaceError(with: ())
      .makeConnectable()
      .connect()
  }
}
