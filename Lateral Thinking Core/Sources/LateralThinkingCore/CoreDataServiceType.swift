//
//  CoreDataServiceType.swift
//  
//
//  Created by Paul Wood on 7/27/19.
//

import Foundation
import Combine
import CoreData

public protocol CoreDataServiceType: NSObjectProtocol {
  
  var allLateralTypes: Array<LateralThinkingCore.LateralType> { get }
  
  //var allLateralTypesPublisher: AnyPublisher<Array<LateralType>, Never> { get }
  
  init(persistentContainer: NSPersistentContainer)
  
  func startup() -> AnyPublisher<Bool, CoreDataError>
  
  func saveInitialToCoreData() -> AnyPublisher<[LateralType], CoreDataError>
  
  func create(lateralType: LateralType)
  
  func deleteAll() -> AnyPublisher<Void, CoreDataError>
  
  func saveViewContext() -> AnyPublisher<Void, CoreDataError>
  
}
