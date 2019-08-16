//
//  File.swift
//  
//
//  Created by Paul Wood on 8/15/19.
//

import Foundation

extension FileManager {
  static let applicationGroupDocumentDirectory = {
    return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.paulwoodiii.lateralthinking")
  }()
}
