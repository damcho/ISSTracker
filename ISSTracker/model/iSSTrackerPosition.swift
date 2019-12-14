//
//  iSSTrackerPosition.swift
//  ISSTracker
//
//  Created by Damian Modernell on 27/09/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation

struct ISSTrackerPosition: Codable {
    
    let timestamp: CLongLong
    let coordinate: Coordinate
    
    enum CodingKeys: String, CodingKey {
        case coordinate = "iss_position"
        case timestamp = "timestamp"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        timestamp = try container.decode(CLongLong.self, forKey: .timestamp)
        coordinate = try container.decode(Coordinate.self, forKey: .coordinate)
    }
}

struct Coordinate :Codable {
    let latitude:Double
    let longitude:Double
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        latitude = Double(string: try container.decode(String.self, forKey: .latitude)) ?? 0.0
        longitude = Double(string: try container.decode(String.self, forKey: .longitude)) ?? 0.0
    }
}

