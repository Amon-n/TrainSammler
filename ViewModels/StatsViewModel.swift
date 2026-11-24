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

public struct SpotterAchievement: Identifiable {
    public let id: String
    public let title: String
    public let description: String
    public let icon: String
    public let color: Color
    public let currentValue: Int
    public let targetValue: Int

    public var isUnlocked: Bool {
        currentValue >= targetValue
    }

    public var progress: Double {
        guard targetValue > 0 else { return 1.0 }
        return min(1.0, Double(currentValue) / Double(targetValue))
    }
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
    public let uniqueTzCount: Int
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
    public let achievements: [SpotterAchievement]

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
    public static let uniqueTzBonusPoints = 25

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

        // 1. Zugsichtungs-Score berechnen (Erstfund verdoppelt Punkte, neue Tz-Nummer +25 XP)
        var spottingScore = 0
        var creditedModels = Set<UUID>()
        var seenTzPerModel: [UUID: Set<String>] = [:]
        var uniqueTzCount = 0

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

            if let normTz = SpottedTrain.normalizedTz(spot.tzNumber),
               !seenTzPerModel[model.id, default: []].contains(normTz) {
                spottingScore += uniqueTzBonusPoints
                seenTzPerModel[model.id, default: []].insert(normTz)
                uniqueTzCount += 1
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

        // 5. Seltenster Fund (bevorzugt seltener Zug -> eigenes Foto -> neuestes Datum)
        let rarestSpot = allSpottings.sorted { lhs, rhs in
            let lhsRarity = lhs.trainModel?.rarity ?? .common
            let rhsRarity = rhs.trainModel?.rarity ?? .common
            if lhsRarity != rhsRarity {
                return lhsRarity > rhsRarity
            }
            let lhsHasPhoto = lhs.photoData != nil
            let rhsHasPhoto = rhs.photoData != nil
            if lhsHasPhoto != rhsHasPhoto {
                return lhsHasPhoto && !rhsHasPhoto
            }
            return lhs.spottedAt > rhs.spottedAt
        }.first

        // 6. Meilensteine / Achievements
        let spottedHighSpeed = allTrains.filter { $0.category == .highSpeed && $0.isSpotted }.count
        let spottedRegional = allTrains.filter { $0.category == .regional && $0.isSpotted }.count
        let spottedLegendary = allTrains.filter { $0.rarity == .legendary && $0.isSpotted }.count
        let photoSpotCount = allSpottings.filter { $0.photoData != nil }.count
        let uniqueStations = Set(allSpottings.compactMap { spot -> String? in
            let s = spot.stationOrLocationName?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            return s.isEmpty ? nil : s.lowercased()
        }).count

        let achievements: [SpotterAchievement] = [
            SpotterAchievement(
                id: "first_spot",
                title: "Erster Halt",
                description: "Erste Zugsichtung erfasst",
                icon: "tram.fill",
                color: .blue,
                currentValue: totalSpottings,
                targetValue: 1
            ),
            SpotterAchievement(
                id: "tz_hunter",
                title: "Triebzug-Jäger",
                description: "5 verschiedene Tz-Nummern",
                icon: "number.square.fill",
                color: .teal,
                currentValue: uniqueTzCount,
                targetValue: 5
            ),
            SpotterAchievement(
                id: "ice_expert",
                title: "Fernverkehrs-Profi",
                description: "5 Fernverkehrs-Baureihen",
                icon: "bolt.horizontal.circle.fill",
                color: .red,
                currentValue: spottedHighSpeed,
                targetValue: 5
            ),
            SpotterAchievement(
                id: "regio_commuter",
                title: "Regio-Pendler",
                description: "5 Regional-Baureihen",
                icon: "map.fill",
                color: .green,
                currentValue: spottedRegional,
                targetValue: 5
            ),
            SpotterAchievement(
                id: "special_luck",
                title: "Sonderzug-Glück",
                description: "Legendären Zug gesichtet",
                icon: "crown.fill",
                color: .orange,
                currentValue: spottedLegendary,
                targetValue: 1
            ),
            SpotterAchievement(
                id: "photo_spotter",
                title: "Foto-Spotter",
                description: "5 Sichtungen mit eigenem Foto",
                icon: "camera.aperture",
                color: .purple,
                currentValue: photoSpotCount,
                targetValue: 5
            ),
            SpotterAchievement(
                id: "station_hopper",
                title: "Bahnhofs-Hopper",
                description: "5 verschiedene Orte besucht",
                icon: "mappin.and.ellipse",
                color: .indigo,
                currentValue: uniqueStations,
                targetValue: 5
            ),
            SpotterAchievement(
                id: "bingo_champ",
                title: "Bingo-Champion",
                description: "Ein DB-Bingo gewonnen",
                icon: "trophy.fill",
                color: .yellow,
                currentValue: achievedBingos,
                targetValue: 1
            )
        ]

        return TrainStats(
            totalSpottings: totalSpottings,
            uniqueTrainsSpotted: uniqueTrainsSpotted,
            uniqueTzCount: uniqueTzCount,
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
            rarestSpot: rarestSpot,
            achievements: achievements
        )
    }
}
