//
//  FirebaseLogger.swift
//  ISSTracker
//
//  Created by Damian Modernell on 15/11/24.
//  Copyright © 2024 Damian Modernell. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseAnalytics

class FirebaseLogger {
    static let sharedInstance = FirebaseLogger()
    
    private init() {
        FirebaseApp.configure()
    }
}

extension FirebaseLogger: Logger {
    func logEvent(_ message: String) {
        Analytics.logEvent(message, parameters: nil)
    }
}
