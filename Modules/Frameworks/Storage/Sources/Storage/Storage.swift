//
//  Storage.swift
//  Storage
//
//  Created by Javier Manzo on 11/12/2024.
//

import Foundation

public protocol StorageProtocol {
    func value<T: Any>(forKey key: String, type: T.Type) -> T?
    func removeValue(forKey key: String)
    func add(value: Any, forKey key: String)
    func clear()
}

public final class Storage {
    private let identifier: String
    private let userDefaults: UserDefaults?

    public init(identifier: String) {
        self.identifier = identifier
        self.userDefaults = UserDefaults(suiteName: identifier)
    }

    public func value<T: Decodable>(forKey key: String, type: T.Type) -> T? {
        if let valueData = userDefaults?.data(forKey: key) {
            let decoder = JSONDecoder()
            return try? decoder.decode(T.self, from: valueData)
        }
        return nil
    }

    public func removeValue(forKey key: String) {
        userDefaults?.removeObject(forKey: key)
        userDefaults?.synchronize()
    }

    public func add(value: Encodable, forKey key: String) {
        if let encoded = try? JSONEncoder().encode(value) {
            userDefaults?.set(encoded, forKey: key)
            userDefaults?.synchronize()
        }
    }

    public func clear() {
        let userDefaults = UserDefaults.standard
        userDefaults.removePersistentDomain(forName: identifier)
        userDefaults.synchronize()
    }
}
