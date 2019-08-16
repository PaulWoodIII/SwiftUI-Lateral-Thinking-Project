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
      Rectangle()
        .foregroundColor(Color("Background"))
        .onTapGesture { self.context.send(event: .onTap) }

      Text(context.displayText)
        .lineLimit(nil)
        .font(.headline)
        .foregroundColor(Color("TextColor"))
        .onTapGesture { self.context.send(event: .onTap) }

    }        .frame(minWidth: 500,
               idealWidth:900,
               maxWidth: .infinity,
               minHeight: 300,
               idealHeight: 500,
               maxHeight: .infinity,
               alignment: .center)
      .onTapGesture {
          self.context.send(event: .onTap)
      }.gesture(
        DragGesture().onEnded({ _ in
          self.context.send(event: .onTap)
        })
    )
    .edgesIgnoringSafeArea(.all)
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
