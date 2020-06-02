//
//  ISSTrackerPositionLoaderTests.swift
//  ISSTrackerTests
//
//  Created by Damian Modernell on 5/29/20.
//  Copyright © 2020 Damian Modernell. All rights reserved.
//

import XCTest
import ISSTracker

class ISSTrackerPositionLoaderTests: XCTestCase {
    
    func test_ISSTrackerPositionLoader_LoaderInitDoesNotLoadData() {
        let (_ , client) = makeSUT()
        
        XCTAssert(client.requestUrls.isEmpty)
    }
    
    func test_ISSTrackerPositionLoader_LoadsTwiceIfInvokedTwice() {
        let url = URL(string: "http://www.some.com")!
        let (sut, client) = makeSUT(url: url)
        sut.loadISSPosition (completionHandler: { (ISSTrackerPositionLoaderResult) in })
        sut.loadISSPosition (completionHandler: { (ISSTrackerPositionLoaderResult) in })
        XCTAssertEqual(client.requestUrls, [url, url])
    }
    
    func test_ISSTrackerPositionLoader_DeliversErrorOnHTTPClientError() {
        let (sut, client) = makeSUT()
        
        expect(sut, tocompletewith: .error(.Connectivity), when: {
            let clientError = NSError(domain: "Connection error", code: 1)
            client.completeWith(clientError)
        })
    }
    
    func test_ISSTrackerPositionLoader_DeliversInvalidDataError() {
        let (sut, client) = makeSUT()
        let anyData = Data()
        
        expect(sut, tocompletewith: .error(.InvalidData), when: {
            client.completeWithStatusCode(400, data: anyData)
        })
    }
    
    func test_ISSTrackerPositionLoader_deliversISSPosition_OnValidData() {
        let (sut, client) = makeSUT()
        let (model, data) = makeISSPosition(latitude: 139.1422, longitude: 46.1235, timestamp: 1590926552)
        
        expect(sut, tocompletewith: .success(model), when: {
            client.completeWithStatusCode(200, data: data)
        })
    }
    
    func test_ISSTrackerPositionLoader_deliversInvalidDataError_onInvalidJSON() {
        let (sut, client) = makeSUT()
        
        expect(sut, tocompletewith: .error(.InvalidData), when: {
            let invalidJSON = Data("invalid json".utf8)
            client.completeWithStatusCode(200, data: invalidJSON)
        })
    }
    
    //Helpers
    
    private func expect(_ loader:ISSTrackerPositionLoader, tocompletewith result: ISSTrackerPositionLoaderResult, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        // Arrange
        var capturedResult: ISSTrackerPositionLoaderResult?
        
        // Act
        loader.loadISSPosition (completionHandler: { (result) in
            capturedResult = result
        })
        
        action()
        
        // Assert
        XCTAssertEqual(result, capturedResult, file: file, line: line)
    }
    
    private func makeSUT(url: URL = URL(string: "http://www.anyURL.com")!) -> (ISSTrackerPositionLoader, HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteISSTrackerPositionLoader(client: client, url: url)
        return (sut, client)
    }
    
    private func makeISSPosition(latitude: Double, longitude: Double, timestamp: TimeInterval) -> (model: ISSTrackerPosition, jsonData: Data) {
        let aCoordinate = Coordinate(latitude: latitude, longitude: longitude)
        let ISSposition = ISSTrackerPosition(coordinate: aCoordinate, timestamp: timestamp)
        
        let ISSCoordinate = ["longitude": "\(longitude)", "latitude": "\(latitude)"]
        let ISSPositinJSON = ["iss_position": ISSCoordinate, "timestamp": timestamp] as [String : Any]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: ISSPositinJSON)
        return (ISSposition, jsonData)
    }
    
    private class HTTPClientSpy: HTTPClient {
        
        var messages: [(url: URL, completion: (HTTPClientResult) -> Void)] = []
        var requestUrls: [URL] {
            return messages.map( { $0.url })
        }
        func getData(from url: URL, completionHandler: @escaping (HTTPClientResult) -> Void) {
            messages.append((url, completionHandler))
        }
        
        func completeWith(_ error: Error, at index: Int = 0) {
            messages[index].completion(.error(error))
        }
        
        func completeWithStatusCode(_ code: Int, data: Data, at index: Int = 0) {
            let httpResponse = HTTPURLResponse(url: self.requestUrls[index], statusCode: code, httpVersion: nil, headerFields: nil)!
            messages[index].completion(.success(httpResponse, data))
        }
    }
}
