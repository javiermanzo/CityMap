//
//  CityMapRepository.swift
//  CityMap
//
//  Created by Javier Manzo on 11/12/2024.
//

import Foundation

protocol CityMapRepositoryProtocol {
    func requestCities() async throws -> [City]
    func saveFavorites(cities: Set<City>)
    func fetchFavorites() -> Set<City>
    func clearSavedData()
}

final class CityMapRepository: CityMapRepositoryProtocol {
    
    private let dataSource: CityMapDataSourceProtocol = CityMapDataSource()

    func requestCities() async throws -> [City] {
        let requestUrl = "https://gist.githubusercontent.com/hernan-uala/dce8843a8edbe0b0018b32e137bc2b3a/raw/0996accf70cb0ca0e16f9a99e0ee185fafca7af1/cities.json"
        guard let url = URL(string: requestUrl) else {
            throw CityMapError.invalidURL
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let cities = try? JSONDecoder().decode([City].self, from: data) {
                let sortedCities = cities.sorted { $0.name < $1.name }
                return sortedCities
            } else {
                throw CityMapError.decodingError
            }
        } catch {
            throw CityMapError.networkError(error.localizedDescription)
        }
    }

    func saveFavorites(cities: Set<City>) {
        dataSource.saveFavorites(cities: cities)
    }

    func fetchFavorites() -> Set<City> {
        return dataSource.fetchFavorites() ?? []
    }

    func clearSavedData() {
        dataSource.clear()
    }
}

enum CityMapError: Error {
    case invalidURL
    case decodingError
    case networkError(String)
}
