//
//  ConsoleLogger.swift
//  ISSTracker
//
//  Created by Damian Modernell on 12/11/24.
//  Copyright © 2024 Damian Modernell. All rights reserved.
//

import Foundation

class ConsoleLogger: Logger {
    static let sharedInstance = ConsoleLogger()
    
    private init() {}
    
    func logEvent(_ message: String) {
        print(message)
    }
}
