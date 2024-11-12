//
//  EventsLoggerDecoratorTests.swift
//  ISSTrackerTests
//
//  Created by Damian Modernell on 12/11/24.
//  Copyright © 2024 Damian Modernell. All rights reserved.
//

import XCTest

protocol Logger {
    func logEvent(_ message: String)
}

struct EventsLoggerDecorator {
    let Logger: Logger
    func logEvent(_ message: String) {
        Logger.logEvent(message)
    }
}

final class EventsLoggerDecoratorTests: XCTestCase {

    func test_calls_logger_on_loggerd_event() {
        // GIVEN
        var didLogEvent = false
        let sut = EventsLoggerDecorator(Logger: DummyLogger(onLoggingCalled: {
            didLogEvent = true
        }))
        
        // WHEN
        sut.logEvent("some event")
        
        // THEN
        XCTAssertTrue(didLogEvent)
    }
}

struct DummyLogger: Logger {
    let onLoggingCalled: () -> Void
    func logEvent(_ message: String) {
        onLoggingCalled()
    }
}
