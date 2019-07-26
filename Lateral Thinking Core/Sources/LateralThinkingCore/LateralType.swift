//
//  File.swift
//  Lateral Thinking Core
//
//  Created by Paul Wood on 7/23/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import Foundation
import SwiftUI // For Identifieable Remove if that protocol is moved to foundation

/// Value Type of a Lateral, used by Core Data and CloudKit Services to "display"
public struct LateralType: ExpressibleByStringLiteral, Identifiable, Comparable {
  public static func < (lhs: LateralType, rhs: LateralType) -> Bool {
    return lhs.body < rhs.body
  }
  
  public var body: String
  
  public var id: String {
    return body
  }
  
  public init(stringLiteral value: Swift.StringLiteralType) {
    self.body = value
  }
}

extension LateralType: Hashable {
  
}
