//
//  ISSTrackerApiConnector.swift
//  ISSTracker
//
//  Created by Damian Modernell on 27/09/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation
import Alamofire


class ISSTrackerConnector {
    
    let scheme = "http://"
    let host = "api.open-notify.org"
    let path = "/iss-now.json"

    typealias QueryResut = (ISSTrackerPosition?, Error?) -> ()
    
    func getISSPosition( completionHandler: @escaping QueryResut) {
        let url = scheme + host + path
        if let urlComponents = URLComponents(string: url) {
            guard let url = urlComponents.url else { return }
            self.requestISSPosition(url: url, completionHandler: completionHandler)
        }
    }
    
    func requestISSPosition(url: URL, completionHandler: @escaping QueryResut){
        
        Alamofire.request(url, method: .get)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    guard let data = response.value as? Dictionary<String , Any> else {
                        completionHandler(nil, NSError(domain: "error", code: 1, userInfo: [ NSLocalizedDescriptionKey: "Malformed data received from fetchAllRooms service"]))
                        return
                    }
                    let trackerposition = try? ISSTrackerPosition(data: data)
                    if trackerposition != nil {
                        completionHandler(trackerposition, nil)
                    } else {
                        completionHandler(nil,NSError(domain: "error", code: 1, userInfo: [ NSLocalizedDescriptionKey: "Malformed data received from fetchAllRooms service"]))
                    }
                    
                case .failure:
                    completionHandler(nil, NSError(domain: "error", code: 1, userInfo: [ NSLocalizedDescriptionKey: "Malformed data received from fetchAllRooms service"]))
                }
        }
    }
}
