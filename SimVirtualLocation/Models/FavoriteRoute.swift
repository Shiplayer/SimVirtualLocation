//
//  FavoriteRoute.swift
//  SimVirtualLocation
//
//  Created by Assistant on 2024.
//

import Foundation
import CoreLocation
import MapKit

struct FavoriteRoute: Codable, Identifiable {
    let id = UUID()
    let name: String
    let startPoint: CLLocationCoordinate2D
    let endPoint: CLLocationCoordinate2D
    let dateCreated: Date
    
    init(name: String, startPoint: CLLocationCoordinate2D, endPoint: CLLocationCoordinate2D) {
        self.name = name
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.dateCreated = Date()
    }
    
    // MARK: - Codable
    
    private enum CodingKeys: String, CodingKey {
        case name, startPoint, endPoint, dateCreated
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        dateCreated = try container.decode(Date.self, forKey: .dateCreated)
        startPoint = try container.decode(CLLocationCoordinate2D.self, forKey: .startPoint)
        endPoint = try container.decode(CLLocationCoordinate2D.self, forKey: .endPoint)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(dateCreated, forKey: .dateCreated)
        try container.encode(startPoint, forKey: .startPoint)
        try container.encode(endPoint, forKey: .endPoint)
    }
}

// MARK: - CLLocationCoordinate2D Codable Extension

extension CLLocationCoordinate2D: Codable {
    private enum CodingKeys: String, CodingKey {
        case latitude, longitude
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let latitude = try container.decode(Double.self, forKey: .latitude)
        let longitude = try container.decode(Double.self, forKey: .longitude)
        self.init(latitude: latitude, longitude: longitude)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
    }
}
