import Foundation
import SwiftData
import CoreLocation

@Model
public final class SpottedTrain {
    @Attribute(.unique) public var id: UUID
    public var spottedAt: Date
    public var tzNumber: String?             // Triebzugnummer, z.B. "Tz 8012" oder "403 001"
    public var latitude: Double?
    public var longitude: Double?
    public var stationOrLocationName: String? // z.B. "Köln Hbf, Gleis 4"
    
    // Große Binärdaten wie Fotos extern speichern lassen
    @Attribute(.externalStorage)
    public var photoData: Data?
    
    public var notes: String?
    
    // Verknüpfung zum Zug-Modell (Katalog-Eintrag)
    public var trainModel: TrainModel?
    
    public init(
        id: UUID = UUID(),
        spottedAt: Date = Date(),
        tzNumber: String? = nil,
        latitude: Double? = nil,
        longitude: Double? = nil,
        stationOrLocationName: String? = nil,
        photoData: Data? = nil,
        notes: String? = nil,
        trainModel: TrainModel? = nil
    ) {
        self.id = id
        self.spottedAt = spottedAt
        self.tzNumber = tzNumber
        self.latitude = latitude
        self.longitude = longitude
        self.stationOrLocationName = stationOrLocationName
        self.photoData = photoData
        self.notes = notes
        self.trainModel = trainModel
    }
    
    // Convenience: CLLocationCoordinate2D für MapKit
    public var coordinate: CLLocationCoordinate2D? {
        guard let lat = latitude, let lon = longitude else { return nil }
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
    
    // Berechnete Punkte für diese Sichtung basierend auf der Seltenheit des Zuges
    public var pointsEarned: Int {
        trainModel?.rarity.points ?? 50
    }
}
