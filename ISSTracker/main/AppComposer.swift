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
        let httpClient = AlamofireHTTPClient()
      
        let viewModel = compose(
            with: EventsLoggerDecorator(
                Logger: analyticsLogger,
                decoratee: httpClient
            ),
            logger: analyticsLogger
        )
        let issTrackerVC = UINavigationController(rootViewController: ISSTrackerViewController(viewModel: viewModel))
      
        return issTrackerVC
    }
}

extension AppComposer {
    static func compose(with httpclient: some HTTPClient, logger: Logger) -> ISSTrackerViewModel {
        let remoteISSTrackerLoader = RemoteISSTrackerPositionLoader(client: httpclient, url: URL(string: "http://api.open-notify.org/iss-now.json")!)
        let issPositionLoaderLoggerDecorator = EventsLoggerDecorator(Logger: logger, decoratee: remoteISSTrackerLoader)
        return ISSTrackerViewModel(loader: issPositionLoaderLoggerDecorator)
    }
}
