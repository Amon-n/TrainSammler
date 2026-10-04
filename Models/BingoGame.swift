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
    
    public init(
        id: UUID = UUID(),
        text: String,
        iconName: String,
        rarityRaw: String,
        isChecked: Bool = false,
        isJoker: Bool = false,
        positionIndex: Int
    ) {
        self.id = id
        self.text = text
        self.iconName = iconName
        self.rarityRaw = rarityRaw
        self.isChecked = isChecked
        self.isJoker = isJoker
        self.positionIndex = positionIndex
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
    
    @Relationship(deleteRule: .cascade)
    public var cells: [BingoCell] = []
    
    public init(
        id: UUID = UUID(),
        startedAt: Date = Date(),
        completedAt: Date? = nil,
        gridSize: Int = 3,
        travelTitle: String? = nil,
        isBingoAchieved: Bool = false,
        cells: [BingoCell] = []
    ) {
        self.id = id
        self.startedAt = startedAt
        self.completedAt = completedAt
        self.gridSize = gridSize
        self.travelTitle = travelTitle
        self.isBingoAchieved = isBingoAchieved
        self.cells = cells
    }
    
    public var sortedCells: [BingoCell] {
        cells.sorted { $0.positionIndex < $1.positionIndex }
    }
}
