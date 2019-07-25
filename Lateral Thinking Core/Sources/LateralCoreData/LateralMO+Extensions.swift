//
//  LateralMO+Extensions.swift
//  Lateral Thinking Core
//
//  Created by Paul Wood on 7/23/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import Foundation
import CoreData
import LateralThinkingCore

extension LateralMO {
  static func create(_ context: NSManagedObjectContext,
                     lateralType: LateralType) -> LateralMO {
    let lateralMO = LateralMO(context: context)
    lateralMO.body = lateralType.body
    return lateralMO
  }
}
