//
//  Elevator.swift
//  AccessibleBahn
//
//  Created by Lukas Schmidt on 02.01.16.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//

import Foundation

struct Elevator {
    let status: ElevatorStatus
    let description: String?
    let location: Location
    
    static func getCorrectWord(count: Int) -> String {
        return  count == 1 ? "Fahrstuhl" : "Fahrstühle"
    }
}