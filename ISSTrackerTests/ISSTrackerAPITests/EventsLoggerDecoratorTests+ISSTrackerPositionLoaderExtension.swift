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
        expect([ISSTrackerLoaderError.Connectivity.localizedDescription], stubbedResult: .error(.Connectivity))
    }
    
    func test_does_not_log_event_on_position_loaded_successfully() {
        expect([], stubbedResult: .success(
            ISSTrackerPosition(
                coordinate: Coordinate(
                    latitude: 1.0,
                    longitude: 1.0),
                timestamp: 1.0
            )
        ))
    }
}

extension EventsLoggerDecoratorTests {
    func makeISSTrackerPositionLoaderSUT(onLoggingCalled: @escaping (String) -> Void, stubbedResult: ISSTrackerPositionLoaderResult) -> ISSTrackerPositionLoader {
        EventsLoggerDecorator(
            Logger: DummyLogger(onLoggingCalled: onLoggingCalled),
            decoratee: ISSTrackerPositionLoaderStub(stub: stubbedResult)
        )
    }
    
    func expect(_ expectedMessages: [String], stubbedResult: ISSTrackerPositionLoaderResult) {
        // GIVEN
        let expectation = expectation(description: "wait for position loading to respond")
        var receivedLogMessages: [String] = []
        let sut = makeISSTrackerPositionLoaderSUT(
            onLoggingCalled: { message in
                receivedLogMessages.append(message)
            },
            stubbedResult: stubbedResult
        )
        // WHEN
        sut.loadISSPosition { result in
            expectation.fulfill()
            XCTAssertEqual(receivedLogMessages, expectedMessages)
        }
        
        // THEN
        wait(for: [expectation], timeout: 1)
    }
}

struct ISSTrackerPositionLoaderStub: ISSTrackerPositionLoader {
    let stub: ISSTrackerPositionLoaderResult
    func loadISSPosition(completionHandler: @escaping ISSTracker.QueryResut) {
        completionHandler(stub)
    }
}
