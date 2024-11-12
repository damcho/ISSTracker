//
//  EventsLoggerDecorator.swift
//  ISSTracker
//
//  Created by Damian Modernell on 12/11/24.
//  Copyright © 2024 Damian Modernell. All rights reserved.
//
import Foundation

public protocol Logger {
    func logEvent(_ message: String)
}

public struct EventsLoggerDecorator<T> {
    let Logger: Logger
    let decoratee: T
    public init(Logger: Logger, decoratee: T) {
        self.Logger = Logger
        self.decoratee = decoratee
    }
    public func logEvent(_ message: String) {
        Logger.logEvent(message)
    }
}

extension EventsLoggerDecorator: HTTPClient where T: HTTPClient {
    public func getData(from url: URL, completionHandler: @escaping (HTTPClientResult) -> Void) {
        logEvent("performing request to \(url.absoluteString)")
        decoratee.getData(from: url, completionHandler: completionHandler)
    }
}
