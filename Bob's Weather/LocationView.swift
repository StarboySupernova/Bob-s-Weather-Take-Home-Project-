//
//  LocationView.swift
//  Bob's Weather
//
//  Created by Simbarashe Dombodzvuku on 10/9/22.
//

import SwiftUI

struct LocationView: View {
    @StateObject var locationManager: LocationManager = LocationManager()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Latitude: \(locationManager.location?.coordinate.latitude.description ?? "")")
            Text("Longitude: \(locationManager.location?.coordinate.longitude.description ?? "")")
        }
    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView()
    }
}
