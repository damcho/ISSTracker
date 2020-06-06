//
//  AlamoFireHTTPClient.swift
//  ISSTracker
//
//  Created by Damian Modernell on 6/1/20.
//  Copyright © 2020 Damian Modernell. All rights reserved.
//

import Foundation
import Alamofire

public struct UnexpectedValuesRepresentation: Error {}

public final class AlamofireHTTPClient :HTTPClient {
    
    private let sessionManager: SessionManager
    

    public init(configuration: URLSessionConfiguration = .default) {
        self.sessionManager = Alamofire.SessionManager(configuration: configuration)
    }
    
    public func getData(from url: URL, completionHandler: @escaping (HTTPClientResult) -> Void) {
        
        self.sessionManager.request(url, method: .get)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .failure(let error):
                    completionHandler(.error(error))
                case .success:
                    guard let HTTPResponse = response.response, let data = response.data else {
                        completionHandler(.error(UnexpectedValuesRepresentation()))
                        return
                    }
                    completionHandler(.success(HTTPResponse, data))
                }
        }
    }
}
