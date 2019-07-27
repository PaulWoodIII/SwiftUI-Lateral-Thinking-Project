//
//  IntentHandler.swift
//  Lateral Thinking Siri Intent
//
//  Created by Paul Wood on 7/26/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import Intents
import LateralIntentKit_iOS

class IntentHandler: INExtension {
  override func handler(for intent: INIntent) -> Any {
    // This is the default implementation.  If you want different objects to handle different intents,
    // you can override this and return the handler you want for that particular intent.
    guard intent is LateralIntentKit_iOS.LateralIntent else {
      fatalError("Unhandled intent type: \(intent)")
    }
    return LateralIntentHandler()
  }
}
