//
//  LandingView.swift
//  Bob's Weather
//
//  Created by Simbarashe Dombodzvuku on 9/6/22.
//

import SwiftUI

struct LandingView: View {
    @State private var fullscreen: Bool = false
    @Binding var selectedTab: String
    
    //hiding tab bar
    init(selectedTab: Binding<String>) {
        self._selectedTab = selectedTab
        UITabBar.appearance().isHidden = true //experiment with isTranslucent
    }
    
    var body: some View {
        //Tab view with tabs
        TabView(selection: $selectedTab) {
            WeatherView()
                .tag("Weather")
            FavouritesListView()
                .tag("Favourites")
        }
    }
    
}

struct LandingView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
            .preferredColorScheme(.dark)
    }
}
