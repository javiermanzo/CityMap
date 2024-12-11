//
//  MainView.swift
//  CityMap
//
//  Created by Javier Manzo on 11/12/2024.
//

import SwiftUI

struct MainView: View {

    @State private var selectedCity: City?
    
    var body: some View {
        CitiesListView(selectedCity: $selectedCity)
    }
}

#Preview {
    MainView()
}
