import Foundation
import CoreLocation
import MapKit

@MainActor
class MapViewModel: ObservableObject {
    @Published var carWashes: [CarWash] = []
    private let locationManager = CLLocationManager()
    
    init() {
        // TODO: Implementar permisos de ubicación
        loadSampleData()
    }
    
    func refreshLocation() {
        // TODO: Implementar actualización de ubicación
    }
    
    private func loadSampleData() {
        carWashes = [
            CarWash(
                id: "1",
                name: "AutoLavado Express",
                address: "Av. Reforma 123",
                coordinate: CLLocationCoordinate2D(latitude: 19.4326, longitude: -99.1332),
                rating: 4.5
            ),
            CarWash(
                id: "2",
                name: "Lavado Premium",
                address: "Av. Insurgentes 456",
                coordinate: CLLocationCoordinate2D(latitude: 19.4226, longitude: -99.1432),
                rating: 4.8
            )
        ]
    }
}

// Using CarWash from Models.swift
extension CarWash {
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}e
} 