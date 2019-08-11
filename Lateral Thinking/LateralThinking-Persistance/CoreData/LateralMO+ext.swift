//
//  LateralMO+ext.swift
//  LateralThinking-Persistance
//
//  Created by Paul Wood on 8/10/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import Foundation
import CoreData
import LateralThinkingCore

extension LateralMO: TypeMappable {
  public typealias ValueType = LateralType
  
  public func setFrom(_ type: LateralType) {
    self.body = type.body
  }
}
