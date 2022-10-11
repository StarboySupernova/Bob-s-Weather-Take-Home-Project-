//
//  HeroPageView.swift
//  Bob's Weather
//
//  Created by Simbarashe Dombodzvuku on 10/7/22.
//

import SwiftUI

struct HeroPageView: View {
    @State private var showHome: Bool = false
    @State private var showWalkthrough: Bool = true
    
    var body: some View {
        Group {
            if showHome {
                MenuView()
            } else {
                OnboardingView(showHome: $showHome, showWalkthrough: $showWalkthrough)
            }
        }
    }
}

struct HeroPageView_Previews: PreviewProvider {
    static var previews: some View {
        HeroPageView()
    }
}
