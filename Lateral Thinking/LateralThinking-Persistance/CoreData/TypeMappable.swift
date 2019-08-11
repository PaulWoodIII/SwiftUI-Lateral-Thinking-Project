//
//  TypeMappable.swift
//  Lateral Thinking
//
//  Created by Paul Wood on 8/10/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import Foundation
import CoreData
import LateralThinkingCore

public protocol TypeMappable {
  associatedtype ValueType
  func setFrom(_: ValueType)
}

public extension TypeMappable where Self: NSManagedObject {
  
  static func createFromValue(_ type: ValueType,
                              context: NSManagedObjectContext) -> Result<Self, CoreDataError> {
    let obj = Self.init(context: context)
    obj.setFrom(type)
    return Result(catching: {try context.save()})
      .flatMap { _ in
        Result.success(obj)
    }.flatMapError { _ in
      return Result.failure( CoreDataError())
    }
  }
  
  static func update(obj: Self,
                     type: ValueType,
                     context: NSManagedObjectContext) -> Result<Self, CoreDataError> {
    obj.setFrom(type)
    return Result(catching: {try context.save()})
      .flatMap { _ in
        Result.success(obj)
    }.flatMapError { _ in
      return Result.failure( CoreDataError())
    }
  }
  
  func read(_ id: NSManagedObjectID,
            context: NSManagedObjectContext) -> Result<Self, CoreDataError> {
    if let object = context.object(with: id) as? Self {
      return Result.success(object)
    } else {
      return Result.failure(CoreDataError())// better to use a custom type but it isn't what I'm teaching
    }
  }
  
  static func delete(_ object: Self,
                     context: NSManagedObjectContext) -> Result<Void, CoreDataError> {
    context.delete(object)
    let result = Result(catching: {try context.save()})
    return result.flatMapError({_ in
      return Result.failure( CoreDataError())
    })
  }
}
