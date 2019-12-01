//
//  LocationManagerProtocol.swift
//  ISSTracker
//
//  Created by Damian Modernell on 10/06/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import UserNotifications

protocol LocationNotificationSchedulerDelegate : UNUserNotificationCenterDelegate {
    
    func locationPermissionDenied()
    
    func notificationPermissionDenied()
    
    func notificationScheduled(error: Error?)
}
