import SwiftUI
import SwiftData
import MapKit

@MainActor
public struct SpottedHistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \SpottedTrain.spottedAt, order: .reverse) private var spottings: [SpottedTrain]
    @Query(
        filter: #Predicate<BingoGame> { $0.isArchived },
        sort: \BingoGame.startedAt,
        order: .reverse
    ) private var pastBingoGames: [BingoGame]
    
    @Binding private var selectedSection: LogbookSection
    @State private var viewMode: SpottingViewMode = .list
    @State private var inspectedTrain: TrainModel?
    @State private var inspectedBingoGame: BingoGame?
    @State private var selectedPhotoSpot: SpottedTrain?
    @State private var searchText: String = ""
    
    private var filteredSpottings: [SpottedTrain] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !query.isEmpty else { return spottings }
        return spottings.filter { spot in
            (spot.trainModel?.seriesCode.lowercased().contains(query) ?? false) ||
            (spot.trainModel?.commercialName.lowercased().contains(query) ?? false) ||
            (spot.stationOrLocationName?.lowercased().contains(query) ?? false) ||
            (spot.tzNumber?.lowercased().contains(query) ?? false) ||
            (spot.notes?.lowercased().contains(query) ?? false)
        }
    }
    
    public enum LogbookSection: String, CaseIterable, Identifiable {
        case spottings = "Sichtungen"
        case bingo = "DB-Bingo"
        
        public var id: String { rawValue }
    }
    
    public enum SpottingViewMode: String, CaseIterable {
        case list = "Liste"
        case map = "Karte"
    }
    
    public init(selectedSection: Binding<LogbookSection>? = nil) {
        if let binding = selectedSection {
            self._selectedSection = binding
        } else {
            self._selectedSection = .constant(.spottings)
        }
    }
    
    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Haupt-Segmented Picker: Sichtungen vs. DB-Bingo
                Picker("Bereich", selection: $selectedSection) {
                    Text("Zugsichtungen (\(spottings.count))").tag(LogbookSection.spottings)
                    Text("DB-Bingo (\(pastBingoGames.count))").tag(LogbookSection.bingo)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color(uiColor: .systemGroupedBackground))
                
                // Inhalt je nach gewähltem Bereich
                Group {
                    if selectedSection == .spottings {
                        spottingsSection
                    } else {
                        bingoHistorySection
                    }
                }
            }
            .navigationTitle("Logbuch")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(
                text: $searchText,
                prompt: "Nach Baureihe, Ort oder Tz suchen..."
            )
            .background(Color(uiColor: .systemGroupedBackground))
            .sheet(item: $inspectedTrain) { train in
                TrainDetailView(train: train)
            }
            .sheet(item: $inspectedBingoGame) { game in
                BingoArchiveDetailSheet(game: game)
            }
            .sheet(item: $selectedPhotoSpot) { spot in
                PhotoPreviewSheet(spot: spot)
            }
        }
    }
    
    // MARK: - Zugsichtungen Sektion
    private var spottingsSection: some View {
        Group {
            if spottings.isEmpty {
                ContentUnavailableView(
                    "Noch keine Sichtungen",
                    systemImage: "tram",
                    description: Text("Nutze die Schnell-Sichtung am Bahnsteig, um deinen ersten Zug zu erfassen!")
                )
            } else if filteredSpottings.isEmpty {
                ContentUnavailableView.search(text: searchText)
            } else {
                VStack(spacing: 0) {
                    Picker("Ansicht", selection: $viewMode) {
                        ForEach(SpottingViewMode.allCases, id: \.self) { mode in
                            Text(mode.rawValue).tag(mode)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)
                    
                    if viewMode == .list {
                        List {
                            ForEach(filteredSpottings) { spot in
                                Button {
                                    if let model = spot.trainModel {
                                        inspectedTrain = model
                                    }
                                } label: {
                                    SpottingRow(spot: spot, onPhotoTap: {
                                        selectedPhotoSpot = spot
                                    })
                                }
                                .tint(.primary)
                            }
                            .onDelete(perform: deleteSpotting)
                        }
                        .listStyle(.insetGrouped)
                    } else {
                        Map {
                            ForEach(filteredSpottings) { spot in
                                if let coord = spot.coordinate {
                                    Annotation(
                                        spot.trainModel?.seriesCode ?? "Zug",
                                        coordinate: coord
                                    ) {
                                        Image(systemName: "tram.fill")
                                            .padding(6)
                                            .background(spot.trainModel?.rarity.color ?? .accentColor)
                                            .foregroundColor(.white)
                                            .clipShape(Circle())
                                            .shadow(radius: 4)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - DB-Bingo Logbuch Sektion
    private var bingoHistorySection: some View {
        Group {
            if pastBingoGames.isEmpty {
                ContentUnavailableView(
                    "Keine Bingo-Runden archiviert",
                    systemImage: "checkerboard.rectangle",
                    description: Text("Sobald du ein Bingo-Spiel im DB-Bingo abschließt oder ein neues startest, wird deine bisherige Fahrt hier im Logbuch archiviert.")
                )
            } else {
                List {
                    Section {
                        HStack(spacing: 12) {
                            BingoStatPill(
                                title: "Fahrten",
                                value: "\(pastBingoGames.count)",
                                icon: "flag.checkered",
                                color: .blue
                            )
                            BingoStatPill(
                                title: "Bingos",
                                value: "\(pastBingoGames.filter(\.isBingoAchieved).count)",
                                icon: "trophy.fill",
                                color: .yellow
                            )
                            BingoStatPill(
                                title: "Vorfälle",
                                value: "\(pastBingoGames.reduce(0) { $0 + $1.cells.filter(\.isChecked).count })",
                                icon: "exclamationmark.triangle.fill",
                                color: .orange
                            )
                        }
                        .padding(.vertical, 4)
                    }
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    
                    Section(header: Text("Archivierte Fahrten (\(pastBingoGames.count))")) {
                        ForEach(pastBingoGames) { game in
                            Button {
                                inspectedBingoGame = game
                            } label: {
                                BingoHistoryRow(game: game)
                            }
                            .tint(.primary)
                        }
                        .onDelete(perform: deleteBingoGames)
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
    }
    
    private func deleteSpotting(at offsets: IndexSet) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        for index in offsets {
            let spot = filteredSpottings[index]
            modelContext.delete(spot)
        }
        try? modelContext.save()
    }
    
    private func deleteBingoGames(at offsets: IndexSet) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        for index in offsets {
            let game = pastBingoGames[index]
            modelContext.delete(game)
        }
        try? modelContext.save()
    }
}

public struct SpottingRow: View {
    public let spot: SpottedTrain
    public var onPhotoTap: (() -> Void)? = nil
    
    public init(spot: SpottedTrain, onPhotoTap: (() -> Void)? = nil) {
        self.spot = spot
        self.onPhotoTap = onPhotoTap
    }
    
    public var body: some View {
        HStack(spacing: 14) {
            if let photoData = spot.photoData, let uiImage = UIImage(data: photoData) {
                Button {
                    onPhotoTap?()
                } label: {
                    ZStack(alignment: .bottomTrailing) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 54, height: 54)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        
                        Image(systemName: "arrow.up.left.and.down.right.magnifyingglass")
                            .font(.system(size: 8, weight: .bold))
                            .foregroundColor(.white)
                            .padding(3)
                            .background(Color.black.opacity(0.65))
                            .clipShape(Circle())
                            .padding(2)
                    }
                }
                .buttonStyle(.borderless)
            } else {
                TrainImageView(assetName: spot.trainModel?.assetName ?? "tram.fill")
                    .frame(width: 58, height: 58)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
            
            VStack(alignment: .leading, spacing: 3) {
                HStack {
                    Text(spot.trainModel?.seriesCode ?? "Unbekannt")
                        .font(.headline)
                    Spacer()
                    if let rarity = spot.trainModel?.rarity {
                        RarityBadgeView(rarity: rarity, style: .minimal)
                    }
                }
                
                if let tz = spot.tzNumber {
                    Text("Tz: \(tz)")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.secondary)
                }
                
                HStack(spacing: 8) {
                    if let location = spot.stationOrLocationName {
                        Label(location, systemImage: "location")
                            .lineLimit(1)
                    }
                    Spacer()
                    Text(spot.spottedAt.formatted(date: .abbreviated, time: .shortened))
                }
                .font(.caption2)
                .foregroundStyle(.tertiary)
            }
        }
        .padding(.vertical, 4)
    }
}
