//
//  ApiProvider.swift
//  ProductsAssigment
//
//  Created by Szymon Swietek on 24/02/2023.
//

import Foundation

protocol ApiProviderProtocol {
    func getProducts(useCache: Bool) async throws -> [APIModel.Product]
}

class ApiProvider: ApiProviderProtocol {
    
    private let persistantStorage: PersistantStorageProtocol
    
    private let session = URLSession.shared

    init(persistantStorage: PersistantStorageProtocol) {
        self.persistantStorage = persistantStorage
    }
    
    func getProducts(useCache: Bool) async throws -> [APIModel.Product] {
        let url = URL(string: "https://run.mocky.io/v3/1c4cfa98-e329-4d49-8836-8ee195cec131")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        do {
            let response = try await session.data(for: request)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let products = try decoder.decode([APIModel.Product].self, from: response.0)
            return products
        } catch {
            print(error)
            throw error
        }
    }
    
    
}
