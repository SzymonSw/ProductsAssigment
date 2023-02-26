//
//  PersistantStorage.swift
//  ProductsAssigment
//
//  Created by Szymon Swietek on 24/02/2023.
//

import Foundation

protocol PersistantStorageProtocol {
    func cacheResponseData(data: Data, for url: String) async
    func getCachedResponseData(for url: String) async -> Data?
}

actor PersistantStorage: PersistantStorageProtocol {
    var cachedResponsesFilePath: URL {
        let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let filePath = cachesDirectory.appendingPathComponent("cachedResponses.dat")
        return filePath
    }

    func cacheResponseData(data: Data, for url: String) async {
        var storedDict: [NSString: NSData] = [:]
        if let dict = await getCachedRsponsesDict() {
            storedDict = dict
        }
        storedDict[NSString(string: url)] = NSData(data: data)
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: storedDict, requiringSecureCoding: false)
            try data.write(to: cachedResponsesFilePath)

        } catch {
            print(error)
        }
    }
    
    func getCachedResponseData(for url: String) async -> Data? {
        if let storedDict = await getCachedRsponsesDict(),
           let nsData = storedDict[NSString(string: url)] {
            let data = Data(nsData)
            return data
        } else {
            return nil
        }
    }
    
    private func getCachedRsponsesDict() async -> [NSString: NSData]? {
        do {
            let data = try Data(contentsOf: cachedResponsesFilePath)
            let storedDict = try NSKeyedUnarchiver.unarchivedDictionary(ofKeyClass: NSString.self, objectClass: NSData.self, from: data)
            return storedDict

        } catch {
            return nil
        }
    }
    
}
