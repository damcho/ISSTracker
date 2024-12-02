//
//  AppComposer.swift
//  ISSTracker
//
//  Created by Damian Modernell on 6/7/20.
//  Copyright © 2020 Damian Modernell. All rights reserved.
//

import Foundation
import UIKit

enum AppComposer {
    static func build() -> UIViewController{
        let analyticsLogger = ConsoleLogger.sharedInstance
        let httpEventsLogger = EventsLoggerDecorator(Logger: analyticsLogger, decoratee: AlamofireHTTPClient())
        let remoteISSTrackerLoader = RemoteISSTrackerPositionLoader(client: httpEventsLogger, url: URL(string: "http://api.open-notify.org/iss-now.json")!)
        let issPositionLoaderLoggerDecorator = EventsLoggerDecorator(Logger: analyticsLogger, decoratee: remoteISSTrackerLoader)
        let viewModel = ISSTrackerViewModel(loader: issPositionLoaderLoggerDecorator)
        let issTrackerVC = UINavigationController(rootViewController: ISSTrackerViewController(viewModel: viewModel))
      
        return issTrackerVC
    }
}
