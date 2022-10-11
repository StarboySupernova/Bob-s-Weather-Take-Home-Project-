//
//  OnboardingView.swift
//  Bob's Weather
//
//  Created by Simbarashe Dombodzvuku on 10/7/22.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var showHome: Bool
    @Binding var showWalkthrough: Bool
    var body: some View {
        // getting geometry globally as opposed to inside WalkThroughView
        
        GeometryReader { geometry in
            let size = geometry.size
            
            WalkThroughView(showHome: $showHome, showWalkthrough: $showWalkthrough, screenSize: size)
        }
    }
}


struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(showHome: .constant(false), showWalkthrough: .constant(true))
            .preferredColorScheme(.dark)
    }
}
