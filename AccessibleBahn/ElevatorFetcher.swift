//
//  ElevatorFetcher.swift
//  AccessibleBahn
//
//  Created by Lukas Schmidt on 30.12.15.
//  Copyright © 2015 Lukas Schmidt. All rights reserved.
//

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
}
struct Elevator {
    let status: ElevatorStatus
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
        guard let stationNumber = station.stationNumber, let url = NSURL(string: "/api/v1.0/stations/\(stationNumber)", relativeToURL: baseURL) else { return }
        print(url.absoluteString)
        let dataTaks = session.dataTaskWithURL(url) {data , _ , _ in
            do {
                let elevators = try self.parseElevators(data!)
                onSucces(elevators)
                
            }catch{
            }
            
        }
        dataTaks.resume()
    }
    
    func fetchElevatorsForTrip(stops:[Station], onSucces:([Elevator], ElevatorStatus)->Void, onError:(NSError)->()) {
        var finalList = [Elevator]()
        var i = 0 {
            didSet {
                if i == stops.count {
                    onSucces(finalList, finalList.reduce(ElevatorStatus.Active, combine: reduceActivity))
                }
            }
        }
        _ = stops.map{stop in
            self.fetchElevator(stop, onSucces: {elevators in
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
