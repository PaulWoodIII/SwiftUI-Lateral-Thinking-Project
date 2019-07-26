//
//  AppDelegate.swift
//  Lateral Thinking macOS
//
//  Created by Paul Wood on 7/24/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import Cocoa
import SwiftUI
import LateralBusinessLogic
import CombineFeedback
import CombineFeedbackUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  var window: NSWindow!

  let syncService = SyncService()
  
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    // Insert code here to initialize your application
    window = NSWindow(
        contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
        styleMask: [.titled, .closable, .miniaturizable, .fullSizeContentView],
        backing: .buffered, defer: false)
    window.center()
    window.setFrameAutosaveName("Main Window")

    let widget = Widget(
      viewModel: CardViewModel(),
      render: CardView.init
    )
    window.contentView = NSHostingView(rootView: widget)

    window.makeKeyAndOrderFront(nil)
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }


}

