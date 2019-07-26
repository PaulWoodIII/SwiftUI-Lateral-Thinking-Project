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
import LateralCloudKit
import GameplayKit

public class CardViewModel: ViewModel<CardViewModel.State, CardViewModel.Event> {
  
  public init(initial: State = State()) {
      super.init(
          initial: initial,
          feedbacks: [
            CardViewModel.monitorStore(lateralPublisher: SyncService.shared.$coalescedLaterals.eraseToAnyPublisher())
        ],
          scheduler: RunLoop.main,
          reducer: CardViewModel.reduce
      )
  }
  
  public struct State: Builder {
    
    /// we need a public inititializer since Swift hides the default init as internal
    public init() {
      
    }
    
    public var onAppear: Bool = false
    public var displayText: String = InitialLateralTypes.obliques[1].body
    public var displayLaterals: [LateralType] = []
    public var backgroundPairing: ColorTypes.ColorPairing = ColorTypes.DarkThemes.allCases[0]
    public var serviceCancelable: Cancellable?
    public var shuffler = GKShuffledDistribution()
  }
  
  public enum Event {
    case appeared
    case onTap
    case setLaterals(_: [LateralType])
    case error
    case lateralPublisher(_: Cancellable)
  }
  
  private static func reduce(state: State, event: Event) -> State {
    switch event {
    case .appeared:
      return state.set(\.onAppear, true)
    case .onTap:
      let next = state.shuffler.nextInt()
      return state.set(\.displayText, state.displayLaterals[next].body)
    case .setLaterals(let lats):
      let random = GKShuffledDistribution(lowestValue: 0, highestValue: lats.count-1)
      return state.set(\.shuffler, random)
        .set(\.displayLaterals, lats)
    case .error:
      return state //TODO: use Errors in a productive way in the UI
    case .lateralPublisher(let c):
      return state.set(\.serviceCancelable, c)

    }
  }
  
  static func monitorStore(lateralPublisher: AnyPublisher<[LateralType], Never> ) -> Feedback<State, Event> {
    return Feedback(predicate: { (state: State) -> Bool in
      return state.serviceCancelable == nil
    }, effects: { (state: CardViewModel.State) -> AnyPublisher<Event, Never> in
      let monitor = lateralPublisher
        .removeDuplicates()
        .compactMap { lats -> Event? in
          guard lats.count > 0 else {
            return nil
          }
          return Event.setLaterals(lats)
      }
      let serviceObservable = monitor.makeConnectable().connect()
      return monitor.prepend(Event.lateralPublisher(serviceObservable)).eraseToAnyPublisher()
    })
  }
  
}
