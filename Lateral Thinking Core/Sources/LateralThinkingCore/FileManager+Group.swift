//
//  File.swift
//  
//
//  Created by Paul Wood on 8/15/19.
//

import Foundation

public extension FileManager {
  static let applicationGroupDocumentDirectory: URL = {
    return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.paulwoodiii.lateralthinking")!
  }()
}
