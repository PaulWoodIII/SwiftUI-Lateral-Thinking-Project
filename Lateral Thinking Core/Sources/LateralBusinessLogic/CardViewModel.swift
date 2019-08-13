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
#if canImport(GameplayKit)
import GameplayKit
#endif

public class CardViewModel: ViewModel<CardViewModel.State, CardViewModel.Event> {
  
  public init(initial: State = State(),
              lateralPublisher: AnyPublisher<[LateralType], Never>) {
      super.init(
          initial: initial,
          feedbacks: [
            CardViewModel.monitorStore(lateralPublisher: lateralPublisher)
        ],
          scheduler: RunLoop.main,
          reducer: CardViewModel.reduce
      )
  }
  
  public init<S: Scheduler>(initial: State = State(),
              lateralPublisher: AnyPublisher<[LateralType], Never>,
              scheduler: S) {
      super.init(
          initial: initial,
          feedbacks: [
            CardViewModel.monitorStore(lateralPublisher: lateralPublisher)
        ],
          scheduler: scheduler,
          reducer: CardViewModel.reduce
      )
  }
  
  
  public struct State: Builder, Equatable {
    /// we need a public inititializer since Swift hides the default init as internal
    public init() {
      
    }
    
    public var displayText: String = "Tap"
    public var displayLaterals: [LateralType] = []
    public var backgroundPairing: ColorTypes.ColorPairing = ColorTypes.DarkThemes.allCases[0]
    #if canImport(GameplayKit)
    var shuffler = GKShuffledDistribution()
    #endif
    
    public func isEqual(_ rhs: CardViewModel.State) -> Bool {
      return
        self.displayText == rhs.displayText &&
        self.displayLaterals == rhs.displayLaterals &&
          self.backgroundPairing == rhs.backgroundPairing
    }
    
    public static func == (lhs: CardViewModel.State, rhs: CardViewModel.State) -> Bool {
      return
        lhs.displayText == rhs.displayText &&
        lhs.displayLaterals == rhs.displayLaterals &&
        lhs.backgroundPairing == rhs.backgroundPairing
    }
  }
  
  public enum Event {
    case onTap
    case setLaterals(_: [LateralType])
  }
  
  private static func nextDisplay(state: State) -> String {
    guard state.displayLaterals.count > 0 else {
      return ""
    }
    #if canImport(GameplayKit)
    let next = state.shuffler.nextInt()
    return state.displayLaterals[next].body
    #else
    let high = UInt32(state.displayLaterals.count - 1)
    let next = Int(arc4random_uniform(high))
    return state.displayLaterals[next].body
    #endif
  }
  
  public static func reduce(state: State, event: Event) -> State {
    
    func onTap(state: State) -> State {
      let next = nextDisplay(state: state)
      return state.set(\.displayText, next)
    }
    
    switch event {
    case .onTap:
      return onTap(state: state)
    case .setLaterals(let lats):
      var copy = state
      #if canImport(GameplayKit)
      let shuffler = GKShuffledDistribution(lowestValue: 0, highestValue: lats.count-1)
      copy = copy.set(\.shuffler, shuffler)
      #endif
      if lats.count > 0 {
        copy = copy.set(\.displayLaterals, lats)
        return onTap(state: copy)
      }
      return copy
    }
  }
  
  static func monitorStore(lateralPublisher: AnyPublisher<[LateralType], Never> ) -> Feedback<State, Event> {
    return Feedback<State, Event> { (statePublisher: AnyPublisher<State, Never>) -> AnyPublisher<Event, Never> in
      return lateralPublisher
      .compactMap { lats -> Event? in
        guard lats.count > 0 else {
          return nil
        }
        return Event.setLaterals(lats)
      }.eraseToAnyPublisher()
    }
  }
  
}
