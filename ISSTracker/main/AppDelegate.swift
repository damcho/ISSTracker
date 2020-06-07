//
//  AppDelegate.swift
//  ISSTracker
//
//  Created by Damian Modernell on 27/09/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let rootVC = AppComposer.build()
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
        return true
    }
}

