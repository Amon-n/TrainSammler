import Foundation
import SwiftData
import SwiftUI

public struct CategoryProgress: Identifiable {
    public var id: String { category.rawValue }
    public let category: TrainCategory
    public let spottedCount: Int
    public let totalCount: Int
    
    public var percentage: Double {
        guard totalCount > 0 else { return 0 }
        return (Double(spottedCount) / Double(totalCount)) * 100.0
    }
}

public struct RarityCount: Identifiable {
    public var id: String { rarity.rawValue }
    public let rarity: RarityTier
    public let count: Int
}

@MainActor
public final class StatsCalculator {
    public static func computeStats(allTrains: [TrainModel], allSpottings: [SpottedTrain]) -> (
        totalSpottings: Int,
        uniqueTrainsSpotted: Int,
        totalTrainsInCatalog: Int,
        totalScore: Int,
        completionPercentage: Double,
        categoryProgress: [CategoryProgress],
        rarityCounts: [RarityCount],
        rarestSpot: SpottedTrain?
    ) {
        let totalSpottings = allSpottings.count
        let totalTrainsInCatalog = allTrains.count
        let uniqueTrainsSpotted = allTrains.filter { $0.isSpotted }.count
        
        let completionPercentage: Double = totalTrainsInCatalog > 0
            ? (Double(uniqueTrainsSpotted) / Double(totalTrainsInCatalog)) * 100.0
            : 0.0
            
        // Gesamtscore berechnen:
        // Jede Sichtung bringt Punkte entsprechend der Seltenheit des Zuges.
        // Ein Erstfund (First Catch) einer Baureihe verdoppelt die Punkte!
        var score = 0
        var creditedModels = Set<UUID>()
        
        // Sortiere chronologisch für First-Catch-Boni
        let sortedSpottings = allSpottings.sorted { $0.spottedAt < $1.spottedAt }
        for spot in sortedSpottings {
            guard let model = spot.trainModel else {
                score += 50
                continue
            }
            let basePoints = model.rarity.points
            if !creditedModels.contains(model.id) {
                // First catch bonus!
                score += basePoints * 2
                creditedModels.insert(model.id)
            } else {
                score += basePoints
            }
        }
        
        // Kategorie-Fortschritt
        let categoryProgress: [CategoryProgress] = TrainCategory.allCases.map { category in
            let trainsInCat = allTrains.filter { $0.category == category }
            let spottedInCat = trainsInCat.filter { $0.isSpotted }.count
            return CategoryProgress(category: category, spottedCount: spottedInCat, totalCount: trainsInCat.count)
        }
        
        // Rarity Verteilung der Sichtungen
        let rarityCounts: [RarityCount] = RarityTier.allCases.map { rarity in
            let count = allSpottings.filter { $0.trainModel?.rarity == rarity }.count
            return RarityCount(rarity: rarity, count: count)
        }
        
        // Seltenster Fund
        let rarestSpot = allSpottings
            .sorted { ($0.trainModel?.rarity ?? .common) > ($1.trainModel?.rarity ?? .common) }
            .first
            
        return (
            totalSpottings,
            uniqueTrainsSpotted,
            totalTrainsInCatalog,
            score,
            completionPercentage,
            categoryProgress,
            rarityCounts,
            rarestSpot
        )
    }
}
