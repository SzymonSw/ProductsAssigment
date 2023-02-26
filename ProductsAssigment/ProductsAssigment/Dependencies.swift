//
//  Dependencies.swift
//  ProductsAssigment
//
//  Created by Szymon Swietek on 24/02/2023.
//

import Foundation

protocol HasApiProvider {
    var api: ApiProviderProtocol { get }
}

protocol HasPersistantStorage {
    var storage: PersistantStorageProtocol { get }
}

struct AppDependency: HasApiProvider, HasPersistantStorage {
    var api: ApiProviderProtocol
    var storage: PersistantStorageProtocol
}
