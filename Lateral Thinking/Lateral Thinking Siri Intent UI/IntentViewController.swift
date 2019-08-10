//
//  IntentViewController.swift
//  Lateral Thinking Siri Intent UI
//
//  Created by Paul Wood on 7/27/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import IntentsUI
import LateralBusinessLogic
import CombineFeedbackUI
import SwiftUI

typealias State = CardViewModel.State
typealias Event = CardViewModel.Event
typealias ContentType = Widget<State, Event, CardView>

// MARK: - IntentCardHostingView
class IntentCardHostingView: UIHostingController<ContentType> {
  
  convenience init() {
    let widget = Widget(
      viewModel: CardViewModel(lateralPublisher: EnvironmentObjects.shared.syncService.coalescedLateralsPublisher()),
      render: CardView.init
    )
    self.init(rootView: widget)
  }
}

// MARK: - INUIHostedViewControlling
class IntentViewController: UIViewController, INUIHostedViewControlling {
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  func configureView(for parameters: Set<INParameter>,
                     of interaction: INInteraction,
                     interactiveBehavior: INUIInteractiveBehavior,
                     context: INUIHostedViewContext,
                     completion: @escaping (Bool, Set<INParameter>, CGSize) -> Void) {
    // Do configuration here, including preparing views and calculating a desired size for presentation.
    completion(true, parameters, self.desiredSize)
  }
  
  var desiredSize: CGSize {
    return self.extensionContext!.hostedViewMaximumAllowedSize
  }
  
}
