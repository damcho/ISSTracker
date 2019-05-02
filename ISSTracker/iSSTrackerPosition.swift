//
//  iSSTrackerPosition.swift
//  ISSTracker
//
//  Created by Damian Modernell on 27/09/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation

class ISSTrackerPosition {
    
    let latitude:Double
    let longitude:Double
    let timestamp:CLongLong
    
    init?(data:Dictionary<String, Any>) throws {
        
        guard let position = data["iss_position"] as? Dictionary<String, String> else {
            return nil
        }
        
        guard let latitude = Double(position["latitude"]!)  else {
            return nil
        }
        self.latitude = latitude
        
        guard let longitude = Double(position["longitude"]!)  else {
            return nil
        }
        self.longitude = longitude
        
        guard let timestamp = data["timestamp"] as? CLongLong else {
            return nil
        }
        self.timestamp = timestamp
    }
}

