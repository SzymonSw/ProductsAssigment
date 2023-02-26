//
//  ApiError.swift
//  ProductsAssigment
//
//  Created by Szymon Swietek on 24/02/2023.
//

import Foundation
enum ApiError: Error {
    case couldNotParseResponse
    
    var message: String {
        switch self {
        case .couldNotParseResponse:
            return "Could not parse response"
        }
    }
}