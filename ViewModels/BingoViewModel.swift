import Foundation
import SwiftUI
import SwiftData

public enum BingoDifficultyMode: String, CaseIterable, Identifiable, Sendable {
    case realistic = "Alltag (Realistisch)"
    case classic = "Bahn-Chaos (Mehr Kurioses)"

    public var id: String { rawValue }

    public var shortTitle: String {
        switch self {
        case .realistic: return "Alltagsnah"
        case .classic: return "Chaos-Mix"
        }
    }

    public var description: String {
        switch self {
        case .realistic:
            return "Hohe Trefferquote mit normalen Vorfällen (Verspätungen, Durchsagen, Alltag im Wagen) – ideal für jede normale Fahrt."
        case .classic:
            return "Mehr seltene DB-Kuriositäten und Pannen für lange Fernverkehrsreisen."
        }
    }
}

@MainActor
@Observable
public final class BingoViewModel {
    public var activeGame: BingoGame?
    public var selectedGridSize: Int = 3
    public var difficultyMode: BingoDifficultyMode = .realistic
    public var tripName: String = ""
    public var showNewGameAlert: Bool = false
    public var showFinishTripSheet: Bool = false
    public var showWinAnimation: Bool = false
    public var winningLineType: String? = nil

    // Feedback nach dem Abschließen & Speichern einer Reise
    public var showTripSavedToast: Bool = false
    public var lastSavedTripXP: Int = 0
    public var lastSavedTripTitle: String = ""

    public init() {}

    public func loadOrCreateGame(context: ModelContext) {
        let descriptor = FetchDescriptor<BingoGame>(
            predicate: #Predicate { !$0.isArchived },
            sortBy: [SortDescriptor(\.startedAt, order: .reverse)]
        )

        if let games = try? context.fetch(descriptor), !games.isEmpty {
            let active = games[0]
            self.activeGame = active
            self.selectedGridSize = active.gridSize
            self.tripName = active.travelTitle ?? ""

            // Migriere ältere, zu lange Kacheltexte auf prägnante Kurztexte
            let validTexts = Set(BingoCatalog.incidents.map(\.text))
            var migrated = false
            for cell in active.cells {
                if cell.isJoker && cell.text != "FREIFELD" {
                    cell.text = "FREIFELD"
                    migrated = true
                } else if !cell.isJoker && !validTexts.contains(cell.text) {
                    if let match = BingoCatalog.incidents.first(where: { $0.iconName == cell.iconName && $0.category == cell.category }) {
                        cell.text = match.text
                        migrated = true
                    } else if let fallback = BingoCatalog.incidents.first(where: { $0.rarity == cell.rarity && !active.cells.map(\.text).contains($0.text) }) {
                        cell.text = fallback.text
                        cell.iconName = fallback.iconName
                        migrated = true
                    }
                }
            }

            // Falls mehr als ein unarchiviertes Spiel existiert, die älteren archivieren
            if games.count > 1 {
                for extra in games.dropFirst() {
                    extra.isArchived = true
                    if extra.completedAt == nil {
                        extra.completedAt = Date()
                    }
                }
                migrated = true
            }
            if migrated {
                try? context.save()
            }
        } else {
            startNewGame(context: context, size: selectedGridSize, title: tripName, archiveOld: false)
        }
    }

    /// Beendet die aktuelle Reise explizit, speichert sie dauerhaft im Logbuch und bereitet ein neues Brett vor.
    @discardableResult
    public func finishCurrentTrip(context: ModelContext, customTitle: String? = nil) -> BingoGame? {
        guard let current = activeGame else { return nil }

        let trimmedCustom = customTitle?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let trimmedExisting = current.travelTitle?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        let finalTitle: String
        if !trimmedCustom.isEmpty {
            finalTitle = trimmedCustom
        } else if !trimmedExisting.isEmpty {
            finalTitle = trimmedExisting
        } else {
            finalTitle = "Fahrt am \(current.startedAt.formatted(date: .abbreviated, time: .omitted))"
        }

        current.travelTitle = finalTitle
        current.completedAt = Date()
        current.isArchived = true

        let earnedXP = current.earnedXP
        self.lastSavedTripXP = earnedXP
        self.lastSavedTripTitle = finalTitle

        try? context.save()

        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)

        // Frisches Spiel für die nächste Fahrt anlegen (ohne das gerade archivierte nochmal anzufassen)
        self.activeGame = nil
        self.tripName = ""
        startNewGame(context: context, size: selectedGridSize, title: nil, archiveOld: false)

        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
            self.showTripSavedToast = true
        }

        return current
    }

    public func startNewGame(
        context: ModelContext,
        size: Int,
        title: String? = nil,
        archiveOld: Bool = true
    ) {
        if let old = activeGame {
            if archiveOld {
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
        }

        let totalCells = size * size
        let isFiveByFive = (size == 5)
        let middleIndex = isFiveByFive ? 12 : -1 // Bei 5x5 Index 12 (Mitte) als Joker

        // Wahrscheinlichkeits-gewichtete Vorfälle auswählen & fair verteilen
        let orderedPool = generateBalancedBoardIncidents(size: size, isFiveByFive: isFiveByFive)

        var generatedCells: [BingoCell] = []
        var poolIndex = 0

        for i in 0..<totalCells {
            if isFiveByFive && i == middleIndex {
                let jokerCell = BingoCell(
                    text: "FREIFELD",
                    iconName: "star.fill",
                    rarityRaw: BingoRarity.everyday.rawValue,
                    isChecked: true,
                    isJoker: true,
                    positionIndex: i,
                    likelihoodPercent: 100,
                    category: "Joker"
                )
                generatedCells.append(jokerCell)
            } else {
                let item = orderedPool[poolIndex]
                poolIndex += 1
                let cell = BingoCell(
                    text: item.text,
                    iconName: item.iconName,
                    rarityRaw: item.rarity.rawValue,
                    isChecked: false,
                    isJoker: false,
                    positionIndex: i,
                    likelihoodPercent: item.likelihoodPercent,
                    category: item.category
                )
                generatedCells.append(cell)
            }
        }

        let trimmedTitle = title?.trimmingCharacters(in: .whitespacesAndNewlines)
        let newGame = BingoGame(
            startedAt: Date(),
            gridSize: size,
            travelTitle: (trimmedTitle?.isEmpty == false) ? trimmedTitle : nil,
            cells: generatedCells
        )

        context.insert(newGame)
        try? context.save()

        self.activeGame = newGame
        self.selectedGridSize = size
        self.showWinAnimation = false
        self.winningLineType = nil
    }

    /// Tauscht ein einzelnes unpassendes Feld gegen ein neues alltagsnahes Feld aus
    public func replaceSingleCell(_ cell: BingoCell, context: ModelContext) {
        guard !cell.isJoker, let game = activeGame else { return }

        let existingTexts = Set(game.cells.map(\.text))
        let candidates = BingoCatalog.incidents.filter {
            !existingTexts.contains($0.text) && ($0.rarity == .everyday || $0.rarity == .common)
        }

        guard let replacement = weightedSample(from: candidates, count: 1, maxPerExclusivityGroup: 1).first else {
            return
        }

        let generator = UIImpactFeedbackGenerator(style: .rigid)
        generator.impactOccurred()

        cell.text = replacement.text
        cell.iconName = replacement.iconName
        cell.rarityRaw = replacement.rarity.rawValue
        cell.likelihoodPercent = replacement.likelihoodPercent
        cell.category = replacement.category
        cell.isChecked = false

        try? context.save()
        checkWinCondition(context: context)
    }

    // MARK: - Wahrscheinlichkeits-Gewichtete Brett-Generierung

    private func generateBalancedBoardIncidents(size: Int, isFiveByFive: Bool) -> [BingoIncident] {
        let count = isFiveByFive ? (size * size - 1) : (size * size)

        let everydayPool = BingoCatalog.incidents.filter { $0.rarity == .everyday }
        let commonPool = BingoCatalog.incidents.filter { $0.rarity == .common }
        let uncommonPool = BingoCatalog.incidents.filter { $0.rarity == .uncommon }
        let rarePool = BingoCatalog.incidents.filter { $0.rarity == .rare }

        // Zielverteilung nach Brettgröße und Schwierigkeitsmodus
        let targetEveryday: Int
        let targetCommon: Int
        let targetUncommon: Int
        let targetRare: Int

        switch (size, difficultyMode) {
        case (3, .realistic):
            // 3x3 Alltag: 5 sehr häufige, 3 häufige, max 1 gelegentliches, 0 seltene -> Jede Reihe gut machbar!
            targetEveryday = 5
            targetCommon = 3
            targetUncommon = 1
            targetRare = 0
        case (3, .classic):
            targetEveryday = 4
            targetCommon = 3
            targetUncommon = 1
            targetRare = 1
        case (4, .realistic):
            // 4x4 Alltag: 9 sehr häufige, 5 häufige, 2 gelegentliche, 0-1 seltenes
            targetEveryday = 9
            targetCommon = 5
            targetUncommon = 2
            targetRare = 0
        case (4, .classic):
            targetEveryday = 6
            targetCommon = 5
            targetUncommon = 3
            targetRare = 2
        case (_, .realistic):
            // 5x5 Alltag (24 Felder): 12 sehr häufige, 8 häufige, 3 gelegentliche, 1 seltenes
            targetEveryday = 12
            targetCommon = 8
            targetUncommon = 3
            targetRare = 1
        case (_, .classic):
            targetEveryday = 9
            targetCommon = 8
            targetUncommon = 4
            targetRare = 3
        }

        let maxDelayCards = (size == 3) ? 1 : 2
        var groupCounts: [String: Int] = [:]

        var selected: [BingoIncident] = []

        func appendSampled(from pool: [BingoIncident], needed: Int) {
            guard needed > 0 else { return }
            let picked = weightedSample(
                from: pool.filter { item in
                    !selected.contains(where: { $0.id == item.id })
                },
                count: needed,
                maxPerExclusivityGroup: maxDelayCards,
                existingGroupCounts: &groupCounts
            )
            selected.append(contentsOf: picked)
        }

        appendSampled(from: everydayPool, needed: targetEveryday)
        appendSampled(from: commonPool, needed: targetCommon)
        appendSampled(from: uncommonPool, needed: targetUncommon)
        appendSampled(from: rarePool, needed: targetRare)

        // Falls aus irgendeinem Grund noch Plätze offen sind, mit Alltag/Common auffüllen
        if selected.count < count {
            let fallbackPool = (everydayPool + commonPool).filter { cand in
                !selected.contains(where: { $0.id == cand.id })
            }
            appendSampled(from: fallbackPool, needed: count - selected.count)
        }

        // Anti-Cluster-Verteilung: Seltene/Gelegentliche Felder so platzieren,
        // dass sie sich nicht in derselben Zeile/Spalte häufen.
        return distributeFairlyAcrossGrid(incidents: Array(selected.prefix(count)), size: size, isFiveByFive: isFiveByFive)
    }

    /// Gewichtete Zufallsauswahl anhand von `likelihoodPercent`
    private func weightedSample(
        from pool: [BingoIncident],
        count: Int,
        maxPerExclusivityGroup: Int
    ) -> [BingoIncident] {
        var dummy: [String: Int] = [:]
        return weightedSample(
            from: pool,
            count: count,
            maxPerExclusivityGroup: maxPerExclusivityGroup,
            existingGroupCounts: &dummy
        )
    }

    private func weightedSample(
        from pool: [BingoIncident],
        count: Int,
        maxPerExclusivityGroup: Int,
        existingGroupCounts: inout [String: Int]
    ) -> [BingoIncident] {
        guard count > 0, !pool.isEmpty else { return [] }
        var available = pool
        var result: [BingoIncident] = []

        while result.count < count && !available.isEmpty {
            // Filtere Kandidaten heraus, deren Exclusivity-Group bereits ausgeschöpft ist
            available.removeAll { item in
                if let group = item.exclusivityGroup {
                    return (existingGroupCounts[group] ?? 0) >= maxPerExclusivityGroup
                }
                return false
            }
            guard !available.isEmpty else { break }

            let totalWeight = available.reduce(0) { $0 + max(1, $1.likelihoodPercent) }
            let randomPoint = Int.random(in: 0..<max(1, totalWeight))

            var cumulative = 0
            var chosenIndex = 0
            for (idx, candidate) in available.enumerated() {
                cumulative += max(1, candidate.likelihoodPercent)
                if randomPoint < cumulative {
                    chosenIndex = idx
                    break
                }
            }

            let chosen = available.remove(at: chosenIndex)
            result.append(chosen)
            if let group = chosen.exclusivityGroup {
                existingGroupCounts[group, default: 0] += 1
            }
        }

        return result
    }

    /// Verteilt seltenere Felder auf verschiedene Zeilen und Spalten, damit keine unlösbaren Reihen entstehen
    private func distributeFairlyAcrossGrid(
        incidents: [BingoIncident],
        size: Int,
        isFiveByFive: Bool
    ) -> [BingoIncident] {
        let shuffledAll = incidents.shuffled()
        guard shuffledAll.count == (isFiveByFive ? size * size - 1 : size * size) else {
            return shuffledAll
        }

        // Trenne schwere (rare/uncommon) und leichte (everyday/common) Vorfälle
        let harder = shuffledAll.filter { $0.rarity == .rare || $0.rarity == .uncommon }
        var easier = shuffledAll.filter { $0.rarity == .everyday || $0.rarity == .common }.shuffled()

        guard !harder.isEmpty else { return shuffledAll }

        let totalSlots = size * size
        let middleSlot = isFiveByFive ? 12 : -1
        var slotMap: [Int: BingoIncident] = [:]
        var usedRows = Set<Int>()
        var usedCols = Set<Int>()

        let candidateSlots = (0..<totalSlots).filter { $0 != middleSlot }.shuffled()

        for hardItem in harder {
            // Suche einen Slot in einer Zeile & Spalte, die noch kein schweres Item hat
            if let idealSlot = candidateSlots.first(where: { slot in
                slotMap[slot] == nil && !usedRows.contains(slot / size) && !usedCols.contains(slot % size)
            }) {
                slotMap[idealSlot] = hardItem
                usedRows.insert(idealSlot / size)
                usedCols.insert(idealSlot % size)
            } else if let fallbackSlot = candidateSlots.first(where: { slotMap[$0] == nil }) {
                slotMap[fallbackSlot] = hardItem
            }
        }

        var orderedResult: [BingoIncident] = []
        for slot in 0..<totalSlots {
            if slot == middleSlot { continue }
            if let hard = slotMap[slot] {
                orderedResult.append(hard)
            } else if !easier.isEmpty {
                orderedResult.append(easier.removeFirst())
            }
        }

        return orderedResult
    }

    // MARK: - Interaktion & Gewinnprüfung

    public func toggleCell(_ cell: BingoCell, context: ModelContext) {
        guard !cell.isJoker else { return }

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
                lineType = "Reihe \(row + 1) komplett!"
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
                    lineType = "Spalte \(col + 1) komplett!"
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
                lineType = "Diagonale komplett!"
            }
        }

        // 4. Diagonale 2 (oben-rechts nach unten-links)
        if !won {
            let diag2Checked = (0..<size).allSatisfy { i in
                cells[i * size + (size - 1 - i)].isChecked
            }
            if diag2Checked {
                won = true
                lineType = "Diagonale komplett!"
            }
        }

        if won {
            if !game.isBingoAchieved {
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
        } else {
            if game.isBingoAchieved {
                game.isBingoAchieved = false
                game.completedAt = nil
                try? context.save()
                self.showWinAnimation = false
                self.winningLineType = nil
            }
        }
    }
}
