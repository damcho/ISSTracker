//
//  RemoteISSTrackerLoader.swift
//  ISSTracker
//
//  Created by Damian Modernell on 5/31/20.
//  Copyright © 2020 Damian Modernell. All rights reserved.
//

import Foundation

public typealias QueryResut = (ISSTrackerPositionLoaderResult) -> ()

public protocol ISSTrackerPositionLoader {
    func loadISSPosition( completionHandler: @escaping QueryResut)
}

public enum ISSTrackerPositionLoaderResult {
    case success(ISSTrackerPosition)
    case error(ISSTrackerLoaderError)
}

public enum ISSTrackerLoaderError: Error {
    case Connectivity
    case InvalidData
}


public final class RemoteISSTrackerPositionLoader {
    
    private struct ISSTrackerPositionCodable: Codable {
        
        let timestamp: CLongLong
        let codableCoordinate: CoordinateCodable
        
        enum CodingKeys: String, CodingKey {
            case codableCoordinate = "iss_position"
            case timestamp = "timestamp"
        }
        
        var issPosition: ISSTrackerPosition {
            return ISSTrackerPosition(coordinate: codableCoordinate.coordinate, timestamp: TimeInterval(timestamp))
        }
    }

    private struct CoordinateCodable :Codable {
        let latitude:String
        let longitude:String
        
        var coordinate: Coordinate {
            return Coordinate(latitude: Double(string:latitude) ?? 0, longitude: Double(string:longitude) ?? 0)
        }
    }
    
    let httpClient: HTTPClient
    let url: URL
    public init(client: HTTPClient, url: URL) {
        self.httpClient = client
        self.url = url
    }
}

extension RemoteISSTrackerPositionLoader: ISSTrackerPositionLoader {
    public func loadISSPosition( completionHandler: @escaping QueryResut) {
        httpClient.getData(from: self.url, completionHandler: { [weak self] (result) in
            guard self != nil else { return }
            
            switch result {
            case .success(let httpResponse, let data):
                guard httpResponse.statusCode == 200,
                    let codableISSPosition = try? JSONDecoder().decode(ISSTrackerPositionCodable.self, from: data) else {
                    completionHandler(.error(.InvalidData))
                    return
                }
                let issTrackerPosition = codableISSPosition.issPosition
                completionHandler(.success(issTrackerPosition))
            case .error:
                completionHandler(.error(.Connectivity))
            }
        })
    }
}
