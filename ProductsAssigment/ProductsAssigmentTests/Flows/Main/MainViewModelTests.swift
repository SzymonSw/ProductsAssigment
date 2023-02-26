//
//  MainViewModelTests.swift
//  ProductsAssigmentTests
//
//  Created by Szymon Swietek on 24/02/2023.
//

import XCTest
@testable import ProductsAssigment

fileprivate enum TestVariant {
    case cachedProducts
    case fetchedProducts
    case errorFetch
}

@MainActor
final class MainViewModelTests: XCTestCase {
    
    struct Deps: MainViewModel.Dependencies {
        var api: ApiProviderProtocol
    }
    
    var sut: MainViewModel!
    var dependecies:Deps!
    
    var productTapDelegateCalled = false
    
    fileprivate static var testVariant: TestVariant = .cachedProducts

    override func setUpWithError() throws {
        dependecies = Deps(api: ApiProviderMock())
        productTapDelegateCalled = false
    }

    func testInitialFetch() throws {
        Self.testVariant = .cachedProducts
        sut = MainViewModel(dependencies: dependecies, delegate: self)
        try awaitPublisher(sut.$isLoading.collectNext(1))
        XCTAssertTrue(sut.isLoading)
        
        try awaitPublisher(sut.$products.collectNext(1))
        XCTAssertTrue(sut.products.count == 3)
        
        Self.testVariant = .fetchedProducts
        try awaitPublisher(sut.$products.collectNext(1))
        XCTAssertTrue(sut.products.count == 4)
        
        XCTAssert(sut.errorMessage == nil)
    }
    
    func testFetchWithError() throws {
        Self.testVariant = .cachedProducts
        sut = MainViewModel(dependencies: dependecies, delegate: self)
        
        try awaitPublisher(sut.$products.collectNext(1))
        XCTAssertTrue(sut.products.count == 3)
        
        Self.testVariant = .errorFetch
        try awaitPublisher(sut.$errorMessage.collectNext(1))
        XCTAssert(sut.errorMessage == "Oops something went wrong\nDisplaying cached data")
    }
    
    func testProductTap() throws {
        try testInitialFetch()
        sut.onProductTapped(product: sut.products.first!)
        XCTAssertTrue(productTapDelegateCalled)
    }


}
extension MainViewModelTests: MainViewDelegate {
    func mainViewWantsToShowDetails(of product: ProductsAssigment.Model.Product) {
        productTapDelegateCalled = true
    }
}

fileprivate class ApiProviderMock: ApiProviderProtocol {
    func sendRequest<T>(request: ProductsAssigment.ApiRequests, useCache: Bool, resultType: T.Type) async throws -> (result: T, isFromCache: Bool) where T : Decodable {
        
        switch request {
        case .getProducts:
            let shouldThrowError = await MainViewModelTests.testVariant == .errorFetch
            if shouldThrowError {
                throw ApiError.serverError
            }
            
            let product1 = APIModel.Product(id: "1", name: "Product1", price: 10.0, imageUrl: "www.google.com", description: "Description1")
            let product2 = APIModel.Product(id: "2", name: "Product2", price: 10.0, imageUrl: "www.google.com", description: "Description2")
            let product3 = APIModel.Product(id: "3", name: "Product3", price: 10.0, imageUrl: "www.google.com", description: "Description3")
            
            var products = [product1, product2, product3]
            
            let isFromCache = await MainViewModelTests.testVariant == .cachedProducts

            if !isFromCache {
                let product4 = APIModel.Product(id: "4", name: "Product4", price: 10.0, imageUrl: "www.google.com", description: "Description4")
                products.append(product4)
            }
            
            return (result: products as! T, isFromCache: isFromCache)
        }
    }
}
