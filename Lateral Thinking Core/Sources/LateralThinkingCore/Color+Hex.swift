//
//  Color+Hex.swift
//  Lateral Thinking
//
//  Created by Paul Wood on 7/21/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import SwiftUI

public extension Color {
  init(hex: String, alpha: Double = 1) {
    let scanner = Scanner(string: hex)
    var rgbValue: UInt64 = 0
    scanner.scanHexInt64(&rgbValue)
    
    let r = (rgbValue & 0xff0000) >> 16
    let g = (rgbValue & 0xff00) >> 8
    let b = rgbValue & 0xff
    
    self.init(.sRGB,
              red: Double(r) / 0xff,
              green: Double(g) / 0xff,
              blue: Double(b) / 0xff,
              opacity: alpha)
    
  }
}
