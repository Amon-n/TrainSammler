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

public enum UserRank: String, CaseIterable {
    case beginner = "Bahnsteig-Neuling"
    case scout = "Gleis-Scout"
    case enthusiast = "Zug-Enthusiast"
    case master = "Hauptbahnhof-Meister"
    case legend = "ICE-Legende"
    
    public var icon: String {
        switch self {
        case .beginner: return "figure.walk"
        case .scout: return "binoculars.fill"
        case .enthusiast: return "tram.fill"
        case .master: return "star.circle.fill"
        case .legend: return "crown.fill"
        }
    }
    
    public static func rank(for score: Int) -> UserRank {
        switch score {
        case ..<500: return .beginner
        case 500..<1500: return .scout
        case 1500..<3000: return .enthusiast
        case 3000..<6000: return .master
        default: return .legend
        }
    }
}

public struct TrainStats {
    public let totalSpottings: Int
    public let uniqueTrainsSpotted: Int
    public let totalTrainsInCatalog: Int
    public let totalScore: Int
    public let completionPercentage: Double
    public let categoryProgress: [CategoryProgress]
    public let rarityCounts: [RarityCount]
    public let rarestSpot: SpottedTrain?
    
    public var userRank: UserRank {
        UserRank.rank(for: totalScore)
    }
    
    public var level: Int {
        max(1, totalScore / 1000 + 1)
    }
    
    public var remainingTrains: Int {
        max(0, totalTrainsInCatalog - uniqueTrainsSpotted)
    }
}

@MainActor
public final class StatsCalculator {
    public static func computeStats(allTrains: [TrainModel], allSpottings: [SpottedTrain]) -> TrainStats {
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
            
        return TrainStats(
            totalSpottings: totalSpottings,
            uniqueTrainsSpotted: uniqueTrainsSpotted,
            totalTrainsInCatalog: totalTrainsInCatalog,
            totalScore: score,
            completionPercentage: completionPercentage,
            categoryProgress: categoryProgress,
            rarityCounts: rarityCounts,
            rarestSpot: rarestSpot
        )
    }
}
