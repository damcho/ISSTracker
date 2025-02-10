//
//  ActivityIndicatorView.swift
//  ISSTracker
//
//  Created by Damian Modernell on 10/2/25.
//  Copyright © 2025 Damian Modernell. All rights reserved.
//

import SwiftUI

struct ActivityIndicatorView: View {
    @StateObject var viewModel: ActivityIndicatorViewModel
    var body: some View {
        if viewModel.shouldshowActiviryIndicator {
            ProgressView().controlSize(.large)
        }
    }
}

#Preview {
    let viewModel = ActivityIndicatorViewModel()
    viewModel.shouldshowActiviryIndicator = true
    return ActivityIndicatorView(viewModel: viewModel)
}

#Preview {
    let viewModel = ActivityIndicatorViewModel()
    viewModel.shouldshowActiviryIndicator = false
    return ActivityIndicatorView(viewModel: viewModel)
}

