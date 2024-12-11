//
//  City.swift
//  CityMap
//
//  Created by Javier Manzo on 11/12/2024.
//

import Foundation

struct City: Identifiable, Codable, Hashable {
    let id: Int
    let country: String
    let name: String
    let coordinates: Coordinates

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case country
        case name
        case coordinates = "coord"
    }
}

struct Coordinates: Codable, Equatable, Hashable {
    let latitude: Double
    let longitude: Double

    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
    }
}
