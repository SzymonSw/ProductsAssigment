//
//  API_Product.swift
//  ProductsAssigment
//
//  Created by Szymon Swietek on 26/02/2023.
//

import Foundation

enum APIModel {}

extension APIModel {
    struct Product: Decodable {
        let id: String
        let name: String
        let price: Double
        let imageUrl: String
        let description: String
        //assumption: backend will never return nil values
        //assumption: price has no currency, so no currency will be displayed
    }
}
