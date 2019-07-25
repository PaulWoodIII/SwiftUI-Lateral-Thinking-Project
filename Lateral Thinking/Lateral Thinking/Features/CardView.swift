//
//  CardView.swift
//  Lateral Thinking
//
//  Created by Paul Wood on 7/21/19.
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
      RoundedRectangle(cornerRadius: 20)
        .foregroundColor(Color(hex:context.backgroundPairing.background))
        .padding()
        .aspectRatio(contentMode: ContentMode.fit)
      VStack {
        Text(context.displayText)
          .font(.headline)
          .foregroundColor(Color(hex:context.backgroundPairing.accent))
          .lineLimit(nil)
          .padding().padding()
      }
    }.tapAction {
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
