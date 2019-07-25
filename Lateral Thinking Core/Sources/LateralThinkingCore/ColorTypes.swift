//
//  ColorTypes.swift
//  Lateral Thinking
//
//  Created by Paul Wood on 7/21/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import Foundation

public struct ColorTypes {
  
  public typealias ColorPairing = (accent: String, background: String)

  public struct DarkThemes {
    
    static let notio: ColorPairing = ("E46A6B", "040404")
    static let sodasurfer: ColorPairing = ("A2482E","141311")
    static let railsmx: ColorPairing = ("D75813","1C1F24")
    static let dubbedCreative: ColorPairing = ("D38D47","201F1D")
    static let designOrDie: ColorPairing = ("E5DFC5","252120")
    static let rodeopark: ColorPairing = ("6ABED8","181712")
    static let elementGallery: ColorPairing = ("87A85C","151515")
    static let joseLuis: ColorPairing = ("494949","000000")
    static let osvaldas: ColorPairing = ("832F24","1A1A1A")
    static let valutis: ColorPairing = ("607625","1A1A1A")
    static let sklobovskaya: ColorPairing = ("D92B4B","0D0D0D")
    
    public static var allCases: [ColorPairing] = [
      DarkThemes.notio,
      DarkThemes.sodasurfer,
      DarkThemes.railsmx,
      DarkThemes.dubbedCreative,
      DarkThemes.designOrDie,
      DarkThemes.rodeopark,
      DarkThemes.elementGallery,
      DarkThemes.joseLuis,
      DarkThemes.osvaldas,
      DarkThemes.valutis,
      DarkThemes.sklobovskaya,
    ]
  }
}
