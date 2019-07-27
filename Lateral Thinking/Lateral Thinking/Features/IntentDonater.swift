//
//  IntentDonater.swift
//  Lateral Thinking
//
//  Created by Paul Wood on 7/27/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import Foundation
import Intents
import LateralIntentKit_iOS

class IntentDonater {
  
  static var defaultIntent: LateralIntent {
    let intent = LateralIntent()
    intent.list = "obliques"
    intent.suggestedInvocationPhrase = "Throw me a Lateral"
    return intent
  }
  
  static func donate() {
    let interaction = INInteraction(intent: IntentDonater.defaultIntent,
                                    response: nil)
    interaction.donate { error in
      // handle Error
      print(error)
    }
  }
}

class ShortcutMaker {
  static func makeShortcut() -> INShortcut {
    return INShortcut(intent: IntentDonater.defaultIntent)!
  }
}
