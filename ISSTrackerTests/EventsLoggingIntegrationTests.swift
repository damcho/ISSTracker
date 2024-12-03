//
//  EventsLoggingIntegrationTests.swift
//  ISSTrackerTests
//
//  Created by Damian Modernell on 3/12/24.
//  Copyright © 2024 Damian Modernell. All rights reserved.
//

import XCTest
@testable import ISSTracker

extension AppComposer {
    static func compose(with httpclient: some HTTPClient, logger: Logger) -> ISSTrackerViewModel {
        let remoteISSTrackerLoader = RemoteISSTrackerPositionLoader(client: httpclient, url: URL(string: "http://api.open-notify.org/iss-now.json")!)
        let issPositionLoaderLoggerDecorator = EventsLoggerDecorator(Logger: logger, decoratee: remoteISSTrackerLoader)
        return ISSTrackerViewModel(loader: issPositionLoaderLoggerDecorator)
    }
}

class EventsLoggingIntegrationTests: XCTestCase {

    func test_logs_connectivity_error_on_http_request_failure() {
        // GIVEN
        let expectation = expectation(description: "wait for a failure http response to log error")
        let sut = makeSUT { message in
            expectation.fulfill()
            XCTAssertEqual(message, ISSTrackerLoaderError.Connectivity.localizedDescription)
        }
        
        // WHEN
        sut.updateISSPosition()
        
        // THEN
        wait(for: [expectation], timeout: 1)
    }

}

extension EventsLoggingIntegrationTests {
    func makeSUT(onLoggingCalled: @escaping (String) -> Void) -> ISSTrackerViewModel {
        AppComposer.compose(
            with: AlwaysFailingHTTPClient(),
            logger: DummyLogger(onLoggingCalled: onLoggingCalled)
        )
    }
}

struct AlwaysFailingHTTPClient: HTTPClient {
    func getData(from url: URL, completionHandler: @escaping (ISSTracker.HTTPClientResult) -> Void) {
        completionHandler(.error(anyError))
    }
}

var anyError: Error {
    return NSError(domain: "", code: 0)
}
