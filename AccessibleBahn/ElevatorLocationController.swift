//
//  ElevatorLocationController.swift
//  AccessibleBahn
//
//  Created by Lukas Schmidt on 31.12.15.
//  Copyright © 2015 Lukas Schmidt. All rights reserved.
//

import UIKit
import MapKit

class ElevatorLocationController: UIViewController {
    var station: Station!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        title = station.name
        guard let locationRegion = station.elevators?.first?.location.locationCoordinate else { return }
        for elevator in station.elevators! {
            let dropPin = MKPointAnnotation()
            dropPin.title = elevator.description
            dropPin.coordinate = elevator.location.locationCoordinate
            mapView.addAnnotation(dropPin)
        }
        let region = MKCoordinateRegion(center: locationRegion, span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002))
        mapView.setRegion(region, animated: true)
        CLLocationManager().requestWhenInUseAuthorization()
        mapView.showsUserLocation = true
    }
    
    
}
