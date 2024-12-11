//
//  CityMapTests.swift
//  CityMapTests
//
//  Created by Javier Manzo on 11/12/2024.
//

import XCTest
@testable import CityMap

final class CityMapTests: XCTestCase {

    var repository: CityMapRepositoryProtocol!
    var viewModel: CitiesListViewModel!

    override func setUp() async throws {
        try await super.setUp()
        repository = MockCityMapRepository()

        viewModel = CitiesListViewModel(repository: repository)
        try await Task.sleep(nanoseconds: 200_000_000) // 0.2s
    }

    override func tearDownWithError() throws {
        repository = nil
        viewModel = nil
    }

    func testSearchFiltering() throws {
        viewModel.searchText = "A"
        let visible = viewModel.visibleCities
        XCTAssertEqual(visible.map { $0.name }.sorted(), ["Amsterdam", "Athens"], "Should filter cities starting with A")

        viewModel.searchText = "Bue"
        let filteredBue = viewModel.visibleCities
        XCTAssertEqual(filteredBue.map { $0.name }, ["Buenos Aires"], "Should filter cities starting with 'Bue'")
    }

    func testNoResultsForInvalidSearch() {
        viewModel.searchText = "Z"
        let visible = viewModel.visibleCities
        XCTAssertTrue(visible.isEmpty, "No cities should start with Z")
    }

    func testFavorites() {
        viewModel.showFavoritesOnly = false

        let amsterdam = viewModel.visibleCities.first { $0.name == "Amsterdam" }!
        let berlin = viewModel.visibleCities.first { $0.name == "Berlin" }!

        viewModel.addOrRemoveFavorite(city: amsterdam)
        viewModel.addOrRemoveFavorite(city: berlin)

        XCTAssertTrue(viewModel.favorites.contains(amsterdam), "Amsterdam should be in favorites")
        XCTAssertTrue(viewModel.favorites.contains(berlin), "Berlin should be in favorites")

        viewModel.showFavoritesOnly = true
        let visible = viewModel.visibleCities
        XCTAssertEqual(visible.count, 2, "Should show only 2 favorites")
        XCTAssertEqual(Set(visible), Set([amsterdam, berlin]), "Visible should match favorites")

        // Remove Berlin from favorites
        viewModel.addOrRemoveFavorite(city: berlin)
        XCTAssertFalse(viewModel.favorites.contains(berlin), "Berlin should be removed from favorites")

        let visibleAfterRemoval = viewModel.visibleCities
        XCTAssertEqual(visibleAfterRemoval.map { $0.name }, ["Amsterdam"], "Only Amsterdam should remain in favorites")
    }

    func testToggleFavoritesOnly() {
        let city = viewModel.visibleCities.first!
        viewModel.addOrRemoveFavorite(city: city)
        XCTAssertTrue(viewModel.favorites.contains(city))

        viewModel.toggleFavoritesOnly()
        XCTAssertTrue(viewModel.showFavoritesOnly, "Should show only favorites now")

        let visible = viewModel.visibleCities
        XCTAssertEqual(visible.count, 1, "Should see only favorite city")
        XCTAssertEqual(visible.first?.name, city.name)

        viewModel.toggleFavoritesOnly()
        XCTAssertFalse(viewModel.showFavoritesOnly, "Should revert to showing all cities")
    }
}

class MockCityMapRepository: CityMapRepositoryProtocol {

    var favorites: Set<City> = []

    func requestCities() async throws -> [City] {
        let cities = [
            City(id: 1, country: "Netherlands", name: "Amsterdam", coordinates: Coordinates(latitude: 52.3676, longitude: 4.9041)),
            City(id: 2, country: "Greece", name: "Athens", coordinates: Coordinates(latitude: 37.9838, longitude: 23.7275)),
            City(id: 3, country: "Germany", name: "Berlin", coordinates: Coordinates(latitude: 52.5200, longitude: 13.4050)),
            City(id: 4, country: "USA", name: "Boston", coordinates: Coordinates(latitude: 42.3601, longitude: -71.0589)),
            City(id: 5, country: "Argentina",name: "Buenos Aires",  coordinates: Coordinates(latitude: -34.6037, longitude: -58.3816))
            ]
        return cities
    }

    func fetchFavorites() -> Set<City> {
        return favorites
    }

    func saveFavorites(cities: Set<City>) {
        favorites = cities
    }

    func clearSavedData() {

    }
}
