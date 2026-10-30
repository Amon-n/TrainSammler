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

    public var minScore: Int {
        switch self {
        case .beginner: return 0
        case .scout: return 500
        case .enthusiast: return 1500
        case .master: return 3000
        case .legend: return 6000
        }
    }

    public var nextRank: UserRank? {
        switch self {
        case .beginner: return .scout
        case .scout: return .enthusiast
        case .enthusiast: return .master
        case .master: return .legend
        case .legend: return nil
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
    public let spottingScore: Int
    public let bingoScore: Int
    public let completedBingoTrips: Int
    public let achievedBingos: Int
    public let totalBingoIncidents: Int
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

    public var rankProgress: Double {
        let current = userRank
        guard let next = current.nextRank else { return 1.0 }
        let span = max(1, next.minScore - current.minScore)
        let progress = Double(totalScore - current.minScore) / Double(span)
        return min(1.0, max(0.0, progress))
    }

    public var pointsToNextRank: Int? {
        guard let next = userRank.nextRank else { return nil }
        return max(0, next.minScore - totalScore)
    }
}

@MainActor
public final class StatsCalculator {
    public static func computeStats(
        allTrains: [TrainModel],
        allSpottings: [SpottedTrain],
        bingoGames: [BingoGame] = []
    ) -> TrainStats {
        let totalSpottings = allSpottings.count
        let totalTrainsInCatalog = allTrains.count
        let uniqueTrainsSpotted = allTrains.filter { $0.isSpotted }.count

        let completionPercentage: Double = totalTrainsInCatalog > 0
            ? (Double(uniqueTrainsSpotted) / Double(totalTrainsInCatalog)) * 100.0
            : 0.0

        // 1. Zugsichtungs-Score berechnen (Erstfund verdoppelt die Punkte)
        var spottingScore = 0
        var creditedModels = Set<UUID>()

        let sortedSpottings = allSpottings.sorted { $0.spottedAt < $1.spottedAt }
        for spot in sortedSpottings {
            guard let model = spot.trainModel else {
                spottingScore += 50
                continue
            }
            let basePoints = model.rarity.points
            if !creditedModels.contains(model.id) {
                spottingScore += basePoints * 2
                creditedModels.insert(model.id)
            } else {
                spottingScore += basePoints
            }
        }

        // 2. DB-Bingo-Score berechnen
        let archivedBingos = bingoGames.filter(\.isArchived)
        let bingoScore = archivedBingos.reduce(0) { $0 + $1.earnedXP }
        let completedBingoTrips = archivedBingos.count
        let achievedBingos = archivedBingos.filter(\.isBingoAchieved).count
        let totalBingoIncidents = archivedBingos.reduce(0) { $0 + $1.checkedIncidentsCount }

        let totalScore = spottingScore + bingoScore

        // 3. Kategorie-Fortschritt
        let categoryProgress: [CategoryProgress] = TrainCategory.allCases.map { category in
            let trainsInCat = allTrains.filter { $0.category == category }
            let spottedInCat = trainsInCat.filter { $0.isSpotted }.count
            return CategoryProgress(category: category, spottedCount: spottedInCat, totalCount: trainsInCat.count)
        }

        // 4. Rarity Verteilung der Sichtungen
        let rarityCounts: [RarityCount] = RarityTier.allCases.map { rarity in
            let count = allSpottings.filter { $0.trainModel?.rarity == rarity }.count
            return RarityCount(rarity: rarity, count: count)
        }

        // 5. Seltenster Fund
        let rarestSpot = allSpottings
            .sorted { ($0.trainModel?.rarity ?? .common) > ($1.trainModel?.rarity ?? .common) }
            .first

        return TrainStats(
            totalSpottings: totalSpottings,
            uniqueTrainsSpotted: uniqueTrainsSpotted,
            totalTrainsInCatalog: totalTrainsInCatalog,
            totalScore: totalScore,
            spottingScore: spottingScore,
            bingoScore: bingoScore,
            completedBingoTrips: completedBingoTrips,
            achievedBingos: achievedBingos,
            totalBingoIncidents: totalBingoIncidents,
            completionPercentage: completionPercentage,
            categoryProgress: categoryProgress,
            rarityCounts: rarityCounts,
            rarestSpot: rarestSpot
        )
    }
}
