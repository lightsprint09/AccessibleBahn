//
//  StationTableViewController.swift
//  AccessibleBahn
//
//  Created by Lukas Schmidt on 30.12.15.
//  Copyright © 2015 Lukas Schmidt. All rights reserved.
//

import UIKit

class StationTableViewController: UITableViewController {
    var stations: [Station]!
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stations.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("stationCell", forIndexPath: indexPath)
        guard let stationCell = cell as? StationCell else { return cell }
        stationCell.configureWithStation(stations[indexPath.row])
        
        return stationCell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let locationController = segue.destinationViewController as? ElevatorLocationController, let indexPath = tableView.indexPathForSelectedRow {
            locationController.station = stations[indexPath.row]
        }
    }
    @IBAction func saveTrip(sender: UIBarButtonItem) {
        let trip = Trip(stops: stations)
        TripsTableViewController.trips.append(trip)
        sender.enabled = false
    }
}
