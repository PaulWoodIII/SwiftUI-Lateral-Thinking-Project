//
//  CardView.swift
//  Lateral Thinking
//
//  Created by Paul Wood on 7/21/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import SwiftUI
import LateralThinkingCore
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
      Text(context.displayText)
        .font(.title)
        .lineLimit(nil)
        .background(
          RoundedRectangle(cornerRadius: 60)
            .foregroundColor(Color.clear)
            .accessibility(addTraits: .isButton)
            .focusable(true, onFocusChange: { foc in
              self.context.send(event: .onTap)
            })
            .onPlayPauseCommand{ self.context.send(event: .onTap)}
      )}
  }
}

#if DEBUG
struct CardView_Previews : PreviewProvider {
  static var previews: some View {
    Widget(
      viewModel: CardViewModel(lateralPublisher: InitialLateralTypes.published),
      render: CardView.init
    )
  }
}
#endif
