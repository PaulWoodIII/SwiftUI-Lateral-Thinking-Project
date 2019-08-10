//
//  CardView.swift
//  Lateral Thinking Siri Intent UI
//
//  Created by Paul Wood on 7/28/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import SwiftUI

import LateralBusinessLogic
import CombineFeedbackUI
import IntentsUI

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
        .frame(minWidth: 0,
               idealWidth:UIScreen.main.bounds.width,
               maxWidth: .infinity,
               minHeight: 0,
               idealHeight: UIScreen.main.bounds.height,
               maxHeight: .infinity,
               alignment: .center)
        .onTapGesture {
          self.context.send(event: .onTap)
      }.edgesIgnoringSafeArea(.all)
      
      
      Text(context.displayText)
        .lineLimit(nil)
        .font(.headline)
        .foregroundColor(Color("TextColor"))
        .onTapGesture {
          self.context.send(event: .onTap)
      }
    }.frame(minWidth: 0,
            idealWidth:UIScreen.main.bounds.width,
            maxWidth: .infinity,
            minHeight: 0,
            idealHeight: UIScreen.main.bounds.height,
            maxHeight: .infinity,
            alignment: .center)
      .onTapGesture {
        self.context.send(event: .onTap)
    }.gesture(
      DragGesture().onEnded({ _ in
        self.context.send(event: .onTap)
      })
    )

  }
}

#if DEBUG
struct CardView_Previews : PreviewProvider {
  static var previews: some View {
    Widget(
      viewModel: CardViewModel(lateralPublisher: EnvironmentObjects.shared.syncService.coalescedLateralsPublisher()),
      render: CardView.init
    )
  }
}
#endif
