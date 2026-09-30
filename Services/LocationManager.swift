import Foundation
import CoreLocation

@Observable
@MainActor
public final class LocationManager: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    public var lastLocation: CLLocation?
    public var currentPlaceName: String = "Standort wird ermittelt..."
    public var isLocating: Bool = false
    public var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    public override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        authorizationStatus = manager.authorizationStatus
    }
    
    public func requestLocation() {
        isLocating = true
        let status = manager.authorizationStatus
        authorizationStatus = status
        
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        case .denied, .restricted:
            isLocating = false
            currentPlaceName = "Standortzugriff deaktiviert"
        @unknown default:
            isLocating = false
            currentPlaceName = "Standort unbekannt"
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    nonisolated public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        Task { @MainActor in
            self.authorizationStatus = status
            if status == .authorizedWhenInUse || status == .authorizedAlways {
                manager.requestLocation()
            }
        }
    }
    
    nonisolated public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        Task { @MainActor in
            self.lastLocation = location
            self.isLocating = false
            
            do {
                let placemarks = try await self.geocoder.reverseGeocodeLocation(location)
                if let placemark = placemarks.first {
                    self.currentPlaceName = Self.formatPlacemark(placemark, fallback: location)
                }
            } catch {
                if self.lastLocation != nil {
                    self.currentPlaceName = Self.formatCoordinate(location.coordinate)
                }
            }
        }
    }
    
    // MARK: - Formatting Helpers
    private static func formatPlacemark(_ placemark: CLPlacemark, fallback: CLLocation) -> String {
        let name = placemark.name ?? ""
        let locality = placemark.locality ?? ""
        
        if !name.isEmpty && !locality.isEmpty && name != locality {
            return "\(name), \(locality)"
        } else if !name.isEmpty {
            return name
        } else if !locality.isEmpty {
            return locality
        } else {
            return formatCoordinate(fallback.coordinate)
        }
    }
    
    private static func formatCoordinate(_ coordinate: CLLocationCoordinate2D) -> String {
        String(format: "%.4f, %.4f", coordinate.latitude, coordinate.longitude)
    }
    
    nonisolated public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Task { @MainActor in
            self.isLocating = false
            if self.lastLocation == nil {
                self.currentPlaceName = "Standort nicht verfügbar"
            }
        }
    }
}
