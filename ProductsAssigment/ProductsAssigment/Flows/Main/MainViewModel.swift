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
    
    @Published private(set) var products: [Model.Product] = []
    @Published private(set) var errorMessage: String?
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var isDisplayingCachedData = false

    init(dependencies: Dependencies, delegate: MainViewDelegate?) {
        self.dependencies = dependencies
        self.delegate = delegate
        fetchProducts(useCache: true)
    }
    
    func onProductTapped(product: Model.Product) {
        delegate?.mainViewWantsToShowDetails(of: product)
    }
    
    func onRefreshTapped() {
        products = []
        fetchProducts(useCache: true)
    }
    
    private func fetchProducts(useCache: Bool) {
        Task {
            do {
                isLoading = true
                errorMessage = nil
                let productsResponse = try await dependencies.api.sendRequest(request: .getProducts, useCache: useCache, resultType: [APIModel.Product].self) 
                products = productsResponse.result.map { Model.Product(apiModel: $0) }

                if productsResponse.isFromCache {
                    isDisplayingCachedData = true
                    fetchProducts(useCache: false)
                } else {
                    isDisplayingCachedData = false
                }
                isLoading = false
                
            } catch {
                isLoading = false
                var message: String
                if let apiError = error as? ApiError {
                    message = apiError.message
                } else {
                    message = error.localizedDescription
                }
                errorMessage = message
            }
        }
    }
}
