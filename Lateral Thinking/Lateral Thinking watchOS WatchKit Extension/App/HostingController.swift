//
//  HostingController.swift
//  Lateral Thinking watchOS WatchKit Extension
//
//  Created by Paul Wood on 7/26/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import WatchKit
import Foundation
import SwiftUI
import LateralBusinessLogic
import CombineFeedbackUI

typealias ContentView = Widget<CardViewModel.State, CardViewModel.Event, CardView>
class HostingController: WKHostingController<ContentView> {
  override var body: ContentView {
    let widget = Widget(
      viewModel: CardViewModel(syncService: EnvironmentObjects.shared.syncService),
      render: CardView.init
    )
    return widget
  }
}
