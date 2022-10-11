//
//  LocationError.swift
//  Bob's Weather
//
//  Created by Simbarashe Dombodzvuku on 9/29/22.
//

import Foundation

enum LocationError: Error {
    case locationRestricted
    case locationDenied
}

extension LocationError: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .locationRestricted :
                return "Error : Location use is restricted"
            case .locationDenied:
                return "Location use denied. Please enable in settings"
        }
    }
}

