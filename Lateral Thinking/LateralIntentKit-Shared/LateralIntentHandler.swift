//
//  LateralIntentHandler.swift
//  Lateral Thinking
//
//  Created by Paul Wood on 7/27/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import Foundation
import Intents

public class LateralIntentHandler: NSObject, LateralIntentHandling {
  public func handle(intent: LateralIntent, completion: @escaping (LateralIntentResponse) -> Void) {
    let response = LateralIntentResponse.success(body: "Response Yay!")
    completion(response)
  }
  
  public func resolveList(for intent: LateralIntent, with completion: @escaping (LateralListResolutionResult) -> Void) {
    completion(LateralListResolutionResult.success(with: "obliques"))
  }
  
  public func provideListOptions(for intent: LateralIntent, with completion: @escaping ([String]?, Error?) -> Void) {
    completion(["obliques"], nil)
  }
}
