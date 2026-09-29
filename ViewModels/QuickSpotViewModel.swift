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
    public var selectedPhotoItem: PhotosPickerItem?
    public var photoData: Data?
    
    // UI-Zustände & Feedback
    public var isSaving: Bool = false
    public var showSuccessToast: Bool = false
    public var errorMessage: String?
    
    // Location Dependency
    public var locationManager: LocationManager
    
    public init(locationManager: LocationManager? = nil) {
        self.locationManager = locationManager ?? LocationManager()
    }
    
    public func onAppear() {
        locationManager.requestLocation()
    }
    
    public func loadSelectedPhoto() async {
        guard let item = selectedPhotoItem else { return }
        do {
            if let data = try await item.loadTransferable(type: Data.self) {
                await MainActor.run {
                    self.photoData = data
                }
            }
        } catch {
            print("Fehler beim Laden des Bildes: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    public func saveSpotting(context: ModelContext) -> Bool {
        guard let train = selectedTrainModel else {
            errorMessage = "Bitte wähle eine Baureihe aus."
            return false
        }
        
        isSaving = true
        let coordinate = locationManager.lastLocation?.coordinate
        
        let newSpot = SpottedTrain(
            spottedAt: Date(),
            tzNumber: tzNumber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : tzNumber,
            latitude: coordinate?.latitude,
            longitude: coordinate?.longitude,
            stationOrLocationName: locationManager.currentPlaceName.isEmpty ? nil : locationManager.currentPlaceName,
            photoData: photoData,
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : notes,
            trainModel: train
        )
        
        context.insert(newSpot)
        
        do {
            try context.save()
            
            // Haptisches Erfolgsfeedback
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            
            resetForm()
            showSuccessToast = true
            isSaving = false
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
        photoData = nil
        selectedPhotoItem = nil
        // Neuen Standort-Fix anfragen für nächsten Spot
        locationManager.requestLocation()
    }
}
