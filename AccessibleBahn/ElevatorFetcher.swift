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

enum ElevatorFecthError: ErrorType {
    case MissingStationNumber
    case NetworkError(NSError)
    case ParseError(NSData?)
}

class ElevatorFetcher: NSObject {
    let baseURL = NSURL(string: "http://adam.noncd.db.de")
    let session = NSURLSession.sharedSession()
    
    func fetchElevator(station: Station, onSucces:([Elevator])->Void, onError:(ElevatorFecthError)->()) {
        guard let stationNumber = station.stationNumber,
            let url = NSURL(string: "/api/v1.0/stations/\(stationNumber)", relativeToURL: baseURL) else {
            onError(.MissingStationNumber)
            return
        }
        print(station.name, url.absoluteString)
        let dataTaks = session.dataTaskWithURL(url) {data , _ , error in
            if let error = error {
                return onError(.NetworkError(error))
            }
            do {
                let elevators = try self.parseElevators(data!)
                onSucces(elevators)
            }catch{
               print(NSString(data: data!, encoding: NSUTF8StringEncoding))
                onError(.ParseError(data))
            }
        }
        dataTaks.resume()
    }
    
    func fetchElevatorsForTrip(stops:[Station], onSucces:([Station], ElevatorStatus)->Void, onError:(ElevatorFecthError)->()) {
        var finalList = [Elevator]()
        var stations = [Station]()
        var processedStations = 0 {
            didSet {
                if processedStations == stops.count {
                    let statusCombind = finalList.reduce(ElevatorStatus.Active, combine: reduceActivity)
                    dispatch_async(dispatch_get_main_queue(), {
                        onSucces(stations, statusCombind)
                    })
                }
            }
        }
        var mappedStationIndex = 0
        _ = stops.map{stop in
            let currentStationIndex = mappedStationIndex
            mappedStationIndex++
            stations.append(stop)
            self.fetchElevator(stop, onSucces: {elevators in
                stations[currentStationIndex].setElevators(elevators)
                finalList.appendContentsOf(elevators)
                processedStations++
                }, onError: {_ in
                    processedStations++
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
