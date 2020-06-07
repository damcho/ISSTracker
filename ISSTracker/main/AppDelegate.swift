//
//  AppDelegate.swift
//  ISSTracker
//
//  Created by Damian Modernell on 27/09/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import UIKit
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let rootVC = AppComposer.build()
        GMSServices.provideAPIKey("AIzaSyAVIvISQPshSOtqRHKu7eZ3zrARhXC6bMI")
        return true
    }
}

