//
//  ArrayHolder.swift
//  
//
//  Created by Paul Wood on 8/16/19.
//

import Foundation

/// Just a thing that holds another array of things in the 'array' property.
public struct ArrayHolder<U>: ExpressibleByArrayLiteral {
  public init(arrayLiteral elements: U...) {
    self.array = elements
  }
  public init(array: [U]) {
    self.array = array
  }
  public let array: [U]
}
