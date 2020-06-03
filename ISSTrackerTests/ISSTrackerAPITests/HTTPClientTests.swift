//
//  HTTPClientTests.swift
//  ISSTrackerTests
//
//  Created by Damian Modernell on 6/3/20.
//  Copyright © 2020 Damian Modernell. All rights reserved.
//

import XCTest
import ISSTracker
import Alamofire

final class AFHTTPClient :HTTPClient {
    
    private let sessionManager: SessionManager
    
    init(configuration: URLSessionConfiguration = .default) {
        self.sessionManager = Alamofire.SessionManager(configuration: configuration)
    }
    
    func getData(from url: URL, completionHandler: @escaping (HTTPClientResult) -> Void) {
        
        self.sessionManager.request(url, method: .get)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .failure(let error):
                    completionHandler(.error(error))
                case .success:
                    if let HTTPResponse = response.response, let data = response.data {
                        completionHandler(.success(HTTPResponse, data))
                    }
                }
        }
    }
}


class HTTPClientTests: XCTestCase {
    
    override func setUp() {
        HTTPClientStub.resetStubs()
    }
    
    override class func tearDown() {
        URLProtocol.unregisterClass(HTTPClientStub.self)
    }
    
    func test_httpclient_delivers_errorOnhttpError() {
        let sut = makeSUT()

        let aURL = URL(string: "https://www.apple.com")!
        let stubError = NSError(domain: "some error", code: 1)
        
        let expect = expectation(description: "error")
        
        HTTPClientStub.stub(aURL, with: nil, response: nil, error: stubError)
        sut.getData(from: aURL) { (result) in
            switch result {
            case .error(let receivedError):
                XCTAssertEqual(receivedError.localizedDescription, stubError.localizedDescription)
            default:
                XCTFail()
            }
            expect.fulfill()
        }
        
        wait(for: [expect], timeout: 1.0)
    }
    
    func test_httpclient_delivers_dataOn200Response() {
        let sut = makeSUT()
        let aURL = URL(string: "https://www.apple.com")!
        let somedata = Data("{}".utf8)
        let expect = expectation(description: "error")
        let response = HTTPURLResponse(url: aURL, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        HTTPClientStub.stub(aURL, with: somedata, response: response, error: nil)
        
        sut.getData(from: aURL) { (result) in
            switch result {
            case .error:
                XCTFail()
            case .success(let receivedResponse, let receivedData):
                XCTAssertEqual(response?.statusCode, receivedResponse.statusCode)
                XCTAssertEqual(somedata, receivedData)
            }
            expect.fulfill()
        }
        
        wait(for: [expect], timeout: 1.0)
    }
    
    // Helpers
    private func makeSUT() -> HTTPClient {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses?.insert(HTTPClientStub.self, at: 0)
        return AFHTTPClient(configuration: configuration)
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
