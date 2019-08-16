//
//  IntentViewController.swift
//  Lateral Thinking Siri Intent UI
//
//  Created by Paul Wood on 7/27/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import IntentsUI
import LateralThinkingCore
import LateralBusinessLogic
import Combine
import CombineFeedbackUI
import SwiftUI

// MARK: - IntentCardHostingView
class IntentCardHostingView: UIHostingController<Widget<CardViewModel.State, CardViewModel.Event, CardView>>, INUIHostedViewControlling {

  var laterals: PassthroughSubject<[LateralType], Never>!
  
  convenience init() {
    let laterals = PassthroughSubject<[LateralType], Never>()
    let widget = Widget(
      viewModel: CardViewModel(lateralPublisher: laterals.eraseToAnyPublisher()),
      render: CardView.init
    )
    defer{
      self.laterals = laterals
    }
    self.init(rootView: widget)
  }
  
  func configureView(for parameters: Set<INParameter>,
                     of interaction: INInteraction,
                     interactiveBehavior: INUIInteractiveBehavior,
                     context: INUIHostedViewContext,
                     completion: @escaping (Bool, Set<INParameter>, CGSize) -> Void) {
    // Do configuration here, including preparing views and calculating a desired size for presentation.
    //laterals.append(INIntera)
    completion(true, parameters, self.desiredSize)
  }
  
  var desiredSize: CGSize {
    return self.extensionContext!.hostedViewMaximumAllowedSize
  }
}

