//
//  ActivityIndicatorViewModel.swift
//  ISSTracker
//
//  Created by Damian Modernell on 22/1/25.
//  Copyright © 2025 Damian Modernell. All rights reserved.
//

import Foundation

final class ActivityIndicatorViewModel: ObservableObject {
    var shouldDisplayActivityIndicator: Bool = false
    
    init(shouldDisplayActivityIndicator: Bool) {
        self.shouldDisplayActivityIndicator = shouldDisplayActivityIndicator
    }
}
