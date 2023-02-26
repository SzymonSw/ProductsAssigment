//
//  MainViewModel.swift
//  ProductsAssigment
//
//  Created by Szymon Swietek on 24/02/2023.
//

import Combine

protocol MainViewDelegate: AnyObject {
    func mainViewWantsToShowDetails(of product: Model.Product)
}

@MainActor
class MainViewModel: ObservableObject {
    typealias Dependencies = HasApiProvider
    
    private let dependencies: Dependencies
    private weak var delegate: MainViewDelegate?
    
    @Published var products: [Model.Product] = []
    @Published var errorMessage: String?

    init(dependencies: Dependencies, delegate: MainViewDelegate?) {
        self.dependencies = dependencies
        self.delegate = delegate
        fetchProducts(useCache: true)
    }
    
    func onProductTapped(product: Model.Product) {
        delegate?.mainViewWantsToShowDetails(of: product)
    }
    
    private func fetchProducts(useCache: Bool) {
        Task {
            do {
                let productsResponse = try await dependencies.api.getProducts(useCache: useCache)
                products = productsResponse.products.map { Model.Product(apiModel: $0) }

                if productsResponse.isFromCache {
                    fetchProducts(useCache: false)
                }
                errorMessage = nil
            } catch {
                if let apiError = error as? ApiError {
                    errorMessage = apiError.message
                } else {
                    print(error)
                }
            }
        }
    }
}
