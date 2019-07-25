//
//  LateralListType.swift
//  Lateral Thinking Core
//
//  Created by Paul Wood on 7/23/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import Foundation
import SwiftUI

/// Value Type of a Lateral List, used by Core Data and CloudKit Services to display
public struct LateralListType: Identifiable {
  public var title: String
  public var body: String
  public var items: [LateralType]
  public var id: String {
    return title + body
  }
}
