//
//  Trip.swift
//  AccessibleBahn
//
//  Created by Lukas Schmidt on 02.01.16.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//

import Foundation

struct Trip {
    let stops: [Station]
    
    init(stops: [Station]) {
        guard stops.count > 1 else { fatalError("Trip is more than one stop") }
        self.stops = stops
    }
    
    var from: Station {
        return stops.first!
    }
    
    var to: Station {
        return stops.last!
    }
}
