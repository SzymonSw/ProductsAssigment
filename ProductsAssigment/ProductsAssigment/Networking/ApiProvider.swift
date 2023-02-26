//
//  ApiProvider.swift
//  ProductsAssigment
//
//  Created by Szymon Swietek on 24/02/2023.
//

import Foundation

protocol ApiProviderProtocol {
    func getProducts(useCache: Bool) async throws -> (products: [APIModel.Product], isFromCache: Bool)
}

class ApiProvider: ApiProviderProtocol {

    private let persistantStorage: PersistantStorageProtocol
    private let session = URLSession.shared

    init(persistantStorage: PersistantStorageProtocol) {
        self.persistantStorage = persistantStorage
    }
    
    func getProducts(useCache: Bool) async throws -> (products: [APIModel.Product], isFromCache: Bool) {
        let url = URL(string: "https://run.mocky.io/v3/1c4cfa98-e329-4d49-8836-8ee195cec131")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if useCache, let cachedData = await persistantStorage.getCachedResponseData(for: url.absoluteString) {
            do {
                let products: [APIModel.Product] = try decodeObject(from: cachedData)
                return (products, true)
            }
        }
        
        do {
            let response = try await session.data(for: request)
            Task {
                await persistantStorage.cacheResponseData(data: response.0, for: url.absoluteString)
            }
            
            let products: [APIModel.Product] = try decodeObject(from: response.0)
            return (products, false)
        } catch {
            throw error
        }
    }
    
    private func decodeObject<T>(from data: Data) throws -> T where T: Decodable {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let result = try decoder.decode(T.self, from: data)
            return result

        } catch {
            throw ApiError.couldNotParseResponse
        }
    }
        
}
