//
//  iSSTrackerPosition.swift
//  ISSTracker
//
//  Created by Damian Modernell on 27/09/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation

public struct ISSTrackerPosition: Equatable {

    let coordinate: Coordinate
    let timestamp: TimeInterval
    
    public init(coordinate: Coordinate, timestamp: TimeInterval) {
        self.coordinate = coordinate
        self.timestamp = timestamp
    }
}

public struct Coordinate: Equatable{
    let latitude:Double
    let longitude:Double
    
    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

