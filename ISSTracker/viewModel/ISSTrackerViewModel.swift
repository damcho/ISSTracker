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
        intervalTimer = Timer.scheduledTimer(timeInterval: settingsObject.timeInterval, target: self, selector: #selector(updateISSPosition), userInfo: nil, repeats: true)
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
