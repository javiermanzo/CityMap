//
//  MapView.swift
//  CityMap
//
//  Created by Javier Manzo on 11/12/2024.
//

import SwiftUI
import MapKit

struct MapView: View {
    private let city: City
    @State private var position: MapCameraPosition = .automatic

    init(city: City) {
        self.city = city
        updatePosition(city: city)
    }

    var body: some View {
        Map(position: $position) {
            Marker(city.name, coordinate: CLLocationCoordinate2D(
                latitude: city.coordinates.latitude,
                longitude: city.coordinates.longitude
            ))
        }
        .navigationTitle(city.name)
        .onChange(of: city) {
            updatePosition(city: city)
        }
        .ignoresSafeArea()
    }

    func updatePosition(city: City) {
        let newRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: city.coordinates.latitude,
                longitude: city.coordinates.longitude
            ),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
        position = .region(newRegion)
    }
}
