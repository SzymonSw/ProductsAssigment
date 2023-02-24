//
//  DetailsViewModel.swift
//  ProductsAssigment
//
//  Created by Szymon Swietek on 24/02/2023.
//

import Combine

class DetailsViewModel: ObservableObject {
    @Published var product: Product
    
    init(product: Product) {
        self.product = product
    }
   
}
