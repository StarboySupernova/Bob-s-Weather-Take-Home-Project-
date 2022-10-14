//
//  Bob_s_WeatherApp.swift
//  Bob's Weather
//
//  Created by Simbarashe Dombodzvuku on 9/3/22.
//

import SwiftUI

@main
struct Bob_s_WeatherApp: App {
    
    @StateObject var weatherViewModel = WeatherViewModelImplementation(service: WeatherServiceImplementation())
    @StateObject var locationViewModel = LocationViewModel()
    @StateObject var favouritesViewModel =  FavouritesViewModel()
    
    var body: some Scene {
        WindowGroup {
            HeroPageView()
                .environment(\.colorScheme, .dark)
                .environmentObject(weatherViewModel)
                .environmentObject(locationViewModel)
                .environmentObject(favouritesViewModel)
        }
    }
}
