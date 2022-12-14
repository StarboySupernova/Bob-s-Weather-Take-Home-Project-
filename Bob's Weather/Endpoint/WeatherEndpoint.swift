//
//  WeatherEndpoint.swift
//  Bob's Weather
//
//  Created by Simbarashe Dombodzvuku on 9/5/22.
//

import Foundation
import CoreLocation

//protocol used here to promote reusability, e.g. when using another API, when can use the same pattern here
protocol APIBuilder {
    var urlRequest: URLRequest {get}
    var baseURL: URL {get}
    var key: String {get} //API key to retrieve the resource
    //func locationProvider(latitude: Double?, longitude: Double?) -> CLLocationCoordinate2D
}

enum OpenWeatherMapAPI {
    case getCurrentWeather
    case getForecast
    //if we have multiple endpoints for our API, we add them here
}

extension OpenWeatherMapAPI: APIBuilder {
    /*func locationProvider(latitude: Double? = nil, longitude: Double? = nil) -> CLLocationCoordinate2D {
        if (latitude == nil) && (longitude == nil) {
            return CLLocationCoordinate2D(latitude: (LocationViewModel.shared.lastSeenLocation?.coordinate.latitude) ?? LocationViewModel.antarctica.latitude, longitude: (LocationViewModel.shared.lastSeenLocation?.coordinate.longitude) ?? LocationViewModel.antarctica.longitude)
        } else {
            return CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        }
    }*/
        
    //we can now define a urlRequest, baseURL and a key for each of our cases in OpenWeatherMapAPI
    var urlRequest: URLRequest {
        return URLRequest(url: self.baseURL)
    }
    
    var baseURL: URL {
        switch self {
            case .getCurrentWeather:
                return URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=-25.750445&lon=28.237550&exclude=minutely,hourly,alerts&units=metric&APPID=\(self.key)")! //should find a way to inject location here
            case .getForecast:
                return URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(LocationViewModel.customLocation?.latitude ?? LocationViewModel.shared.lastSeenLocation?.coordinate.latitude ?? LocationViewModel.antarctica.latitude)&lon=\(LocationViewModel.customLocation?.longitude ?? LocationViewModel.shared.lastSeenLocation?.coordinate.longitude ?? LocationViewModel.antarctica.longitude)&exclude=minutely,hourly,alerts&units=metric&appid=\(self.key)")!
        }
    }
    
    var key: String {
        //return "2b34877d3eca0717964533e84e158244"
        //return "0da0171684aa8f88191ae26e3dfb571d"
        return "1a2176f7883d06ded7ca7e8dc6e19f18"
    }
    
}

