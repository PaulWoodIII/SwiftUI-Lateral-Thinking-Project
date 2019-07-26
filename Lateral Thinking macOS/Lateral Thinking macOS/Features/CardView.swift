//
//  CardView.swift
//  Lateral Thinking macOS
//
//  Created by Paul Wood on 7/26/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import SwiftUI
import LateralBusinessLogic
import CombineFeedbackUI

public struct CardView : View {
  
  typealias State = CardViewModel.State
  typealias Event = CardViewModel.Event
  
  private let context: Context<CardViewModel.State, CardViewModel.Event>
  
  public init(context: Context<CardViewModel.State, CardViewModel.Event>) {
    self.context = context
  }
  
  @Environment(\.sizeCategory) var sizeCategory: ContentSizeCategory
  
  public var body: some View {
    ZStack {
      VStack {
        Text(context.displayText)
          .font(.headline)
          .padding()
          .lineLimit(nil)
      }
    }
    .frame(minWidth: 500, idealWidth: 700, minHeight: 250, idealHeight: 300, alignment: .center)
    .tapAction {
      self.context.send(event: .onTap)
    }
  }
}

#if DEBUG
struct CardView_Previews : PreviewProvider {
  static var previews: some View {
    Widget(
      viewModel: CardViewModel(),
      render: CardView.init
    )
  }
}
#endif
