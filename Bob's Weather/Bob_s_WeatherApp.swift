//
//  Bob_s_WeatherApp.swift
//  Bob's Weather
//
//  Created by Simbarashe Dombodzvuku on 9/3/22.
//

import SwiftUI
import FirebaseCore
import Firebase
import FirebaseFirestore
import FirebaseStorage

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct Bob_s_WeatherApp: App {
    //register app delegate for firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
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
