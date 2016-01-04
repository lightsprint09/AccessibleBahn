//
//  Location.swift
//  AccessibleBahn
//
//  Created by Lukas Schmidt on 02.01.16.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//

import Foundation
import CoreLocation

public struct Location {
    public let latitude: Double
    public let longitude: Double
}

public extension Location {
    public var locationCoordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}