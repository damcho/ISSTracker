//
//  EventsLoggerDecoratorTests+ISSTrackerPositionLoaderExtension.swift
//  ISSTrackerTests
//
//  Created by Damian Modernell on 28/11/24.
//  Copyright © 2024 Damian Modernell. All rights reserved.
//

import XCTest
@testable import ISSTracker

extension EventsLoggerDecorator: ISSTrackerPositionLoader where T: ISSTrackerPositionLoader {
    public func loadISSPosition(completionHandler: @escaping ISSTracker.QueryResut) {
        decoratee.loadISSPosition(completionHandler: { result in
            switch result {
            case let .error(anError):
                logEvent(anError.localizedDescription)
            case .success: break
            }
            completionHandler(result)
        })
    }
}

extension EventsLoggerDecoratorTests {
    func test_logs_connectivity_error_on_position_loading_failure() { 
        // GIVEN
        let expectation = expectation(description: "wait for position loading to fail")
        var loggedErrorCallCount = 0
        let sut = makeISSTrackerPositionLoaderSUT(
            onLoggingCalled: {
                loggedErrorCallCount += 1
            },
            stubbedResult: .error(.Connectivity)
        )
        // WHEN
        sut.loadISSPosition { result in
            expectation.fulfill()
            XCTAssertEqual(loggedErrorCallCount, 1)
        }
        
        // THEN
        wait(for: [expectation], timeout: 1)
    }
    
    func test_does_not_log_event_on_position_loaded_successfully() {
        // GIVEN
        let expectation = expectation(description: "wait for position loading to succeed")
        var loggedErrorCallCount = 0
        let sut = makeISSTrackerPositionLoaderSUT(
            onLoggingCalled: {
                loggedErrorCallCount += 1
            },
            stubbedResult: .success(
                ISSTrackerPosition(
                    coordinate: Coordinate(
                        latitude: 1.0,
                        longitude: 1.0),
                    timestamp: 1.0
                )
            )
        )
        // WHEN
        sut.loadISSPosition { result in
            expectation.fulfill()
            XCTAssertEqual(loggedErrorCallCount, 0)
        }
        
        // THEN
        wait(for: [expectation], timeout: 1)
    }
}

extension EventsLoggerDecoratorTests {
    func makeISSTrackerPositionLoaderSUT(onLoggingCalled: @escaping () -> Void, stubbedResult: ISSTrackerPositionLoaderResult) -> ISSTrackerPositionLoader {
        EventsLoggerDecorator(
            Logger: DummyLogger(onLoggingCalled: onLoggingCalled),
            decoratee: ISSTrackerPositionLoaderStub(stub: stubbedResult)
        )
    }
}

struct ISSTrackerPositionLoaderStub: ISSTrackerPositionLoader {
    let stub: ISSTrackerPositionLoaderResult
    func loadISSPosition(completionHandler: @escaping ISSTracker.QueryResut) {
        completionHandler(stub)
    }
}
