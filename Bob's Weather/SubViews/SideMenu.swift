//
//  SideMenu.swift
//  Bob's Weather
//
//  Created by Simbarashe Dombodzvuku on 9/6/22.
//

import SwiftUI

struct SideMenu: View {
    @Binding var selectedTab: String
    @Namespace var animation
    var prop : Properties?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Spacer()
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Bob's Weather")
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .shadow(radius: 10) //use glow from neumorphism
                    .glow(color: .blue.opacity(0.2), radius: 1)
                    .multilineTextAlignment(.leading)
            }
            .padding(.vertical)
            
            Rectangle()
                .fill(.white.opacity(0.1))
                .frame(height: 1)
                .padding(.horizontal, -15)
            //imperial noon
            
            //tab buttons
            VStack(alignment: .leading, spacing: 10) {
                Spacer()
    
                TabButton(image: "cloud.sun.rain.fill", title: "Weather", selectedTab: $selectedTab, animation: animation)
                TabButton(image: "pin.fill", title: "Favourites", selectedTab: $selectedTab, animation: animation)
                //TabButton(image: "clock", title: "History", selectedTab: $selectedTab, animation: animation)
            }
            .padding(.leading, -15)
            .padding(.top, 250) //use props here
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 6) {
                Text("App version 1.2.0")
                    .font(.caption)
                    .fontWeight(.light)
                    .foregroundColor(.white)
                    .opacity(0.6)
                    .padding(.bottom, 10)
            }
        }
        .padding()
        .frame(maxWidth:.infinity, maxHeight:.infinity, alignment: .topLeading)
        
    }
}

struct SideMenu_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
            .preferredColorScheme(.dark)
    }
}
