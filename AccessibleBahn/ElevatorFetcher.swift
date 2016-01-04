//
//  ElevatorFetcher.swift
//  AccessibleBahn
//
//  Created by Lukas Schmidt on 30.12.15.
//  Copyright © 2015 Lukas Schmidt. All rights reserved.
//

import Foundation

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
        let description = elevatorData["description"] as? String
        let longitude = elevatorData["geocoordX"] as! Double
        let latitude = elevatorData["geocoordY"] as! Double
        let location = Location(latitude: latitude, longitude: longitude)
        
        return Elevator(status: ElevatorStatus.statusFromString(state), description: description, location: location)
    }
}
