//
//  ISSTrackerViewModel.swift
//  ISSTracker
//
//  Created by Damian Modernell on 15/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import UserNotifications

class ISSTrackerViewModel: NSObject, LocationNotificationSchedulerDelegate {
    
    private let trackerConnector = ISSTrackerConnector()
    private let locationManager = LocationNotificationsManager()
    let settingsObject = SettingsObject()
    var onFetchPositionError:((Error) -> ())?
    var onFetchPositionSuccess:((ISSTrackerPositionCodable) -> ())?
    var intervalTimer: Timer?

    override init() {
        super.init()
        self.startTasks()
        self.locationManager.delegate = self
    }
    
    func locationPermissionDenied() {
        
    }
    
    func notificationPermissionDenied() {
        
    }
    
    func notificationScheduled(error: Error?) {
        
    }


    
    func stopTasks() {
        if self.intervalTimer != nil {
            self.intervalTimer?.invalidate()
        }
    }
    
    func startTasks() {
        self.stopTasks()
        intervalTimer = Timer.scheduledTimer(timeInterval: settingsObject.timeInterval, target: self, selector: #selector(updateISSPosition), userInfo: nil, repeats: true)
    }
    
    func updateSettings(values:[String:Any?]) {
        self.settingsObject.timeInterval = Double(values["timer"] as! Int)
        self.startTasks()
    }
    
    @objc func updateISSPosition() {
        let completionHandler = {[unowned self] (ISSPosition:ISSTrackerPositionCodable?, error:Error?) -> () in
            guard let ISSPosition = ISSPosition else {
                self.onFetchPositionError?(error!)
                return
            }
            self.onFetchPositionSuccess?(ISSPosition)
        }
        trackerConnector.getISSPosition( completionHandler: completionHandler)
    }
}
