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
        let (sut, client) = makeSUT()
        
        XCTAssert(client.requestUrls.isEmpty)
    }
    
    func test_ISSTrackerPositionLoader_LoadsTwiceIfInvokedTwice() {
        let url = URL(string: "http://www.some.com")!
        let (sut, client) = makeSUT(url: url)
        sut.loadISSPosition (completionHandler: { (ISSTrackerPositionLoaderResult) in
        })
        sut.loadISSPosition (completionHandler: { (ISSTrackerPositionLoaderResult) in
        })
        XCTAssertEqual(client.requestUrls, [url, url])
    }
    
    func test_ISSTrackerPositionLoader_DeliversErrorOnHTTPClientError() {
        let (sut, client) = makeSUT()
        var capturedErrors = [ISSTrackerLoaderError]()
        sut.loadISSPosition (completionHandler: { (result) in
            switch result {
            case .error(let error):
                capturedErrors.append(error)
            default:
                XCTFail("expected error and got data instead")
            }
        })
        let clientError = NSError(domain: "error 400", code: 1)
        client.completeWith(clientError)
        
        XCTAssertEqual(capturedErrors, [.Connectivity])
        
    }
    
    func test_ISSTrackerPositionLoader_DeliversInvalidDataError() {
        let (sut, client) = makeSUT()
        var capturedErrors = [ISSTrackerLoaderError]()
        
        sut.loadISSPosition (completionHandler: { (result) in
            switch result {
            case .error(let error):
                capturedErrors.append(error)
            default:
                XCTFail("expected error and got data instead")
            }
        })
        let anyData = Data()
        client.completeWithStatusCode(400, data: anyData)
        
        XCTAssertEqual(capturedErrors, [.InvalidData])
    }
    
    func test_ISSTrackerPositionLoader_deliversISSPosition_OnValidData() {
        let (sut, client) = makeSUT()
        let aCoordinate = Coordinate(latitude: 139.1422, longitude: 139.1422)
        let aTimestamp: Double = 1590923338
        let ISSposition = ISSTrackerPosition(coordinate: aCoordinate, timestamp: aTimestamp)
        let ISSCoordinate = ["longitude": "139.1422", "latitude": "139.1422"]
        let ISSPositinJSON = ["iss_position": ISSCoordinate, "timestamp": 1590923338] as [String : Any]
        let jsonData = try! JSONSerialization.data(withJSONObject: ISSPositinJSON)
        
        sut.loadISSPosition (completionHandler: { (result) in
            switch result {
            case .success(let position):
                XCTAssertEqual(position, ISSposition)
            case .error:
                XCTFail("expected success and got error instead")
            }
        })
        client.completeWithStatusCode(200, data: jsonData)
    }
    
    func test_ISSTrackerPositionLoader_deliversInvalidDataError_onInvalidJSON() {
        let (sut, client) = makeSUT()
        var capturedErrors = [ISSTrackerLoaderError]()

        sut.loadISSPosition (completionHandler: { (result) in
            switch result {
            case .success:
                XCTFail("expected success and got error instead")
            case .error( let error):
                capturedErrors.append(error)
            }
        })
        let invalidJSON = Data("invalid json".utf8)
        client.completeWithStatusCode(200, data: invalidJSON)
        
        XCTAssertEqual(capturedErrors, [.InvalidData])

    }
    
    
    //Helpers
    
    private func makeSUT(url: URL = URL(string: "http://www.anyURL.com")!) -> (ISSTrackerPositionLoader, HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = ISSTrackerPositionLoader(client: client, url: url)
        return (sut, client)
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
