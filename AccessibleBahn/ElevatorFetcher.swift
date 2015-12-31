//
//  ElevatorFetcher.swift
//  AccessibleBahn
//
//  Created by Lukas Schmidt on 30.12.15.
//  Copyright © 2015 Lukas Schmidt. All rights reserved.
//

import Foundation
import UIKit.UIColor

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

public struct Location {
    public let latitude: Double
    public let longitude: Double
}

struct Elevator {
    let status: ElevatorStatus
    //let location: Location
}


func reduceActivity(previousStatus: ElevatorStatus, elevator: Elevator) -> ElevatorStatus{
    if previousStatus == .Inactiv || elevator.status == .Inactiv{
        return .Inactiv
    }
    if previousStatus == .Unknown {
        return .Unknown
    }
    return elevator.status
}

class ElevatorFetcher: NSObject {
    let baseURL = NSURL(string: "http://adam.noncd.db.de")
    let session = NSURLSession.sharedSession()
    
    func fetchElevator(station: Station, onSucces:([Elevator])->Void, onError:(NSError)->()) {
        guard let stationNumber = station.stationNumber, let url = NSURL(string: "/api/v1.0/stations/\(stationNumber)", relativeToURL: baseURL) else {
            onError(NSError(domain: "", code: 0, userInfo: nil))
            return }
        print(url.absoluteString)
        let dataTaks = session.dataTaskWithURL(url) {data , _ , _ in
            do {
                let elevators = try self.parseElevators(data!)
                onSucces(elevators)
                
            }catch{
               print(NSString(data: data!, encoding: NSUTF8StringEncoding))
            }
            
        }
        dataTaks.resume()
    }
    
    func fetchElevatorsForTrip(stops:[Station], onSucces:([Station], ElevatorStatus)->Void, onError:(NSError)->()) {
        var finalList = [Elevator]()
        var stations = [Station]()
        var i = 0 {
            didSet {
                if i == stops.count {
                    dispatch_async(dispatch_get_main_queue(), {
                        onSucces(stations, finalList.reduce(ElevatorStatus.Active, combine: reduceActivity))
                    })
                    
                }
            }
        }
        _ = stops.map{stop in
            self.fetchElevator(stop, onSucces: {elevators in
                var stop = stop
                stop.setElevators(elevators)
                stations.append(stop)
                finalList.appendContentsOf(elevators)
                i++
                }, onError: {_ in
                    i++
            })
        }
        
    }
    
    
    
    func parseElevators(data:NSData) throws -> [Elevator] {
        guard let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as? [String: AnyObject], let elevators = json["facilities"] as? [Dictionary<String, AnyObject>] else { return [] }
        
        return elevators.map(parseElevator)
    }
    
    func parseElevator(elevatorData: [String: AnyObject]) -> Elevator {
        let state = elevatorData["state"] as! String
        
        return Elevator(status: ElevatorStatus.statusFromString(state))
    }
}
