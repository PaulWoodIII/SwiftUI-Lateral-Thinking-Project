//
//  main.swift
//  Lateral Thinking
//
//  Created by Paul Wood on 8/10/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import Foundation
import UIKit

let appDelegateClass: AnyClass = NSClassFromString("TestingAppDelegate") ?? AppDelegate.self
UIApplicationMain(
  CommandLine.argc,
  CommandLine.unsafeArgv,
  nil,
  NSStringFromClass(appDelegateClass)
)
