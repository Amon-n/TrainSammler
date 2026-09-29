import Foundation
import SwiftData

@Model
public final class TrainModel: Identifiable {
    public var id: UUID
    public var seriesCode: String            // z.B. "BR 408"
    public var commercialName: String         // z.B. "ICE 3neo"
    public var designation: String?          // z.B. "Rheinland" (Taufname / Sub-Variante)
    public var rarity: RarityTier
    public var category: TrainCategory
    public var overviewDescription: String
    public var assetName: String             // Name des Bildassets oder SF Symbols
    public var maxSpeedKmH: Int?             // z.B. 320
    
    // 1-zu-N Beziehung: Ein Zugtyp kann mehrfach gesichtet werden
    @Relationship(deleteRule: .cascade, inverse: \SpottedTrain.trainModel)
    public var spottings: [SpottedTrain] = []
    
    public init(
        id: UUID = UUID(),
        seriesCode: String,
        commercialName: String,
        designation: String? = nil,
        rarity: RarityTier = .common,
        category: TrainCategory = .highSpeed,
        overviewDescription: String = "",
        assetName: String = "tram.fill",
        maxSpeedKmH: Int? = nil
    ) {
        self.id = id
        self.seriesCode = seriesCode
        self.commercialName = commercialName
        self.designation = designation
        self.rarity = rarity
        self.category = category
        self.overviewDescription = overviewDescription
        self.assetName = assetName
        self.maxSpeedKmH = maxSpeedKmH
    }
    
    // Convenience: Wurde dieses Modell jemals gespottet?
    public var isSpotted: Bool {
        !spottings.isEmpty
    }
    
    public var spotCount: Int {
        spottings.count
    }
}
