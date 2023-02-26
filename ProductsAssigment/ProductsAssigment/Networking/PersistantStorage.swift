//
//  PersistantStorage.swift
//  ProductsAssigment
//
//  Created by Szymon Swietek on 24/02/2023.
//

import Foundation

protocol PersistantStorageProtocol {
    func cacheResponseData(data: Data, for request: ApiRequests) async
    func getCachedResponseData(for request: ApiRequests) async throws -> Data
}

actor PersistantStorage: PersistantStorageProtocol {
    
    private let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    
    func cacheResponseData(data: Data, for request: ApiRequests) async {
        let filePath = cachesDirectory.appendingPathComponent("\(request.hashString).dat")
        do {
            try data.write(to: filePath)
            return
        } catch {
            print(error)
            //no need to handle this error
        }
    }
    
    func getCachedResponseData(for request: ApiRequests) async throws -> Data {
        let filePath = cachesDirectory.appendingPathComponent("\(request.hashString).dat")
        
        do {
            let storedData = try Data(contentsOf: filePath)
            return storedData
        } catch {
            throw error
        }
    }
    
}
