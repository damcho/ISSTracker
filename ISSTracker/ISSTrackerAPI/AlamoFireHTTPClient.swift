//
//  AlamoFireHTTPClient.swift
//  ISSTracker
//
//  Created by Damian Modernell on 6/1/20.
//  Copyright © 2020 Damian Modernell. All rights reserved.
//

import Foundation
import Alamofire

final class AlamoFireHTTPClient: HTTPClient {
    func getData(from url: URL, completionHandler: @escaping (HTTPClientResult) -> Void) {
        Alamofire.request(url, method: .get)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let HTTPResponse = response.response, let data = response.data {
                        completionHandler(.success(HTTPResponse, data))
                    } else {
                        let error = NSError(domain: "unknown error", code: 1)
                        completionHandler(.error(error))
                    }
                case .failure( let error):
                    completionHandler(.error(error))
                }
        }
    }
}
