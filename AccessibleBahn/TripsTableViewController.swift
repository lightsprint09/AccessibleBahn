//
//  TripsTableViewController.swift
//  AccessibleBahn
//
//  Created by Lukas Schmidt on 02.01.16.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//

import UIKit

class TripsTableViewController: UITableViewController {
    //crazy hack
    static var trips = [Trip]()
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return TripsTableViewController.trips.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TripsTableViewController.trips[section].stops.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("stationCell", forIndexPath: indexPath)
        guard let stationCell = cell as? StationCell else { return cell }
        let station = stationAtIndexPath(indexPath)
        stationCell.configureWithStation(station)
        
        return stationCell
    }
    
    func stationAtIndexPath(indexPath: NSIndexPath) -> Station {
        return TripsTableViewController.trips[indexPath.section].stops[indexPath.row]
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let locationController = segue.destinationViewController as? ElevatorLocationController, let indexPath = tableView.indexPathForSelectedRow {
            let station = stationAtIndexPath(indexPath)
            locationController.station = station
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let trip = TripsTableViewController.trips[section]
        return trip.from.name + " - " + trip.to.name
    }
}
