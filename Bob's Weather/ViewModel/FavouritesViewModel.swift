//
//  FavouritesViewModel.swift
//  Bob's Weather
//
//  Created by Simbarashe Dombodzvuku on 10/4/22.
//

import Foundation
import CoreLocation
import SwiftUI
import Firebase
import FirebaseFirestoreSwift

class FavouritesViewModel: ObservableObject {
    // the actual locations the user has favourited
    @Published var favouriteCities: Set<Locator>
    
    // the key we're using to read/write in UserDefaults
    private let saveKey = "Favoured"
    
    init() {
        favouriteCities = []
        let token = deviceToken()
        if token != nil {
            getLocationData(id: token!)
        } else {
            // load our saved data
            
            /*if let data = UserDefaults.standard.data(forKey: saveKey) {
             if let decoded = try? JSONDecoder().decode(Set<Locator>.self, from: data) {
             self.favouriteCities = decoded
             }
             }*/

            //show error alert could not find token
            showErrorAlertView("Error", "Could not find token") {}
            do {
                favouriteCities = try UserDefaults.standard.getObject(forKey: saveKey, castTo: Set<Locator>.self)
            } catch {
                showErrorAlertView("Error", error.localizedDescription) {}
                print(error.localizedDescription)
            }
        }
    }
    
    func first(occurring city: String) -> Locator? {
        if let locator = favouriteCities.first(where: {$0.name == city}) {
            return locator
        } else {
            return nil
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
        var location : [Locator] = []
        objectWillChange.send()
        favouriteCities.insert(city)
        //favouriteCities.append(city)
        location.append(city)
        save()
        guard let token = deviceToken() else {
            //show error alert
            showErrorAlertView("Unable to add to remote server", "Device token not found") {}
            return
        }
        uploadLocation(id: token, locator: location)
    }
    
    // removes the city from our set, updates all views, and saves the change
    func remove(_ city: String) {
        if let removed = favouriteCities.firstIndex(where: { $0.name == city}) {
            objectWillChange.send()
            favouriteCities.remove(at: removed)
            save()
            let removedLocation = favouriteCities.first(where: {$0.name == city})
            guard let token = deviceToken(), removedLocation != nil else {
                //show error
                showErrorAlertView("Unable to remove from remote server", "Device token not found") {}
                return
            }
            deleteLocation(id: token, locator: removedLocation!)
        }
    }
    
    func save() {
        // write out our data
        do {
            try UserDefaults.standard.setObject(favouriteCities, forKey: saveKey)
        } catch {
            print(error.localizedDescription)
            showErrorAlertView("Error saving to memory", error.localizedDescription, handler: {})
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
            showErrorAlertView("Status refresh error", error.localizedDescription, handler: {})
        }
    }
    
    func uploadLocation(id deviceID: String, locator : [Locator]) {
        let db = Firestore.firestore()
        let docRef = db.collection("Favourites").document(deviceID)
        
        docRef.setData(["deviceID" : deviceID]) { err in
            if let err = err {
                print("Error writing document: \(err)")
                showErrorAlertView("Error", err.localizedDescription, handler: {})
            } else {
                print("Document successfully written!")
            }
        }
        
        for loc in locator {
            let locatorValue = loc
            let encoded : [String: Any]
            do {
                //encode the swift struct instance into a dictionary using the Firestore encoder
                encoded = try Firestore.Encoder().encode(locatorValue)
            } catch {
                //encoding error
                showErrorAlertView("Encoding Error", error.localizedDescription, handler: {})
                return
            }
            
            let fieldKey = "favouriteLocations"
            
            // add a new item to the "favouriteLocations" array
            docRef.updateData([fieldKey : FieldValue.arrayUnion([encoded])]) { error in
                guard let error = error else {
                    //no error thrown
                    showSuccessAlertView("✔️", "Successfully added to remote server") {}
                    print("Document added with id: \(docRef.documentID)")
                    return
                }
                
                //firestore error thrown
                showErrorAlertView("Firestore error", error.localizedDescription, handler: {})
            }
        }
        //need to encode Locator struct so this will not work
        /*docRef.setData(["deviceID" : deviceID, "favouriteLocations" : locator]) { error in
            if let err = error {
                showErrorAlertView("Error adding document", err.localizedDescription) {}
                print("Error adding document: \(err)")
            } else {
                showSuccessAlertView("✔️", "Success") {}
                print("Document added with id: \(docRef.documentID)")
            }
        }*/
    }
    
    func clearLocation(id deviceID: String) {
        let db = Firestore.firestore()
        let docRef = db.collection("Favourites").document(deviceID)
        
        docRef.updateData(["favouriteLocations" : FieldValue.delete()]) { err in
            if let err = err {
                print("Error updating document: \(err)")
                showErrorAlertView("Error clearing your storage bucket", err.localizedDescription, handler: {})
            } else {
                print("Document successfully updated")
                showSuccessAlertView("✔️", "Storage bucket successfully cleared", handler: {})
            }
        }
    }
    
    func deleteLocation(id deviceID: String, locator : Locator) {
        let db = Firestore.firestore()
        let docRef = db.collection("Favourites").document(deviceID)
        
        let encoded : [String: Any]
        do {
            //encode the swift struct instance into a dictionary using the Firestore encoder
            encoded = try Firestore.Encoder().encode(locator)
        } catch {
            //encoding error
            showErrorAlertView("Encoding Error", error.localizedDescription, handler: {})
            return
        }
        
        let fieldKey = "favouriteLocations"
        
        docRef.updateData([fieldKey : FieldValue.arrayRemove([encoded])]) { error in
            if let err = error {
                showErrorAlertView("Error updating document", err.localizedDescription) {}
                print("Error updating document: \(err)")
            } else {
                showSuccessAlertView("Success", "Document successfully updated") {}
                print("Document successfully updated")
            }
        }
    }
    
    func getLocationData(id deviceID: String) {
        let db = Firestore.firestore()
        let docRef = db.collection("Favourites").document(deviceID)
        
        docRef.getDocument { document, error in
            guard error == nil else {
                //show error view
                showErrorAlertView("Error", error!.localizedDescription) {}
                return
            }
            
            if let document = document, document.exists {
                let data = document.data()
                if let data = data {
                    let favouritesFound = data["favouriteLocations"] as? Array<Any>
                    if favouritesFound != nil {
                        do {
                            for i in favouritesFound! {
                                let decoder = Firestore.Decoder()
                                let decodedLocation = try decoder.decode(Locator.self, from: i, in: docRef)
                                self.favouriteCities.insert(decodedLocation)
                            }
                        } catch {
                            showErrorAlertView("Try catch error", error.localizedDescription, handler: {})
                        }
                    } else {
                        //show error
                        showErrorAlertView("Error", "Could not cast to favourites") {}
                    }
                } else {
                    //show error
                    showErrorAlertView("Error", "Data does not exist") {}
                }
            } else {
                //show error
                //showErrorAlertView("Error", "Document does not exist", handler: {})
            }
        }
    }
}
