//
//  ISSTrackerViewModel.swift
//  ISSTracker
//
//  Created by Damian Modernell on 15/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import Foundation

final class ISSTrackerViewModel {
    
    private var issTrackerLoader: ISSTrackerPositionLoader
    let settingsObject = SettingsObject()
    var onFetchPositionError:((Error) -> ())?
    var onFetchPositionSuccess:((ISSTrackerPosition) -> ())?
    var intervalTimer: Timer?
    var title = "ISSTracker"
    
    init(loader: ISSTrackerPositionLoader) {
        self.issTrackerLoader = loader
    }
    
    func stopReceivingPositionUpdates() {
        self.intervalTimer?.invalidate()
        self.intervalTimer = nil
    }
    
    func startReceivingPositionUpdates() {
        intervalTimer?.invalidate()
        intervalTimer = Timer.scheduledTimer(timeInterval: settingsObject.timeInterval, target: self, selector: #selector(updateISSPosition), userInfo: nil, repeats: true)
    }
    
    func updateSettings(values:[String:Any?]) {
        self.settingsObject.timeInterval = Double(values["timer"] as! Int)
        self.startReceivingPositionUpdates()
    }
    
    @objc func updateISSPosition() {
        let completionHandler = {[unowned self] (result: ISSTrackerPositionLoaderResult) -> () in
            switch result {
            case .success(let issPosition):
                self.onFetchPositionSuccess?(issPosition)
            case .error(let error):
                self.onFetchPositionError?(error)
            }}
        issTrackerLoader.loadISSPosition(completionHandler: completionHandler)
    }
}
