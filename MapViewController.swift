//
//  MapViewController.swift
//  HackerBooks
//
//  Created by Verónica Cordobés on 30/9/16.
//  Copyright © 2016 Verónica Cordobés. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate {

    let location : CLLocation
    let regionRadius: CLLocationDistance = 1000
    
    init(location: CLLocation){
        self.location = location
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centerMapOnLocation(location)
        
        self.mapView.delegate = self
        
        
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = location.coordinate
        dropPin.title = "Here you were"
        mapView.addAnnotation(dropPin)
    }

    func centerMapOnLocation(_ location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }

}
