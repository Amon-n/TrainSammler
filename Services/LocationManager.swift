import Foundation
import CoreLocation
import SwiftUI

@Observable
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
        if authorizationStatus == .notDetermined {
            manager.requestWhenInUseAuthorization()
        } else if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
            manager.requestLocation()
        } else {
            isLocating = false
            currentPlaceName = "Standortzugriff verweigert"
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
            manager.requestLocation()
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.lastLocation = location
        self.isLocating = false
        
        // Reverse Geocoding: Bahnhof oder Landmarke auflösen
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self = self else { return }
            if let placemark = placemarks?.first {
                let name = placemark.name ?? ""
                let locality = placemark.locality ?? ""
                
                // Bevorzuge Bahnhof / Name vor Ort falls vorhanden
                if !name.isEmpty && !locality.isEmpty && name != locality {
                    self.currentPlaceName = "\(name), \(locality)"
                } else if !name.isEmpty {
                    self.currentPlaceName = name
                } else if !locality.isEmpty {
                    self.currentPlaceName = locality
                } else {
                    self.currentPlaceName = String(format: "%.4f, %.4f", location.coordinate.latitude, location.coordinate.longitude)
                }
            } else {
                self.currentPlaceName = String(format: "%.4f, %.4f", location.coordinate.latitude, location.coordinate.longitude)
            }
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.isLocating = false
        self.currentPlaceName = "Standort unbekannt"
    }
}
