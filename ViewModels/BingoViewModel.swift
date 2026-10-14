import Foundation
import SwiftUI
import SwiftData

@MainActor
@Observable
public final class BingoViewModel {
    public var activeGame: BingoGame?
    public var selectedGridSize: Int = 3
    public var tripName: String = ""
    public var showNewGameAlert: Bool = false
    public var showWinAnimation: Bool = false
    public var winningLineType: String? = nil
    
    public init() {}
    
    public func loadOrCreateGame(context: ModelContext) {
        var descriptor = FetchDescriptor<BingoGame>(
            predicate: #Predicate { !$0.isArchived },
            sortBy: [SortDescriptor(\.startedAt, order: .reverse)]
        )
        descriptor.fetchLimit = 1
        
        if let games = try? context.fetch(descriptor), let existing = games.first {
            self.activeGame = existing
            self.selectedGridSize = existing.gridSize
            self.tripName = existing.travelTitle ?? ""
        } else {
            startNewGame(context: context, size: selectedGridSize, title: tripName)
        }
    }
    
    public func startNewGame(context: ModelContext, size: Int, title: String? = nil) {
        // Altes Spiel archivieren statt löschen, falls es Kacheln angekreuzt hatte
        if let old = activeGame {
            let hasCheckedCells = old.cells.contains { $0.isChecked && !$0.isJoker }
            if hasCheckedCells || old.isBingoAchieved {
                old.isArchived = true
                if old.completedAt == nil {
                    old.completedAt = Date()
                }
            } else {
                context.delete(old)
            }
        }
        
        let totalCells = size * size
        let isFiveByFive = (size == 5)
        let middleIndex = isFiveByFive ? 12 : -1 // Bei 5x5 Index 12 (Mitte) als Joker
        
        // Zufällige Vorfälle auswählen
        let pool = pickIncidents(count: isFiveByFive ? totalCells - 1 : totalCells)
        
        var generatedCells: [BingoCell] = []
        var poolIndex = 0
        
        for i in 0..<totalCells {
            if isFiveByFive && i == middleIndex {
                // Goldenes Freifeld / Joker
                let jokerCell = BingoCell(
                    text: "FREIFELD\n(Reise gestartet)",
                    iconName: "star.fill",
                    rarityRaw: BingoRarity.rare.rawValue,
                    isChecked: true, // Joker ist sofort aktiv
                    isJoker: true,
                    positionIndex: i
                )
                generatedCells.append(jokerCell)
            } else {
                let item = pool[poolIndex]
                poolIndex += 1
                let cell = BingoCell(
                    text: item.text,
                    iconName: item.iconName,
                    rarityRaw: item.rarity.rawValue,
                    isChecked: false,
                    isJoker: false,
                    positionIndex: i
                )
                generatedCells.append(cell)
            }
        }
        
        let newGame = BingoGame(
            startedAt: Date(),
            gridSize: size,
            travelTitle: (title?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false) ? title : nil,
            cells: generatedCells
        )
        
        context.insert(newGame)
        try? context.save()
        
        self.activeGame = newGame
        self.selectedGridSize = size
        self.showWinAnimation = false
        self.winningLineType = nil
    }
    
    private func pickIncidents(count: Int) -> [BingoIncident] {
        let commons = BingoCatalog.incidents.filter { $0.rarity == .common }.shuffled()
        let uncommons = BingoCatalog.incidents.filter { $0.rarity == .uncommon }.shuffled()
        let rares = BingoCatalog.incidents.filter { $0.rarity == .rare }.shuffled()
        
        var selected: [BingoIncident] = []
        
        // 1-2 Rares
        let rareCount = min(Int.random(in: 1...2), rares.count)
        selected.append(contentsOf: rares.prefix(rareCount))
        
        // 2-4 Uncommons
        let uncommonCount = min(max(2, count / 4), uncommons.count)
        selected.append(contentsOf: uncommons.prefix(uncommonCount))
        
        // Rest mit Commons auffüllen
        let remaining = count - selected.count
        selected.append(contentsOf: commons.prefix(remaining))
        
        // Falls noch nicht genug, Rest beliebig auffüllen
        if selected.count < count {
            let leftOver = BingoCatalog.incidents.filter { !selected.map(\.id).contains($0.id) }.shuffled()
            selected.append(contentsOf: leftOver.prefix(count - selected.count))
        }
        
        return selected.shuffled()
    }
    
    public func toggleCell(_ cell: BingoCell, context: ModelContext) {
        guard !cell.isJoker else { return } // Joker kann nicht deaktiviert werden
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        cell.isChecked.toggle()
        try? context.save()
        
        checkWinCondition(context: context)
    }
    
    public func checkWinCondition(context: ModelContext) {
        guard let game = activeGame else { return }
        let size = game.gridSize
        let cells = game.sortedCells
        guard cells.count == size * size else { return }
        
        var won = false
        var lineType = ""
        
        // 1. Zeilen prüfen
        for row in 0..<size {
            let rowChecked = (0..<size).allSatisfy { col in
                cells[row * size + col].isChecked
            }
            if rowChecked {
                won = true
                lineType = "Reihe \(row + 1) voll!"
                break
            }
        }
        
        // 2. Spalten prüfen
        if !won {
            for col in 0..<size {
                let colChecked = (0..<size).allSatisfy { row in
                    cells[row * size + col].isChecked
                }
                if colChecked {
                    won = true
                    lineType = "Spalte \(col + 1) voll!"
                    break
                }
            }
        }
        
        // 3. Diagonale 1 (oben-links nach unten-rechts)
        if !won {
            let diag1Checked = (0..<size).allSatisfy { i in
                cells[i * size + i].isChecked
            }
            if diag1Checked {
                won = true
                lineType = "Diagonale voll!"
            }
        }
        
        // 4. Diagonale 2 (oben-rechts nach unten-links)
        if !won {
            let diag2Checked = (0..<size).allSatisfy { i in
                cells[i * size + (size - 1 - i)].isChecked
            }
            if diag2Checked {
                won = true
                lineType = "Diagonale voll!"
            }
        }
        
        if won && !game.isBingoAchieved {
            let winGen = UINotificationFeedbackGenerator()
            winGen.notificationOccurred(.success)
            
            game.isBingoAchieved = true
            game.completedAt = Date()
            try? context.save()
            
            self.winningLineType = lineType
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                self.showWinAnimation = true
            }
        }
    }
}
