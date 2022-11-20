//
//  Helper Methods.swift
//  Bob's Weather
//
//  Created by Simbarashe Dombodzvuku on 11/19/22.
//

import Foundation
import SwiftUI

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
    //print("this is times now",times)
        
    let res = forecast.list.filter({ weatherList in
        times.contains(weatherList.dt)
    })
    
    /*let _ = print("this is result now", res.map({
        $0.dtTxt
    }))*/
    
    return res
}

func forecastMinMax(forecast: Forecast) -> WeatherList? {
    let currentWeatherTime = forecast.list.first {
        Date(timeIntervalSince1970: TimeInterval($0.dt)) > Date.now
    }
    
    guard currentWeatherTime != nil else {
        return nil
    }
    
    let finalDaysWeatherTime = forecast.list.first {
        $0.dtTxt.contains("00:00:00")
    }
    
    let index = forecast.list.firstIndex {
        Date(timeIntervalSince1970: TimeInterval($0.dt)) > Date.now
    }
    
    let finalIndex = forecast.list.firstIndex {
        $0.dtTxt.contains("00:00:00")
    }
    
    guard index != nil, finalIndex != nil else {
        return nil
    }
    
    let max = forecast.list[index!...finalIndex!].max { a, b in
        a.main.tempMax < b.main.tempMax
    }
    
    let min = forecast.list[index!...finalIndex!].max { a, b in
        a.main.tempMax > b.main.tempMax
    }
    
    print("this is max temperature", max?.main.tempMax)
    //print("This is final day's time", finalDaysWeatherTime?.dtTxt)
    
    return finalDaysWeatherTime
}
