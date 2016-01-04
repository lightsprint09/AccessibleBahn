//
//  ElevatorStatus.swift
//  AccessibleBahn
//
//  Created by Lukas Schmidt on 02.01.16.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//
import UIKit
import Foundation

enum ElevatorStatus {
    case Active, Inactiv, Unknown
    
    static func statusFromString(string: String) -> ElevatorStatus {
        switch string {
        case "ACTIVE":
            return .Active
        case "INACTIVE":
            return .Inactiv
        default:
            return .Unknown
        }
    }
    
    var color: UIColor {
        switch self {
        case .Active:
            return UIColor(red:78 / 255.0, green:167 / 255.0, blue:94 / 255.0, alpha:1.0)
        case .Inactiv:
            return UIColor(red:178 / 255.0, green:42 / 255.0, blue:34 / 255.0, alpha:1.0)
        case .Unknown:
            return UIColor(red:227 / 255.0, green:203 / 255.0, blue:89 / 255.0, alpha:1.0)
        }
    }
    
    var text: String {
        switch self {
        case .Active:
            return "Alle Fahrstühle in Ordnung"
        case .Inactiv:
            return "Defekte Fahrstühle auf Ihrer Route"
        case .Unknown:
            return "Fahrstühle mit unklarem Status auf Ihrer Route"
        }
    }
}