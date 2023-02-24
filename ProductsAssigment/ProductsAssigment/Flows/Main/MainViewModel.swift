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
    typealias Dependencies = HasApiPrvider
    
    private let dependencies: Dependencies
    private weak var delegate: MainViewDelegate?
    
    @Published var products: [Model.Product] = []
    
    init(dependencies: Dependencies, delegate: MainViewDelegate?) {
        self.dependencies = dependencies
        self.delegate = delegate
        fetchProducts(useCache: true)
    }
    
    func onProductTapped(product: Model.Product) {
        delegate?.mainViewWantsToShowDetails(of: product)
    }
    
    private func fetchProducts(useCache: Bool) {
        Task { [weak self] in
            do {
                let productsResponse = try await dependencies.api.getProducts(useCache: useCache)
                self?.products = productsResponse.products.map { Model.Product(apiModel: $0) }

                if productsResponse.isFromCache {
                    self?.fetchProducts(useCache: false)
                }
            } catch  {
                print(error)
            }
        }
    }
}
