//
//  AppDelegate.swift
//  Lateral Thinking tvOS
//
//  Created by Paul Wood on 7/23/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import UIKit
import SwiftUI
import CombineFeedback
import CombineFeedbackUI
import LateralBusinessLogic

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    // Use a UIHostingController as window root view controller
    let window = UIWindow(frame: UIScreen.main.bounds)
    let widget = Widget(
      viewModel: CardViewModel(syncService: EnvironmentObjects.shared.syncService),
      render: CardView.init
    )
    window.rootViewController = UIHostingController(rootView: widget)
    self.window = window
    window.makeKeyAndVisible()
                            
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // Saves changes in the application's managed object context when the application transitions to the background.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

}

