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
    Intro(image: "weather1", title: "Welcome to Bob's Weather", description: "Pretoria : 23°C, partly cloudy", color: .teal),
    Intro(image: "weather2", title: "Weather at your fingertips", description: "Jakarta: 9°C, fog & light drizzle", color: .indigo),
    Intro(image: "weather3", title: "Worldwide Coverage in RealTime", description: "Reykjavik: -17°C, heavy snow", color: .gray),
    Intro(image: "weather3", title: "Worldwide Coverage in RealTime", description: "Reykjavik: -17°C, heavy snow", color: .gray),
]

