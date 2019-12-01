//
//  LocationNotificationInfo.swift
//  ISSTracker
//
//  Created by Damian Modernell on 10/06/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import CoreLocation

struct LocationNotificationInfo {
    
    let notificationId: String
    let locationId: String
    
    // Location
    let radius: Double
    let latitude: Double
    let longitude: Double
    
    // Notification
    let title: String
    let body: String
    let data: [String: Any]?
    
    /// CLLocation Coordinates
    var coordinates: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude,
                                      longitude: longitude)
    }
}
