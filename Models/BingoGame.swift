import Foundation
import SwiftData

@Model
public final class BingoCell: Identifiable {
    public var id: UUID
    public var text: String
    public var iconName: String
    public var rarityRaw: String
    public var isChecked: Bool
    public var isJoker: Bool
    public var positionIndex: Int
    public var likelihoodPercent: Int = 50
    public var category: String = "Allgemein"

    public init(
        id: UUID = UUID(),
        text: String,
        iconName: String,
        rarityRaw: String,
        isChecked: Bool = false,
        isJoker: Bool = false,
        positionIndex: Int,
        likelihoodPercent: Int = 50,
        category: String = "Allgemein"
    ) {
        self.id = id
        self.text = text
        self.iconName = iconName
        self.rarityRaw = rarityRaw
        self.isChecked = isChecked
        self.isJoker = isJoker
        self.positionIndex = positionIndex
        self.likelihoodPercent = likelihoodPercent
        self.category = category
    }

    public var rarity: BingoRarity {
        BingoRarity(rawValue: rarityRaw) ?? .common
    }
}

@Model
public final class BingoGame: Identifiable {
    public var id: UUID
    public var startedAt: Date
    public var completedAt: Date?
    public var gridSize: Int // 3, 4 oder 5
    public var travelTitle: String? // z.B. "Fahrt nach Hamburg"
    public var isBingoAchieved: Bool
    public var isArchived: Bool = false

    @Relationship(deleteRule: .cascade)
    public var cells: [BingoCell] = []

    public init(
        id: UUID = UUID(),
        startedAt: Date = Date(),
        completedAt: Date? = nil,
        gridSize: Int = 3,
        travelTitle: String? = nil,
        isBingoAchieved: Bool = false,
        isArchived: Bool = false,
        cells: [BingoCell] = []
    ) {
        self.id = id
        self.startedAt = startedAt
        self.completedAt = completedAt
        self.gridSize = gridSize
        self.travelTitle = travelTitle
        self.isBingoAchieved = isBingoAchieved
        self.isArchived = isArchived
        self.cells = cells
    }

    public var sortedCells: [BingoCell] {
        cells.sorted { $0.positionIndex < $1.positionIndex }
    }

    /// Anzahl der vom Nutzer abgekreuzten Vorfälle (ohne Gratis-Joker)
    public var checkedIncidentsCount: Int {
        cells.filter { $0.isChecked && !$0.isJoker }.count
    }

    /// Berechnete Bahn-XP für diese Bingo-Fahrt
    public var earnedXP: Int {
        let cellXP = cells.filter { $0.isChecked && !$0.isJoker }.reduce(0) { sum, cell in
            sum + cell.rarity.xpPoints
        }
        let bingoBonus = isBingoAchieved ? 150 : 0
        return cellXP + bingoBonus
    }
}
