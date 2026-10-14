import Foundation
import SwiftUI
import SwiftData
import PhotosUI

@Observable
@MainActor
public final class QuickSpotViewModel {
    // Formular-Zustände
    public var selectedTrainModel: TrainModel?
    public var tzNumber: String = ""
    public var notes: String = ""
    public var customStationName: String = ""
    public var selectedPhotoItem: PhotosPickerItem?
    public var photoData: Data?
    
    // UI-Zustände & Feedback
    public var isSaving: Bool = false
    public var showSuccessToast: Bool = false
    public var isFirstCatch: Bool = false
    public var earnedPoints: Int = 100
    public var errorMessage: String?
    public var showStationEditSheet: Bool = false
    
    // Location Dependency
    public var locationManager: LocationManager
    
    public init(locationManager: LocationManager? = nil) {
        self.locationManager = locationManager ?? LocationManager()
    }
    
    public var effectiveStationName: String {
        let trimmed = customStationName.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty {
            return trimmed
        }
        return locationManager.currentPlaceName
    }
    
    public func onAppear() {
        locationManager.requestLocation()
    }
    
    public func loadSelectedPhoto() async {
        guard let item = selectedPhotoItem else { return }
        do {
            if let data = try await item.loadTransferable(type: Data.self) {
                self.photoData = data
            }
        } catch {
            print("Fehler beim Laden des Bildes: \(error.localizedDescription)")
        }
    }
    
    public func saveSpotting(context: ModelContext) -> Bool {
        guard let train = selectedTrainModel else {
            errorMessage = "Bitte wähle eine Baureihe aus."
            return false
        }
        
        isSaving = true
        let coordinate = locationManager.lastLocation?.coordinate
        
        // Erstfund-Erkennung
        let wasAlreadySpotted = train.isSpotted
        self.isFirstCatch = !wasAlreadySpotted
        let basePoints = train.rarity.points
        self.earnedPoints = isFirstCatch ? (basePoints + 50) : basePoints
        
        let finalStation = effectiveStationName
        let stationToSave = (finalStation.isEmpty || finalStation.contains("wird ermittelt") || finalStation.contains("deaktiviert")) ? nil : finalStation
        
        let newSpot = SpottedTrain(
            spottedAt: Date(),
            tzNumber: tzNumber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : tzNumber,
            latitude: coordinate?.latitude,
            longitude: coordinate?.longitude,
            stationOrLocationName: stationToSave,
            photoData: photoData,
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : notes,
            trainModel: train
        )
        
        context.insert(newSpot)
        
        do {
            try context.save()
            
            // Haptisches Erfolgsfeedback: Bei Erstfund extra feierlich
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            
            // Textfelder & Foto leeren, aber TrainModel für Toast-Referenz merken
            tzNumber = ""
            notes = ""
            photoData = nil
            selectedPhotoItem = nil
            customStationName = ""
            
            showSuccessToast = true
            isSaving = false
            
            // Nach kurzer Verzögerung Formular komplett frei machen
            locationManager.requestLocation()
            return true
        } catch {
            errorMessage = "Fehler beim Speichern: \(error.localizedDescription)"
            isSaving = false
            return false
        }
    }
    
    public func resetForm() {
        selectedTrainModel = nil
        tzNumber = ""
        notes = ""
        customStationName = ""
        photoData = nil
        selectedPhotoItem = nil
        locationManager.requestLocation()
    }
}
