//
//  LocationViewModel.swift
//  Bob's Weather
//
//  Created by Simbarashe Dombodzvuku on 9/29/22.
//

import SwiftUI
import CoreLocation

class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var authorizationStatus: CLAuthorizationStatus
    @Published public var lastSeenLocation: CLLocation?
    @Published var currentPlacemark: CLPlacemark?
    @Published var favourited: [CLLocation : CLPlacemark] = [:]
    public static var shared = LocationViewModel()
    
    private let locationManager: CLLocationManager
    
    override init() {
        locationManager = CLLocationManager()
        authorizationStatus = locationManager.authorizationStatus
        
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastSeenLocation = locations.first
        fetchCountryAndCity(for: locations.first)
    }

    func fetchCountryAndCity(for location: CLLocation?) {
        guard let location = location else { return }
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            self.currentPlacemark = placemarks?.first
        }
    }
    
    func addFavourite(){
        if (lastSeenLocation != nil) {
            //favourited.append([lastSeenLocation!: currentPlacemark!])
            favourited[lastSeenLocation!] = currentPlacemark!
        }
    }
}

extension LocationViewModel {
    static var antarctica: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: -80.362542, longitude: 20.562968)
    }
}
