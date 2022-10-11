//
//  IntroModel.swift
//  Bob's Weather
//
//  Created by Simbarashe Dombodzvuku on 10/7/22.
//

import Foundation
import SwiftUI

struct Intro: Identifiable {
    var id = UUID().uuidString
    var image: String
    var title: String
    var description: String
    var color: Color
}

var intros: [Intro] = [
    Intro(image: "sun.haze.fill", title: "Welcome to Bob's Weather", description: "Pretoria : 23°C", color: .mint),
    Intro(image: "cloud.sun.rain.fill", title: "Weather at your fingertips", description: "Jakarta: 9°C", color: .brown),
    Intro(image: "cloud.sun.bolt.fill", title: "Worldwide Coverage", description: "Reykjavik: -17°C", color: .yellow),
]

