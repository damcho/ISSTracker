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
        let httpClient = AlamofireHTTPClient()
        let remoteISSTrackerLoader = RemoteISSTrackerPositionLoader(client: httpClient, url: URL(string: "http://api.open-notify.org/iss-now.json")!)
        let viewModel = ISSTrackerViewModel(loader: remoteISSTrackerLoader)
        let issTrackerVC = UINavigationController(rootViewController: ISSTrackerViewController(viewModel: viewModel))
      
        return issTrackerVC
    }
}
