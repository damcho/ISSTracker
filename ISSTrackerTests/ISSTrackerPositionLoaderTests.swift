//
//  ISSTrackerPositionLoaderTests.swift
//  ISSTrackerTests
//
//  Created by Damian Modernell on 5/29/20.
//  Copyright © 2020 Damian Modernell. All rights reserved.
//

import XCTest
import ISSTracker

enum ISSTrackerPositionLoaderResult {
    case sccess(ISSTrackerPosition)
    case error(Error)
}

typealias QueryResut = (ISSTrackerPositionLoaderResult) -> ()

struct ISSTrackerPosition {}

class ISSTrackerPositionLoader {
    
    let httpClient: HTTPClient
    let url: URL
    init(client: HTTPClient, url: URL) {
        self.httpClient = client
        self.url = url
    }
    
    func loadISSPosition( completionHandler: @escaping QueryResut) {
        httpClient.getData(from: url)
    }

}

protocol HTTPClient {
    func getData(from: URL)
}


class ISSTrackerPositionLoaderTests: XCTestCase {

    func test_ISSTrackerPositionLoaderInitDoesNotLoadData() {
        let (sut, client) = makeSUT()

        XCTAssert(client.requestUrl == nil)
    }
    
    func test_ISSTrackerPositionLoadsCorrectURL() {
        let url = URL(string: "http://www.some.com")!
        let (sut, client) = makeSUT(url: url)
        sut.loadISSPosition (completionHandler: { (ISSTrackerPositionLoaderResult) in
            
        })
        
        XCTAssertEqual(client.requestUrl, url)
    }
    
    //Helpers
    
    private func makeSUT(url: URL = URL(string: "http://www.anyURL.com")!) -> (ISSTrackerPositionLoader, HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = ISSTrackerPositionLoader(client: client, url: url)
        return (sut, client)
    }
    
    private class HTTPClientSpy: HTTPClient {
        var requestUrl: URL?

        func getData(from url: URL) {
            requestUrl = url
        }
    }
    
   
    

}
