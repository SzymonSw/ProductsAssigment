//
//  Product.swift
//  ProductsAssigment
//
//  Created by Szymon Swietek on 24/02/2023.
//

import Foundation

struct Product: Decodable, Identifiable {
    let id: String
    let name: String
    let price: Double
    let imageUrl: String

}
