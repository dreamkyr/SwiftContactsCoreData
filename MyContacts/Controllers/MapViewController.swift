//
//  MapViewController.swift
//  MyContacts
//
//  Created by dreams on 7/3/19.
//  Copyright © 2019 Dreams. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    var contacts: [Contact] = []
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Map"

        if (contacts.count > 0) {
            let firstLat = contacts[0].address.geo[0]
            let firstLng = contacts[0].address.geo[1]
            let location = CLLocationCoordinate2D(latitude: firstLat, longitude: firstLng)
            let span = MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100)
            let region = MKCoordinateRegion(center: location, span: span)
            mapView.setRegion(region, animated: true)

            self.addPins()
        }
    }
    
    func addPins() {
        for contact in self.contacts {
            let annotation = MKPointAnnotation()
            let lat = contact.address.geo[0]
            let lng = contact.address.geo[1]
            let location = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            annotation.coordinate = location
            annotation.title = contact.username
            annotation.subtitle = contact.name
            mapView.addAnnotation(annotation)
        }
    }
}
