//
//  ApiProvider.swift
//  ProductsAssigment
//
//  Created by Szymon Swietek on 24/02/2023.
//

import Foundation
import CryptoKit

protocol ApiProviderProtocol {
    func sendRequest<T>(request: ApiRequests, useCache: Bool, resultType: T.Type) async throws -> (result: T, isFromCache: Bool) where T: Decodable
}

enum ApiRequests {
    case getProducts
    
    var method: String {
        switch self {
        case .getProducts:
            return "GET"
        }
    }
    
    var path: String {
        switch self {
        case .getProducts:
            return "/v3/1c4cfa98-e329-4d49-8836-8ee195cec131"
        }
    }
    
    var hashString: String {
        let inputData = Data(path.utf8)
        let hashed = SHA256.hash(data: inputData)
        let hashString = hashed.compactMap { String(format: "%02x", $0) }.joined()
        return hashString
    }
}

final class ApiProvider: ApiProviderProtocol {

    private let persistantStorage: PersistantStorageProtocol
    private let session = URLSession.shared
    private let host: String = "https://run.mocky.io"

    init(persistantStorage: PersistantStorageProtocol) {
        self.persistantStorage = persistantStorage
    }
    
    func sendRequest<T>(request: ApiRequests,
                        useCache: Bool,
                        resultType: T.Type) async throws -> (result: T, isFromCache: Bool) where T: Decodable {
        let url = URL(string: host + request.path)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method
        
        if useCache {
            do {
                let cachedData = try await persistantStorage.getCachedResponseData(for: request)
                let result: T = try decodeObject(from: cachedData)
                return (result, true)
            } catch {
                print("Couldn't read cache")
                //ignore this error and continue with real fetch
            }
        }
        
        do {
            let response = try await session.data(for: urlRequest)
            if let urlResponse = response.1 as? HTTPURLResponse, urlResponse.statusCode == 200 {
                let result: T = try decodeObject(from: response.0)
                Task {
                    await persistantStorage.cacheResponseData(data: response.0, for: request)
                }
                return (result, false)
            } else {
                throw ApiError.serverError
            }
           
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
