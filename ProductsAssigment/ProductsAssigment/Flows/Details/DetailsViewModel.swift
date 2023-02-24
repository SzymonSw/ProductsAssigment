//
//  DetailsViewModel.swift
//  ProductsAssigment
//
//  Created by Szymon Swietek on 24/02/2023.
//

import Combine

class DetailsViewModel: ObservableObject {
    @Published var product: Model.Product
    
    init(product: Model.Product) {
        self.product = product
    }
   
}
