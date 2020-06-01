//
//  ISSTrackerApiConnector.swift
//  ISSTracker
//
//  Created by Damian Modernell on 27/09/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation
import Alamofire

public enum HTTPClientResult {
    case success(HTTPURLResponse, Data)
    case error(Error)
}
public protocol HTTPClient {
    func getData(from url: URL, completionHandler: @escaping (HTTPClientResult) -> Void)
}

class ISSTrackerConnector {
    
    let scheme = "http://"
    let host = "api.open-notify.org"
    let path = "/iss-now.json"
    
    typealias QueryResut = (ISSTrackerPositionCodable?, Error?) -> ()
    
    func getISSPosition( completionHandler: @escaping QueryResut) {
        let url = scheme + host + path
        if let urlComponents = URLComponents(string: url) {
            guard let url = urlComponents.url else { return }
            self.requestISSPosition(url: url, completionHandler: completionHandler)
        }
    }
    
    func requestISSPosition(url: URL, completionHandler: @escaping QueryResut){
        let error = NSError(domain: "error", code: 1, userInfo: [ NSLocalizedDescriptionKey: "Malformed data received from fetchAllRooms service"])
        Alamofire.request(url, method: .get)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let jsonData = response.data {
                        let decoder = JSONDecoder()
                        do {
                            let position = try decoder.decode(ISSTrackerPositionCodable.self, from: jsonData)
                            completionHandler(position, nil)
                        } catch {
                            completionHandler(nil,error)
                        }
                    } else {
                        completionHandler(nil,error)
                    }
                case .failure:
                    completionHandler(nil,error)
                }
        }
    }
}

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
