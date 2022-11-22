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
    
    for i in stride(from: TimeInterval(currentWeatherTime!.dt), through: Date(timeIntervalSince1970: TimeInterval(currentWeatherTime!.dt + 432_000)).timeIntervalSince1970, by: 86_400) {
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

func forecastMinMax(forecast: Forecast) -> (min :Double, max: Double)? {
    var maxArray : [Double] = []
    var minArray : [Double] = []
    
    let index = forecast.list.firstIndex {
        Date(timeIntervalSince1970: TimeInterval($0.dt)) > Date.now
    }
    
    let finalIndex = forecast.list.firstIndex {
        //$0.dtTxt.contains("00:00:00") //not producing expected results
        Date(timeIntervalSince1970: TimeInterval($0.dt)) > Calendar.current.date(byAdding: DateComponents(hour: 24), to: Date.now) ?? Date.now //changed Boolean test from < to > and now it emits expected results
    }
    
    guard index != nil, finalIndex != nil else {
        return nil
    }
    
    for max in forecast.list[index!...finalIndex!] {
        maxArray.append(max.main.tempMax)
    }
    
    for min in forecast.list[index!...finalIndex!] {
        minArray.append(min.main.tempMin)
    }
    
    let max = maxArray.max()
    let min = minArray.min()
    
    //not producing expected results, have no choice but to iterate over the array slice
    /*
    let max = forecast.list[index!...finalIndex!].max { a, b in
        a.main.tempMax < b.main.tempMax
    }
    
    let min = forecast.list[index!...finalIndex!].max { a, b in
        a.main.tempMax > b.main.tempMax
    }
     */
    
    guard max != nil, min != nil else {
        return nil
    }

    return (min!, max!)
}

func deviceToken() -> String? {
    let token = UIDevice.current.identifierForVendor?.uuidString
    return token
}

func showErrorAlertView (_ alertTitle: String, _ alertMessage: String, handler: @escaping () -> Void) {
    let alertView = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
    let ok = UIAlertAction(title: "Continue", style: .cancel) { _ in handler() }
    
    alertView.addAction(ok)
    
    //Presenting
    let scenes = UIApplication.shared.connectedScenes
    let windowScene = scenes.first as? UIWindowScene
    let window = windowScene?.windows.first
    let rootVC = window?.rootViewController
    rootVC?.present(alertView, animated: true)
}

func showSuccessAlertView (_ alertTitle: String, _ alertMessage: String, handler: @escaping () -> Void) {
    let alertView = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
    let ok = UIAlertAction(title: "OK", style: .default) { _ in handler() }
    
    alertView.addAction(ok)
    
    //Presenting
    let scenes = UIApplication.shared.connectedScenes
    let windowScene = scenes.first as? UIWindowScene
    let window = windowScene?.windows.first
    let rootVC = window?.rootViewController
    rootVC?.present(alertView, animated: true)
}
