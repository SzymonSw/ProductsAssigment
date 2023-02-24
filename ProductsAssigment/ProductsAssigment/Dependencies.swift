//
//  Dependencies.swift
//  ProductsAssigment
//
//  Created by Szymon Swietek on 24/02/2023.
//

import Foundation

protocol HasApiPrvider {
    var api: ApiProviderProtocol { get }
}

protocol HasPersistantStorage {
    var storage: PersistantStorageProtocol { get }
}

struct AppDependency: HasApiPrvider, HasPersistantStorage {
    var api: ApiProviderProtocol
    var storage: PersistantStorageProtocol
}
