//
//  CityMapDataSource.swift
//  CityMap
//
//  Created by Javier Manzo on 11/12/2024.
//

import Foundation
import Storage

protocol CityMapDataSourceProtocol {
    func saveFavorites(cities: Set<City>)
    func fetchFavorites() -> Set<City>?
    func clear()
}

final class CityMapDataSource: CityMapDataSourceProtocol {
    private let storage = Storage(identifier: "city-map")

    private enum StorageKeys: String {
        case favorites
    }

    func saveFavorites(cities: Set<City>) {
        storage.add(value: cities, forKey: StorageKeys.favorites.rawValue)
    }

    func fetchFavorites() -> Set<City>? {
        return storage.value(forKey: StorageKeys.favorites.rawValue, type: Set<City>.self)
    }

    func clear() {
        storage.clear()
    }
}


