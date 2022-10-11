//
//  APIError.swift
//  Bob's Weather
//
//  Created by Simbarashe Dombodzvuku on 9/5/22.
//

import Foundation

enum APIError: Error {
    case decodingError
    case errorCode(Int)
    case unknown
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .decodingError:
                return "Failed to decode the object from the service"
            case .errorCode(let code):
                return "Something went wrong, with status code \(code)"
            case .unknown:
                return "Unknown error. Please try again"
        }
    }
}

