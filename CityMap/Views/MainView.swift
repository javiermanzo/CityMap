//
//  MainView.swift
//  CityMap
//
//  Created by Javier Manzo on 11/12/2024.
//

import SwiftUI

struct MainView: View {

    @State private var selectedCity: City?
    @State private var visibility: NavigationSplitViewVisibility = .doubleColumn

    var body: some View {
        NavigationSplitView(columnVisibility: $visibility) {
            CitiesListView(selectedCity: $selectedCity)
                .navigationDestination(for: City.self) { city in
                    MapView(city: city)
                }
        } detail: {
            if selectedCity == nil {
                Text("Select a city")
                    .font(.title)
            }
        }
        .navigationSplitViewStyle(.prominentDetail)
    }
}

#Preview {
    MainView()
}
