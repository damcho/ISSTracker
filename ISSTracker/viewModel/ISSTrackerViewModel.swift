//
//  ISSTrackerViewModel.swift
//  ISSTracker
//
//  Created by Damian Modernell on 15/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import Foundation

class ISSTrackerViewModel {
    
    let trackerConnector = ISSTrackerConnector()

    let settingsObject = SettingsObject()
    var onFetchPositionError:((Error) -> ())?
    var onFetchPositionSuccess:((ISSTrackerPosition) -> ())?
    var intervalTimer: Timer?

    init() {
        self.startTasks()

    }
    
    func stopTasks() {
        self.intervalTimer?.invalidate()
    }
    
    func startTasks() {
        intervalTimer = Timer.scheduledTimer(timeInterval: settingsObject.timeInterval, target: self, selector: #selector(updateISSPosition), userInfo: nil, repeats: true)
    }
    
    func updateSettings(values:[String:Any?]) {
        self.settingsObject.timeInterval = Double(values["timer"] as! Int)
        self.startTasks()
    }
    
    @objc func updateISSPosition() {
        let completionHandler = {[unowned self] (ISSPosition:ISSTrackerPosition?, error:Error?) -> () in
            if error == nil {
                self.onFetchPositionSuccess?(ISSPosition!)
            } else {
                self.onFetchPositionError?(error!)
            }
        }
        trackerConnector.getISSPosition( completionHandler: completionHandler)
    }
}
