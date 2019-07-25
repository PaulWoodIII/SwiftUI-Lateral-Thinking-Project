//
//  CardViewModel.swift
//  Lateral Thinking
//
//  Created by Paul Wood on 7/22/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import Foundation
import Combine
import CombineFeedback
import CombineFeedbackUI
import LateralThinkingCore

public class CardViewModel: ViewModel<CardViewModel.State, CardViewModel.Event> {
  
  public init(initial: State = State(dataStoreViewModel: DataStoreViewModel.shared)) {
      super.init(
          initial: initial,
          feedbacks: [
            CardViewModel.monitorSyncEngine(),
        ],
          scheduler: RunLoop.main,
          reducer: CardViewModel.reduce
      )
  }
  
  public struct State: Builder {
    public init(dataStoreViewModel: DataStoreViewModel) {
      self.sync = dataStoreViewModel
      let s = dataStoreViewModel.state
      let sub = PassthroughSubject<DataStoreViewModel.State, Never>()
      _ = sub.append(s)
      self.syncState = sub.eraseToAnyPublisher()
    }
    public var displayText: String = InitialLateralTypes.obliques[1].body
    public var displayLaterals: [LateralType] = InitialLateralTypes.obliques
    public var backgroundPairing: ColorTypes.ColorPairing = ColorTypes.DarkThemes.allCases[0]
    let sync: DataStoreViewModel
    let syncState: AnyPublisher<DataStoreViewModel.State, Never>
  }
  
  public enum Event {
    case onTap
    case setLaterals(_: [LateralType])
  }
  
  private static func reduce(state: State, event: Event) -> State {
    switch event {
    case .onTap:
      return state.set(\.displayText, state.displayLaterals.randomElement()!.body)
    case .setLaterals(let lats):
      return state.set(\.displayLaterals, lats)
    }
  }
  
  static func monitorSyncEngine() -> Feedback<State, Event> {
    return Feedback { (state: CardViewModel.State) -> AnyPublisher<Event, Never> in
      state.sync.send(event: .fetchCloudLaterals)
      return state.syncState
        .compactMap({ (state: DataStoreViewModel.State) -> CardViewModel.Event? in
          guard state.cloudLaterals.count > 0 else {
            return nil
          }
          return Event.setLaterals(state.cloudLaterals)
        }).eraseToAnyPublisher()
    }
  }
}
