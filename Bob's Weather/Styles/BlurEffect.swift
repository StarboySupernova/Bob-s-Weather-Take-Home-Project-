//
//  BlurEffect.swift
//  Bob's Weather
//
//  Created by Simbarashe Dombodzvuku on 11/21/22.
//

import SwiftUI

struct Blur: UIViewRepresentable {
    
    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}

struct BlurEffect_Previews: PreviewProvider {
    static var previews: some View {
        Blur(style: .light)
    }
}
