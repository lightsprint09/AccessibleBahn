//
//  StationCell.swift
//  AccessibleBahn
//
//  Created by Lukas Schmidt on 30.12.15.
//  Copyright © 2015 Lukas Schmidt. All rights reserved.
//

import UIKit

class StationCell: UITableViewCell {
    @IBOutlet weak var stationNameLabel: UILabel!
    @IBOutlet weak var stationSubtitleLabel: UILabel!
    @IBOutlet weak var statusView: UIView!
    
    func configureWithStation(station: Station) {
        stationNameLabel.text = station.name
        statusView.backgroundColor = station.getStationElevatorStatus()?.color
        let elevatorCount = station.elevators?.count ?? 0
        stationSubtitleLabel.text = "\(elevatorCount) \(Elevator.getCorrectWord(elevatorCount))"
    }
}
