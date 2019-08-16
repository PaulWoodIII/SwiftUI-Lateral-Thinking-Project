//
//  LateralIntentHandler.swift
//  Lateral Thinking
//
//  Created by Paul Wood on 7/27/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import Foundation
import Intents
import LateralThinkingCore
import LateralBusinessLogic
import CombineFeedbackUI

public class LateralIntentHandler: NSObject, LateralIntentHandling {
  
  private let context: Context<CardViewModel.State, CardViewModel.Event> = {
    //let cdTypes = IntentEnvironmentObjects.shared.coreDataService.allLateralTypesPublisher
    let cdTypes = InitialLateralTypes.published
    return Context(state: CardViewModel.State(),
                   viewModel: CardViewModel(lateralPublisher:cdTypes))
  }()
  
  public func handle(intent: LateralIntent, completion: @escaping (LateralIntentResponse) -> Void) {
    context.send(event: .onTap)
    let body = context.displayText
    let response = LateralIntentResponse.success(body: body)
    completion(response)
  }
  
  public func resolveList(for intent: LateralIntent, with completion: @escaping (LateralListResolutionResult) -> Void) {
    completion(LateralListResolutionResult.success(with: "obliques"))
  }
  
  public func provideListOptions(for intent: LateralIntent, with completion: @escaping ([String]?, Error?) -> Void) {
    completion(["obliques"], nil)
  }
}
