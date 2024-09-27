//
//  URLSessionHTTPClient.swift
//  ISSTracker
//
//  Created by Damian Modernell on 2/11/22.
//  Copyright © 2022 Damian Modernell. All rights reserved.
//

import Foundation

public class URLSessionHTTPClient {
    let session: URLSession
    
    public init(sesion: URLSession = URLSession.shared) {
        self.session = sesion
    }
}

extension URLSessionHTTPClient: AsyncHTTPClient {
    public func getData(from url: URL) async -> HTTPClientResult {
        do {
            let (data, response) = try await session.data(from: url)
            return .success(response as! HTTPURLResponse, data)
        } catch {
            return .error(error)
        }
    }
}
