//
//  FlatGlassModifier.swift
//  Bob's Weather
//
//  Created by Simbarashe Dombodzvuku on 10/4/22.
//

import Foundation
import SwiftUI

struct FlatGlassView: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(14)
    }
}
