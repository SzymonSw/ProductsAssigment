//
//  Product.swift
//  ProductsAssigment
//
//  Created by Szymon Swietek on 24/02/2023.
//

import Foundation

enum Model {}

extension Model {
    struct Product: Identifiable {
        let id: String
        let name: String
        let price: Double
        let imageUrl: String
        let description: String

        init(apiModel: APIModel.Product) {
            self.id = apiModel.id
            self.name = apiModel.name
            self.price = apiModel.price
            self.imageUrl = apiModel.imageUrl
            self.description = apiModel.description
        }
    }
}


