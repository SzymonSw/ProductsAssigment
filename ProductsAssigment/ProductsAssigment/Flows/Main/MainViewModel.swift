//
//  MainViewModel.swift
//  ProductsAssigment
//
//  Created by Szymon Swietek on 24/02/2023.
//

import Combine

protocol MainViewDelegate: AnyObject {
    func mainViewWantsToShowDetails(of product: Product)
}

class MainViewModel: ObservableObject {
    typealias Dependencies = HasApiPrvider
    
    private let dependencies: Dependencies
    private weak var delegate: MainViewDelegate?
    
    init(dependencies: Dependencies, delegate: MainViewDelegate?) {
        self.dependencies = dependencies
        self.delegate = delegate
    }
    
    func onProductTapped() {
        delegate?.mainViewWantsToShowDetails(of: Product(id: ""))
    }
}
