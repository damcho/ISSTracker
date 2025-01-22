//
//  ActivityIndicatorView.swift
//  ISSTracker
//
//  Created by Damian Modernell on 22/1/25.
//  Copyright © 2025 Damian Modernell. All rights reserved.
//

import SwiftUI

struct ActivityIndicatorView: View {
    @StateObject var activityIndicatorViewModel: ActivityIndicatorViewModel
    
    var body: some View {
        if activityIndicatorViewModel.shouldDisplayActivityIndicator {
            ProgressView().controlSize(.large)
        }
    }
}

#Preview {
    ActivityIndicatorView(
        activityIndicatorViewModel: ActivityIndicatorViewModel(
            shouldDisplayActivityIndicator: false
        )
    )
}

#Preview {
    ActivityIndicatorView(
        activityIndicatorViewModel: ActivityIndicatorViewModel(
            shouldDisplayActivityIndicator: true
        )
    )
}
