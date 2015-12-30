//
//  Station.swift
//  AccessibleBahn
//
//  Created by Lukas Schmidt on 30.12.15.
//  Copyright © 2015 Lukas Schmidt. All rights reserved.
//

import Foundation

var stationDictionary: [String: Int] {
    let path = NSBundle.mainBundle().pathForResource("stationData", ofType: "plist")
   return  NSDictionary(contentsOfFile: path!) as! [String: Int]
}


struct Station {
    let name: String
    var elevators: [Elevator]?
    
    var stationNumber: Int? {
        let name2 = name.stringByReplacingOccurrencesOfString("(", withString: " (")
        if name2.substringFromIndex(name2.endIndex.predecessor()) != ")" {
            //name2 = name2.stringByReplacingOccurrencesOfString(")", withString: " )")
        }
        return stationDictionary[name2]
    }
    
    mutating func setElevators(elevators: [Elevator]?) {
        self.elevators = elevators
    }
    
    func getStationElevatorStatus() -> ElevatorStatus? {
        return elevators?.reduce(ElevatorStatus.Active, combine: reduceActivity)
    }
}
