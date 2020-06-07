//
//  AppComposer.swift
//  ISSTracker
//
//  Created by Damian Modernell on 6/7/20.
//  Copyright © 2020 Damian Modernell. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

class AppComposer {
    static func build() -> UIViewController{
        GMSServices.provideAPIKey("AIzaSyAVIvISQPshSOtqRHKu7eZ3zrARhXC6bMI")
        return UIViewController()
    }
}
