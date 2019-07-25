//
//  AppViewModel.swift
//  
//
//  Created by Paul Wood on 7/25/19.
//

import Foundation
import Combine
import CombineFeedback
import CombineFeedbackUI

class AppViewModel: ViewModel<AppViewModel.State, AppViewModel.Event> {
  
  let dataStoreContext: Context<DataStoreViewModel.State, DataStoreViewModel.Event>
  let cardContext: Context<CardViewModel.State, CardViewModel.Event>
  
  public init(initial: State = State()) {
    let vm = DataStoreViewModel()
    let dataStoreViewModel = Context<DataStoreViewModel.State, DataStoreViewModel.Event>(state: DataStoreViewModel.State(), viewModel: vm)
    self.dataStoreContext = dataStoreViewModel
    self.cardContext = Context<CardViewModel.State, CardViewModel.Event>(state:CardViewModel.State(dataStoreViewModel: vm), viewModel: CardViewModel())
      super.init(
          initial: initial,
          feedbacks: [],
          scheduler: RunLoop.main,
          reducer: AppViewModel.reduce
      )
  }
  
  private static func reduce(state: State, event: Event) -> State {
    switch event {
    default:
      return state
    }
  }
  
  struct State {
    
  }
  
  enum Event {
    
  }
}
