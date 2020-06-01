//
//  RemoteISSTrackerLoader.swift
//  ISSTracker
//
//  Created by Damian Modernell on 5/31/20.
//  Copyright © 2020 Damian Modernell. All rights reserved.
//

import Foundation

public enum ISSTrackerPositionLoaderResult: Equatable {
    case success(ISSTrackerPosition)
    case error(ISSTrackerLoaderError)
}

public typealias QueryResut = (ISSTrackerPositionLoaderResult) -> ()

public enum ISSTrackerLoaderError: Error {
    case Connectivity
    case InvalidData
}

public protocol ISSTrackerPositionLoader {
    func loadISSPosition( completionHandler: @escaping QueryResut)
}

struct ISSTrackerPositionCodable: Codable {
    
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

struct CoordinateCodable :Codable {
    let latitude:String
    let longitude:String
    
    var coordinate: Coordinate {
        return Coordinate(latitude: Double(string:latitude) ?? 0, longitude: Double(string:longitude) ?? 0)
    }
}

public final class RemoteISSTrackerPositionLoader {
    
    let httpClient: HTTPClient
    let url: URL
    public init(client: HTTPClient, url: URL) {
        self.httpClient = client
        self.url = url
    }
}

extension RemoteISSTrackerPositionLoader: ISSTrackerPositionLoader {
    public func loadISSPosition( completionHandler: @escaping QueryResut) {
        httpClient.getData(from: self.url, completionHandler: { (result) in
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
    



