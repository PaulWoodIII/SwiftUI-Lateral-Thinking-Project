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
import IntentsUI

public struct CardView : View {
  
  typealias State = CardViewModel.State
  typealias Event = CardViewModel.Event
  
  @SwiftUI.State var showShortcut: Bool = false
  
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
          IntentDonater.donate()
          self.context.send(event: .onTap)
        }
      .edgesIgnoringSafeArea(.all)
      
      
      Text(context.displayText)
        .lineLimit(nil)
        .font(.headline)
        .foregroundColor(Color("TextColor"))
        .onTapGesture {
          IntentDonater.donate()
          self.context.send(event: .onTap)
      }
      
      Button(action: {
        self.showShortcut.toggle()
      }) {
        INUIAddVoiceShortcutButtonRepresentable()
      }.padding()
        .frame(
          minWidth: 0,
          idealWidth:UIScreen.main.bounds.width,
          maxWidth: .infinity,
          minHeight: 0,
          idealHeight: UIScreen.main.bounds.height,
          maxHeight: .infinity,
          alignment: .bottomTrailing
      )
      
    }.frame(minWidth: 0,
            idealWidth:UIScreen.main.bounds.width,
            maxWidth: .infinity,
            minHeight: 0,
            idealHeight: UIScreen.main.bounds.height,
            maxHeight: .infinity,
            alignment: .center)
      .onTapGesture {
        IntentDonater.donate()
        self.context.send(event: .onTap)
    }.gesture(
      DragGesture().onEnded({ _ in
        IntentDonater.donate()
        self.context.send(event: .onTap)
      })
    )
    .sheet(isPresented: $showShortcut) {
      INUIAddVoiceShortcutViewControllerRepresentable()
    }
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
