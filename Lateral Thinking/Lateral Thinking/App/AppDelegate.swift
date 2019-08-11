//
//  AppDelegate.swift
//  Lateral Thinking
//
//  Created by Paul Wood on 7/21/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import UIKit
import LateralBusinessLogic
import LateralThinking_Persistance

class AppDelegate: UIResponder, UIApplicationDelegate {
  
  let environmentObjects = EnvironmentObjects()

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    return true
  }

  // MARK: UISceneSession Lifecycle

  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration",
                                sessionRole: connectingSceneSession.role)
  }

  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
  }

  func application(_ application: UIApplication,
                   continue userActivity: NSUserActivity,
                   restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
      
      guard userActivity.activityType == NSStringFromClass(LateralIntent.self) else {
        return false
      }
      // The `restorationHandler` passes the user activity to the passed in view controllers to route the user to the part of the app
      // that is able to continue the specific activity. See `restoreUserActivityState` in `OrderHistoryTableViewController`
      // to follow the continuation of the activity further.
      restorationHandler(nil)
      return true
  }
  
  override func restoreUserActivityState(_ activity: NSUserActivity) {
      super.restoreUserActivityState(activity)
      
      if activity.activityType == NSStringFromClass(LateralIntent.self) {
          
      }
  }
  
}

