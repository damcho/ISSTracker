//
//  iSSTrackerPosition.swift
//  ISSTracker
//
//  Created by Damian Modernell on 27/09/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation

class ISSTrackerPosition {
    
    
    let latitude:Double
    let longitud:Double
    let timestamp:CLongLong

    
    init(data:Data) throws {
        let trackerDecoder =  try  JSONDecoder().decode(PositionDataDecoder.self, from: data)
        self.latitude = Double(trackerDecoder.position.latitude)!
        self.longitud = Double(trackerDecoder.position.longitude)!
        self.timestamp = trackerDecoder.timeStamp
    }
}


private struct PositionDataDecoder : Decodable {
    
 
    let timeStamp:CLongLong
    let position: Position
    
    enum CodingKeys : String, CodingKey {
        case timestmp = "timestamp"
        case position = "iss_position"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.timeStamp = try container.decode(CLongLong.self, forKey: .timestmp)
        self.position = try container.decode(Position.self, forKey: .position)
    }
}

private struct Position :Decodable {
    let latitude:String
    let longitude:String
}
