//
//  LocationManager.swift
//  Bob's Weather
//
//  Created by Simbarashe Dombodzvuku on 10/9/22.
//

// Location Manager as Helper

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject {

    let locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()

    @Published var location: CLLocation?
    @Published var placemark: CLPlacemark?

    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }

    func geoCode(with location: CLLocation) {

        geoCoder.reverseGeocodeLocation(location) { (placemark, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                self.placemark = placemark?.first
            }
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }

        DispatchQueue.main.async {
            self.location = location
            self.geoCode(with: location)
        }

    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // TODO
    }
}
