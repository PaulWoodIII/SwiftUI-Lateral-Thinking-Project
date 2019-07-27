//
//  INUIAddVoiceShortcutButtonRepresentable.swift
//  Lateral Thinking
//
//  Created by Paul Wood on 7/27/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import SwiftUI
import IntentsUI

class ShortcutButtonCoordinator: NSObject {
  
}

struct INUIAddVoiceShortcutButtonRepresentable: UIViewRepresentable {
  
  /// Creates a `UIView` instance to be presented.
  func makeUIView(context: Self.Context) -> INUIAddVoiceShortcutButton {
    return INUIAddVoiceShortcutButton(style: .automatic)
  }
  
  /// Updates the presented `UIView` (and coordinator) to the latest
  /// configuration.
  func updateUIView(_ uiView: INUIAddVoiceShortcutButton, context: Self.Context){
    
  }
  
  /// Cleans up the presented `UIView` (and coordinator) in
  /// anticipation of their removal.
  static func dismantleUIView(_ uiView: INUIAddVoiceShortcutButton,
                              coordinator: ShortcutButtonCoordinator){
    
  }
  
  func makeCoordinator() -> ShortcutButtonCoordinator {
    return ShortcutButtonCoordinator()
  }
}

#if DEBUG
struct SwiftUISiriShortcutsButton_Previews: PreviewProvider {
  static var previews: some View {
    INUIAddVoiceShortcutButtonRepresentable()
  }
}
#endif
