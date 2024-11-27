//
//  HTTPClientTests.swift
//  ISSTrackerTests
//
//  Created by Damian Modernell on 6/3/20.
//  Copyright © 2020 Damian Modernell. All rights reserved.
//

import XCTest
import ISSTracker

class HTTPClientTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        HTTPClientStub.resetStubs()
    }
    
    override class func tearDown() {
        URLProtocol.unregisterClass(HTTPClientStub.self)
        super.tearDown()
    }
    
    func test_httpclient_delivers_errorOnhttpError() {
        let sut = makeSUT()
        let aURL = anyURL()
        let stubError = anyError()
        
        expect(sut, toCompleteWith: .error(stubError), onRequest: aURL, when: {
            HTTPClientStub.stub(aURL, with: nil, response: nil, error: stubError)
        })
    }
    
    func test_httpclient_delivers_dataOn200Response() {
        let sut = makeSUT()
        let url = anyURL()
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        let data = someData()
        
        expect(sut, toCompleteWith: .success(response, data), onRequest: url, when: {
            HTTPClientStub.stub(url, with: data, response: response, error: nil)
        })
    }
    
    // Helpers
    private func expect(_ sut: HTTPClient, toCompleteWith expectedResult: HTTPClientResult, onRequest url: URL, when stub: () -> Void, file: StaticString = #file, line: UInt = #line) {
        
        let expect = expectation(description: "expect delivers data on 200 response")
        
        stub()
        
        sut.getData(from: url) { (result) in
            switch (result, expectedResult) {
            case (.error, .error):
                break
            case (.success(let receivedResponse, let receivedData), .success( let expectedResponse, let expectedData)):
                XCTAssertEqual(receivedResponse.statusCode, expectedResponse.statusCode, file: file, line: line)
                XCTAssertEqual(receivedData, expectedData, file: file, line: line)
            default:
                XCTFail()
            }
            expect.fulfill()
        }
        
        wait(for: [expect], timeout: 1.0)
    }
    
    private func someData() -> Data {
        return Data("{}".utf8)
    }
    
    private func anyURL() -> URL {
        return URL(string: "https://www.any-url.com")!
    }
    
    private func anyError() -> NSError {
        return NSError(domain: "some error", code: 1)
    }
    
    private func makeSUT() -> HTTPClient {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses?.insert(HTTPClientStub.self, at: 0)
        return AlamofireHTTPClient(configuration: configuration)
    }
}

private struct Stub{
    let data: Data?
    let response: HTTPURLResponse?
    let error: Error?
}

private class HTTPClientStub: URLProtocol {
    
    static var stubs: [URL : Stub] = [:]
    
    static func resetStubs() {
        HTTPClientStub.stubs = [:]
    }
    
    static func stub(_ url: URL, with data: Data?, response: HTTPURLResponse?, error: Error?) {
        let stub = Stub(data: data, response: response, error: error)
        stubs[url] = stub
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
        guard let url = request.url else { return false }
        return HTTPClientStub.stubs[url] != nil
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let url = request.url, let stub = HTTPClientStub.stubs[url] else { return }
        if let error = stub.error {
            client?.urlProtocol(self, didFailWithError: error)
        }
        if let data = stub.data {
            client?.urlProtocol(self, didLoad: data)
        }
        if let response = stub.response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() { }
}
