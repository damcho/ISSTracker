//
//  HTTPClientProtocol.swift
//  ISSTracker
//
//  Created by Damian Modernell on 6/1/20.
//  Copyright © 2020 Damian Modernell. All rights reserved.
//

import Foundation

public enum HTTPClientResult {
    case success(HTTPURLResponse, Data)
    case error(Error)
}
public protocol HTTPClient {
    func getData(from url: URL, completionHandler: @escaping (HTTPClientResult) -> Void)
}
