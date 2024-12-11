//
//  CitiesListViewModel.swift
//  CityMap
//
//  Created by Javier Manzo on 11/12/2024.
//

import SwiftUI

class CitiesListViewModel: ObservableObject {
    @Published var favorites: Set<Int> = []
    @Published var searchText: String = ""
    @Published var showFavoritesOnly: Bool = false

    @Published var errorMessage: String?

    private var citiesList: [City] = []
    @Published private var displayedCities: [City] = []
    private var citiesByFirstLetter: [Character: [City]] = [:]
    private var sortedKeys: [Character] = []
    private var currentKeyIndex: Int = 0

    private let repository: CityMapRepositoryProtocol

    var visibleCities: [City] {
        // Show favorites
        if showFavoritesOnly {
            return citiesList.filter { favorites.contains($0.id) }
        }

        // Show list of cities without filter
        if searchText.isEmpty {
            return displayedCities
        }

        // Show filtered cities
        guard let firstChar = searchText.first,
              let citiesForLetter = citiesByFirstLetter[firstChar], !citiesForLetter.isEmpty else {
            return []
        }

        return citiesForLetter.filter { $0.name.starts(with: searchText) }
    }

    init(repository: CityMapRepositoryProtocol = CityMapRepository()) {
        self.repository = repository

        Task {
            await loadCities()
        }
    }

    private func loadCities() async {
        let cache = repository.fetchCities()
        if !cache.isEmpty {
            processCities(cache)
            return
        }

        do {
            let requestedCities = try await repository.requestCities()
            processCities(requestedCities)
        } catch {
            await MainActor.run {
                self.errorMessage = "No se pudieron cargar las ciudades: \(error.localizedDescription)"
            }
        }
    }

    private func processCities(_ cities: [City]) {
        self.citiesList = cities

        for city in cities {
            guard let firstChar = city.name.first else { continue }
            self.citiesByFirstLetter[firstChar, default: []].append(city)
        }

        self.sortedKeys = self.citiesByFirstLetter.keys.sorted()
        self.loadNextPage()
    }

    func loadNextPage() {
        guard searchText.isEmpty, !showFavoritesOnly else { return }

        var cities: [City] = []

        while currentKeyIndex < sortedKeys.count {
            let key = sortedKeys[currentKeyIndex]
            currentKeyIndex += 1

            guard let citiesForKey = citiesByFirstLetter[key] else {
                continue
            }

            cities.append(contentsOf: citiesForKey)

            if cities.count >= 20 {
                break
            }
        }

        Task { @MainActor in
            displayedCities.append(contentsOf: cities)
        }
    }

    func addOrRemoveFavorite(city: City) {
        if favorites.contains(city.id) {
            favorites.remove(city.id)
        } else {
            favorites.insert(city.id)
        }
    }

    func toggleFavoritesOnly() {
        showFavoritesOnly.toggle()
    }
}
