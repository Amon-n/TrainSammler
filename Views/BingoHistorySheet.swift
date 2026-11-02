import SwiftUI
import SwiftData

struct BingoHistorySheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(
        filter: #Predicate<BingoGame> { $0.isArchived },
        sort: \BingoGame.startedAt,
        order: .reverse
    ) private var pastGames: [BingoGame]

    @State private var inspectedGame: BingoGame?

    var body: some View {
        NavigationStack {
            Group {
                if pastGames.isEmpty {
                    ContentUnavailableView(
                        "Keine beendeten Spiele",
                        systemImage: "checkerboard.rectangle",
                        description: Text("Sobald du eine Fahrt über „Reise beenden“ abschließt, wird dein Bingo-Blatt hier im Logbuch gespeichert.")
                    )
                } else {
                    List {
                        Section {
                            HStack(spacing: 12) {
                                BingoStatPill(
                                    title: "Fahrten",
                                    value: "\(pastGames.count)",
                                    icon: "flag.checkered",
                                    color: .blue
                                )
                                BingoStatPill(
                                    title: "Bingos",
                                    value: "\(pastGames.filter(\.isBingoAchieved).count)",
                                    icon: "trophy.fill",
                                    color: .yellow
                                )
                                BingoStatPill(
                                    title: "Vorfälle",
                                    value: "\(pastGames.reduce(0) { $0 + $1.checkedIncidentsCount })",
                                    icon: "checkmark.seal.fill",
                                    color: .green
                                )
                                BingoStatPill(
                                    title: "Bingo-XP",
                                    value: "\(pastGames.reduce(0) { $0 + $1.earnedXP })",
                                    icon: "bolt.fill",
                                    color: .orange
                                )
                            }
                            .padding(.vertical, 4)
                        }
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))

                        Section(header: Text("Gespeicherte Fahrten (\(pastGames.count))")) {
                            ForEach(pastGames) { game in
                                Button {
                                    inspectedGame = game
                                } label: {
                                    BingoHistoryRow(game: game)
                                }
                                .tint(.primary)
                            }
                            .onDelete(perform: deleteGames)
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Bingo-Logbuch 📜")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Fertig") { dismiss() }
                        .fontWeight(.semibold)
                }
            }
            .sheet(item: $inspectedGame) { game in
                BingoArchiveDetailSheet(game: game)
            }
        }
    }

    private func deleteGames(at offsets: IndexSet) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        for index in offsets {
            let game = pastGames[index]
            modelContext.delete(game)
        }
        try? modelContext.save()
    }
}

// MARK: - Mini Stat Pill
struct BingoStatPill: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.caption2)
                    .foregroundStyle(color)
                Text(value)
                    .font(.subheadline.weight(.bold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
            }
            Text(title)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .padding(.horizontal, 4)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

// MARK: - Row in List
struct BingoHistoryRow: View {
    let game: BingoGame

    private var checkedCount: Int {
        game.checkedIncidentsCount
    }

    private var totalNonJoker: Int {
        game.cells.filter { !$0.isJoker }.count
    }

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(game.isBingoAchieved ? Color.green.opacity(0.15) : Color.accentColor.opacity(0.1))
                    .frame(width: 44, height: 44)

                Image(systemName: game.isBingoAchieved ? "trophy.fill" : "checkerboard.rectangle")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(game.isBingoAchieved ? Color.green : Color.accentColor)
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(game.travelTitle ?? "Fahrt am \(game.startedAt.formatted(date: .abbreviated, time: .omitted))")
                        .font(.subheadline.weight(.semibold))
                        .lineLimit(1)

                    if game.isBingoAchieved {
                        Text("BINGO")
                            .font(.system(size: 9, weight: .heavy))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 1.5)
                            .background(Color.green)
                            .clipShape(Capsule())
                    }

                    Spacer()

                    if game.earnedXP > 0 {
                        Text("+\(game.earnedXP) XP")
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(Color.orange)
                    }
                }

                HStack(spacing: 6) {
                    Text("\(game.gridSize)×\(game.gridSize)")
                        .font(.caption2.weight(.bold))
                        .padding(.horizontal, 4)
                        .padding(.vertical, 1)
                        .background(Color.secondary.opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 4))

                    Text("•")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)

                    Text("\(checkedCount)/\(totalNonJoker) Vorfälle")
                        .font(.caption2)
                        .foregroundStyle(.secondary)

                    Text("•")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)

                    Text(game.startedAt.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }
            }

            Image(systemName: "chevron.right")
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Archiv Detail Sheet
struct BingoArchiveDetailSheet: View {
    let game: BingoGame
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Header Card
                    VStack(spacing: 8) {
                        HStack {
                            Text(game.travelTitle ?? "Archivierte Fahrt")
                                .font(.title3.weight(.bold))
                            Spacer()
                            if game.isBingoAchieved {
                                Label("BINGO!", systemImage: "trophy.fill")
                                    .font(.caption.weight(.heavy))
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.green)
                                    .clipShape(Capsule())
                            }
                        }

                        HStack {
                            Text("Start: \(game.startedAt.formatted(date: .abbreviated, time: .shortened))")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Spacer()
                            if let completedAt = game.completedAt {
                                Text("Beendet: \(completedAt.formatted(date: .omitted, time: .shortened))")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }

                        Divider()

                        HStack {
                            Label("\(game.checkedIncidentsCount) Vorfälle erlebt", systemImage: "checkmark.circle.fill")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.primary)
                            Spacer()
                            Text("+\(game.earnedXP) Bahn-XP")
                                .font(.caption.weight(.bold))
                                .foregroundStyle(.orange)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(Color.orange.opacity(0.14))
                                .clipShape(Capsule())
                        }
                    }
                    .padding(14)
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

                    // Das eingefrorene Raster
                    let size = game.gridSize
                    let columns = Array(repeating: GridItem(.flexible(), spacing: 6), count: size)

                    LazyVGrid(columns: columns, spacing: 6) {
                        ForEach(game.sortedCells) { cell in
                            ArchivedCellView(cell: cell, gridSize: size)
                        }
                    }
                    .padding(10)
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

                    // Eingetretene Vorfälle Liste
                    let checkedCells = game.sortedCells.filter { $0.isChecked && !$0.isJoker }
                    if !checkedCells.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Erlebte Vorfälle (\(checkedCells.count))")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.secondary)
                                .padding(.horizontal, 4)

                            VStack(spacing: 0) {
                                ForEach(checkedCells) { cell in
                                    HStack(spacing: 12) {
                                        Image(systemName: cell.iconName)
                                            .font(.body)
                                            .foregroundStyle(cell.rarity.badgeColor)
                                            .frame(width: 24)

                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(cell.text)
                                                .font(.subheadline)
                                            HStack(spacing: 6) {
                                                Text(cell.rarity.shortLabel)
                                                    .font(.system(size: 10, weight: .bold))
                                                    .foregroundStyle(cell.rarity.badgeColor)
                                                Text("• ca. \(cell.likelihoodPercent)% Chance")
                                                    .font(.caption2)
                                                    .foregroundStyle(.secondary)
                                            }
                                        }

                                        Spacer()

                                        Text("+\(cell.rarity.xpPoints) XP")
                                            .font(.caption2.weight(.bold))
                                            .foregroundStyle(.secondary)
                                    }
                                    .padding(12)
                                    if cell.id != checkedCells.last?.id {
                                        Divider().padding(.leading, 48)
                                    }
                                }
                            }
                            .background(Color(uiColor: .secondarySystemGroupedBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        }
                    }
                }
                .padding(16)
            }
            .background(Color(uiColor: .systemGroupedBackground))
            .navigationTitle("Fahrt-Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Schließen") { dismiss() }
                }
            }
        }
    }
}

struct ArchivedCellView: View {
    let cell: BingoCell
    let gridSize: Int

    private var cellHeight: CGFloat {
        switch gridSize {
        case 3: return 88
        case 4: return 72
        case 5: return 62
        default: return 72
        }
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 3) {
                Image(systemName: cell.iconName)
                    .font(.system(size: gridSize == 5 ? 12 : 14, weight: .medium))
                    .foregroundStyle(cell.isChecked ? .white : Color.accentColor.opacity(0.8))

                Text(cell.isJoker ? "FREIFELD" : cell.text)
                    .font(.system(size: gridSize == 5 ? 8.5 : (gridSize == 4 ? 9.5 : 11), weight: cell.isChecked ? .semibold : .medium))
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .minimumScaleFactor(0.6)
                    .allowsTightening(true)
                    .foregroundStyle(cell.isChecked ? .white : .primary)
            }
            .padding(.horizontal, 4)
            .padding(.vertical, 4)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .frame(height: cellHeight)

            if cell.isChecked && !cell.isJoker {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 8.5))
                    .foregroundStyle(.white.opacity(0.9))
                    .padding(4)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(
                    cell.isChecked
                        ? (cell.isJoker ? Color.orange : Color.accentColor)
                        : Color(uiColor: .systemBackground)
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .strokeBorder(cell.isChecked ? Color.clear : Color.primary.opacity(0.06), lineWidth: 1)
        )
    }
}
