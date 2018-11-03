//
//  ISSTrackerApiConnector.swift
//  ISSTracker
//
//  Created by Damian Modernell on 27/09/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation


class ISSTrackerConnector {
    
    let defaultSession:URLSession
    var dataTask: URLSessionDataTask?
    var errorMessage:String?
    let baseURL = "http://api.open-notify.org/iss-now.json"
    typealias QueryResut = (ISSTrackerPosition?, String?) -> ()

    init() {
        defaultSession = URLSession(configuration: .default)
    }
    
    
    func getISSPosition( completionHandler: @escaping QueryResut) {
        
        if let urlComponents = URLComponents(string: baseURL) {
            print(urlComponents)
            guard let url = urlComponents.url else { return }
            self.requestWeatherData(url: url, completionHandler: completionHandler)
        }
    }
    
    func requestWeatherData(url: URL, completionHandler: @escaping (ISSTrackerPosition?, String?) -> ()){
        
        dataTask = defaultSession.dataTask(with: url) { data, response, error in
            defer {
                self.dataTask = nil
            }
            if let error = error {
                self.errorMessage = "DataTask error: " + error.localizedDescription + "\n"
                DispatchQueue.main.async {
                    completionHandler(nil, self.errorMessage)
                    self.errorMessage = nil
                }
            } else if let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                let trackerposition = try? ISSTrackerPosition(data: data)
                let string1 = String(data: data, encoding: String.Encoding.utf8) ?? "Data could not be printed"
                print(string1)
                if trackerposition == nil {
                    self.errorMessage = "error al desencodear data del JSON"
                }
                DispatchQueue.main.async {
                    completionHandler(trackerposition,self.errorMessage )
                }
            }
        }
        dataTask?.resume()
    }
}
