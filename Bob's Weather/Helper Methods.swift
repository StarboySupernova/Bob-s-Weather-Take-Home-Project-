//
//  Helper Methods.swift
//  Bob's Weather
//
//  Created by Simbarashe Dombodzvuku on 11/19/22.
//

import Foundation

func forecastResultStrip(forecast: Forecast) -> [WeatherList]? {
    var times : [Int] = []

    let currentWeatherTime = forecast.list.first {
        Date(timeIntervalSince1970: TimeInterval($0.dt)) > Date.now
    }
    
    guard currentWeatherTime != nil else {
        return nil
    }
    
    for i in stride(from: TimeInterval(currentWeatherTime!.dt), through: Date(timeIntervalSince1970: TimeInterval(currentWeatherTime!.dt + 432000)).timeIntervalSince1970, by: 86400) {
        times.append(Int(i))
    }
    print("this is times now",times)
        
    let res = forecast.list.filter({ weatherList in
        times.contains(weatherList.dt)
    })
    
    let _ = print("this is result now", res.map({
        $0.dtTxt
    }))
    
    return res
}

