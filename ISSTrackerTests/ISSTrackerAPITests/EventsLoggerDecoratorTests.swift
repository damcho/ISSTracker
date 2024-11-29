//
//  EventsLoggerDecoratorTests.swift
//  ISSTrackerTests
//
//  Created by Damian Modernell on 12/11/24.
//  Copyright © 2024 Damian Modernell. All rights reserved.
//

import XCTest
import ISSTracker

final class EventsLoggerDecoratorTests: XCTestCase {

    func test_calls_logger_on_loggerd_event() {
        // GIVEN
        var didLogEvent = false
        let sut = makeSUT { message in
            didLogEvent = true
        }
        
        // WHEN
        sut.logEvent("some event")
        
        // THEN
        XCTAssertTrue(didLogEvent)
    }
}

extension EventsLoggerDecoratorTests {
    func makeSUT(_ onLoggerCalled: @escaping (String) -> Void) -> EventsLoggerDecorator<Encodable> {
        EventsLoggerDecorator(Logger: DummyLogger(onLoggingCalled: onLoggerCalled), decoratee: EncodableDecoratee())
    }
}

struct EncodableDecoratee: Encodable {}

struct DummyLogger: Logger {
    let onLoggingCalled: (String) -> Void
    func logEvent(_ message: String) {
        onLoggingCalled(message)
    }
}
