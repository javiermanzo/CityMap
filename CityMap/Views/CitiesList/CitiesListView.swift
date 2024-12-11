//
//  CitiesListView.swift
//  CityMap
//
//  Created by Javier Manzo on 11/12/2024.
//


import SwiftUI

struct CitiesListView: View {
    @StateObject private var viewModel = CitiesListViewModel()
    @Binding var selectedCity: City?

    var body: some View {
        List {
            ForEach(viewModel.visibleCities) { city in
                NavigationLink(value: city) {
                    CityRow(city)
                }
                .onAppear {
                    if !viewModel.showFavoritesOnly && viewModel.searchText.isEmpty,
                       city.id == viewModel.visibleCities.last?.id {
                        viewModel.loadNextPage()
                    }
                }
            }
        }
        .listStyle(.plain)
        .navigationBarTitle(!viewModel.showFavoritesOnly ? "Cities" : "Favorited Cities", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                FavoriteNavigationBarButton()
            }
        }
        .if(!viewModel.showFavoritesOnly) { content in
            content
                .searchable(text: $viewModel.searchText, prompt: "Search city")
        }
    }
}

private extension CitiesListView {
    @ViewBuilder
    func CityRow(_ city: City) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(city.name), \(city.country)")
                    .font(.headline)
                Text("Lat: \(city.coordinates.latitude), Lon: \(city.coordinates.longitude)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Favorite(city)
        }
        .padding(.vertical, 4)
    }

    @ViewBuilder
    func Favorite(_ city: City) -> some View {
        let isFavorite = viewModel.favorites.contains(city.id)

        Image(systemName: isFavorite ? "star.fill" : "star")
            .foregroundColor(isFavorite ? .yellow : .gray)
            .padding(16)
            .background(Color.gray.opacity(0.2))
            .clipShape(Circle())
            .onTapGesture {
                viewModel.addOrRemoveFavorite(city: city)
            }
    }


    @ViewBuilder
    func FavoriteNavigationBarButton() -> some View {
        Button(action: {
            viewModel.toggleFavoritesOnly()
        }) {
            Image(systemName: viewModel.showFavoritesOnly ? "star.fill" : "star")
                .foregroundColor(viewModel.showFavoritesOnly ? .yellow : .accentColor)
        }
    }
}
