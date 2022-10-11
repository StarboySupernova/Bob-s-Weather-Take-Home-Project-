//
//  Locator.swift
//  Bob's Weather
//
//  Created by Simbarashe Dombodzvuku on 10/11/22.
//

import Foundation
import CoreLocation

protocol ObjectSavable {
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable
}

struct Locator: Hashable, Codable {
    var name: String
    var latitude: Double
    var longitude: Double
}


