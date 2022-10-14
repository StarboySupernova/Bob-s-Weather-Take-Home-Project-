//
//  FavouritesViewModel.swift
//  Bob's Weather
//
//  Created by Simbarashe Dombodzvuku on 10/4/22.
//

import Foundation
import CoreLocation
import SwiftUI

class FavouritesViewModel: ObservableObject {
    // the actual locations the user has favourited
    @Published var favouriteCities: Set<Locator>
    
    // the key we're using to read/write in UserDefaults
    private let saveKey = "Favoured"
    
    init() {
        favouriteCities = []
        // load our saved data
        
        /*if let data = UserDefaults.standard.data(forKey: saveKey) {
            if let decoded = try? JSONDecoder().decode(Set<Locator>.self, from: data) {
                self.favouriteCities = decoded
            }
        }*/
        do {
            favouriteCities = try UserDefaults.standard.getObject(forKey: saveKey, castTo: Set<Locator>.self)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getFavouriteCitiesIDs() -> Set<String> { //may need to return this as an array
        var favourites: Set<String> = []
        for i in self.favouriteCities {
            favourites.insert(i.name)
        }
        
        return favourites
        //Set(self.favouriteCities.map{$0.name})
    }
    func isEmpty() -> Bool {
        self.favouriteCities.count < 1
    }
    
    func contains(_ city: String) -> Bool {
        if favouriteCities.first(where: {$0.name == city}) != nil {
            return true //favouriteCities.contains(contained)
        } else {
            return false
        }
    }
    
    func add(_ city: Locator) {
        objectWillChange.send()
        favouriteCities.insert(city)
        //favouriteCities.append(city)
        save()
    }
    
    // removes the city from our set, updates all views, and saves the change
    func remove(_ city: String) {
        if let removed = favouriteCities.firstIndex(where: { $0.name == city}) {
            objectWillChange.send()
            favouriteCities.remove(at: removed)
            save()
        }
    }
    
    func save() {
        // write out our data
        do {
            try UserDefaults.standard.setObject(favouriteCities, forKey: saveKey)
        } catch {
            print(error.localizedDescription)
        }
        
        /* if let data = try? JSONEncoder().encode(favouriteCities) {
            UserDefaults.standard.setObject(data, forKey: saveKey)
        }*/
    }
    
    func refresh(){
        do {
            favouriteCities = try UserDefaults.standard.getObject(forKey: saveKey, castTo: Set<Locator>.self)
        } catch {
            print(error.localizedDescription)
        }
    }
}
