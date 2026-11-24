import SwiftUI
import SwiftData
import MapKit
import PhotosUI

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
    @State private var editingSpot: SpottedTrain?
    @State private var selectedMapSpot: SpottedTrain?
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

    private var filteredBingoGames: [BingoGame] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !query.isEmpty else { return pastBingoGames }
        return pastBingoGames.filter { game in
            (game.travelTitle?.lowercased().contains(query) ?? false) ||
            game.startedAt.formatted(date: .abbreviated, time: .omitted).lowercased().contains(query) ||
            game.cells.contains { $0.isChecked && !$0.isJoker && $0.text.lowercased().contains(query) }
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
                prompt: selectedSection == .spottings
                    ? "Nach Baureihe, Ort, Tz oder Notiz suchen..."
                    : "Nach Reise oder Vorfall suchen..."
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
            .sheet(item: $editingSpot) { spot in
                EditSpottingSheet(spot: spot)
            }
            .sheet(item: $selectedMapSpot) { spot in
                MapSpotDetailSheet(
                    spot: spot,
                    onEdit: {
                        selectedMapSpot = nil
                        editingSpot = spot
                    },
                    onOpenCatalog: {
                        selectedMapSpot = nil
                        if let model = spot.trainModel {
                            inspectedTrain = model
                        }
                    },
                    onPreviewPhoto: {
                        selectedMapSpot = nil
                        selectedPhotoSpot = spot
                    }
                )
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
                                    } else {
                                        editingSpot = spot
                                    }
                                } label: {
                                    SpottingRow(spot: spot, onPhotoTap: {
                                        selectedPhotoSpot = spot
                                    })
                                }
                                .tint(.primary)
                                .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                    Button {
                                        editingSpot = spot
                                    } label: {
                                        Label("Bearbeiten", systemImage: "pencil")
                                    }
                                    .tint(.blue)
                                }
                                .contextMenu {
                                    Button {
                                        editingSpot = spot
                                    } label: {
                                        Label("Sichtung bearbeiten", systemImage: "pencil")
                                    }

                                    if let model = spot.trainModel {
                                        Button {
                                            inspectedTrain = model
                                        } label: {
                                            Label("Im Train-Dex öffnen", systemImage: "tram.fill")
                                        }
                                    }

                                    if let cardImage = ShareCardRenderer.renderSpottingCard(spot: spot) {
                                        ShareLink(
                                            item: cardImage,
                                            subject: Text("\(spot.trainModel?.seriesCode ?? "Zug") gespottet!"),
                                            preview: SharePreview(spot.trainModel?.seriesCode ?? "Zugsichtung", image: Image(uiImage: cardImage.uiImage))
                                        ) {
                                            Label("Als Bild-Karte teilen", systemImage: "square.and.arrow.up")
                                        }
                                    }

                                    Divider()

                                    Button(role: .destructive) {
                                        deleteSingleSpotting(spot)
                                    } label: {
                                        Label("Löschen", systemImage: "trash")
                                    }
                                }
                            }
                            .onDelete(perform: deleteSpotting)
                        }
                        .listStyle(.insetGrouped)
                    } else {
                        let spotsWithCoords = filteredSpottings.filter { $0.coordinate != nil }

                        ZStack(alignment: .topTrailing) {
                            Map(initialPosition: initialCameraPosition(for: spotsWithCoords)) {
                                ForEach(spotsWithCoords) { spot in
                                    if let coord = spot.coordinate {
                                        Annotation(
                                            spot.trainModel?.seriesCode ?? "Zug",
                                            coordinate: coord
                                        ) {
                                            Button {
                                                let impact = UIImpactFeedbackGenerator(style: .light)
                                                impact.impactOccurred()
                                                selectedMapSpot = spot
                                            } label: {
                                                Image(systemName: "tram.fill")
                                                    .font(.caption.weight(.bold))
                                                    .padding(7)
                                                    .background(spot.trainModel?.rarity.color ?? .accentColor)
                                                    .foregroundColor(.white)
                                                    .clipShape(Circle())
                                                    .overlay(
                                                        Circle()
                                                            .strokeBorder(.white, lineWidth: 2)
                                                    )
                                                    .shadow(color: .black.opacity(0.25), radius: 4, y: 2)
                                            }
                                            .buttonStyle(.plain)
                                        }
                                    }
                                }
                            }

                            Text(spotsWithCoords.isEmpty
                                 ? "Keine GPS-Koordinaten vorhanden"
                                 : "\(spotsWithCoords.count) Sichtungen auf Karte")
                                .font(.caption2.weight(.semibold))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(.regularMaterial, in: Capsule())
                                .padding(12)
                        }
                    }
                }
            }
        }
    }

    private func initialCameraPosition(for spots: [SpottedTrain]) -> MapCameraPosition {
        let coords = spots.compactMap(\.coordinate)
        guard !coords.isEmpty else {
            // Deutschland-Zentrum
            return .region(
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: 51.1657, longitude: 10.4515),
                    span: MKCoordinateSpan(latitudeDelta: 6.5, longitudeDelta: 6.5)
                )
            )
        }

        let lats = coords.map(\.latitude)
        let lons = coords.map(\.longitude)
        let minLat = lats.min() ?? 51.1657
        let maxLat = lats.max() ?? 51.1657
        let minLon = lons.min() ?? 10.4515
        let maxLon = lons.max() ?? 10.4515

        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2.0,
            longitude: (minLon + maxLon) / 2.0
        )
        let span = MKCoordinateSpan(
            latitudeDelta: max(0.15, (maxLat - minLat) * 1.4),
            longitudeDelta: max(0.15, (maxLon - minLon) * 1.4)
        )
        return .region(MKCoordinateRegion(center: center, span: span))
    }

    // MARK: - DB-Bingo Logbuch Sektion
    private var bingoHistorySection: some View {
        Group {
            if pastBingoGames.isEmpty {
                ContentUnavailableView(
                    "Keine Bingo-Runden archiviert",
                    systemImage: "checkerboard.rectangle",
                    description: Text("Sobald du eine Fahrt im DB-Bingo über „Fahrt im Logbuch speichern“ sicherst, erscheint sie hier dauerhaft.")
                )
            } else if filteredBingoGames.isEmpty {
                ContentUnavailableView.search(text: searchText)
            } else {
                BingoLogbookContentView(
                    allGames: pastBingoGames,
                    filteredGames: filteredBingoGames,
                    onInspect: { game in
                        inspectedBingoGame = game
                    },
                    onDelete: deleteBingoGames
                )
            }
        }
    }

    private func deleteSingleSpotting(_ spot: SpottedTrain) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        ImageCompressor.invalidateThumbnail(id: spot.id)
        modelContext.delete(spot)
        try? modelContext.save()
    }

    private func deleteSpotting(at offsets: IndexSet) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        for index in offsets {
            let spot = filteredSpottings[index]
            ImageCompressor.invalidateThumbnail(id: spot.id)
            modelContext.delete(spot)
        }
        try? modelContext.save()
    }

    private func deleteBingoGames(at offsets: IndexSet) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        for index in offsets {
            let game = filteredBingoGames[index]
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
            if let photoData = spot.photoData,
               let uiImage = ImageCompressor.thumbnail(id: spot.id, data: photoData, maxPixelSize: 180) {
                Button {
                    onPhotoTap?()
                } label: {
                    ZStack(alignment: .bottomTrailing) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 58, height: 58)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

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

                if let tz = spot.tzNumber, !tz.isEmpty {
                    Text("Tz: \(tz)")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.secondary)
                }

                if let notes = spot.notes, !notes.isEmpty {
                    Text(notes)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
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

// MARK: - Sheet: Bestehende Sichtung bearbeiten
@MainActor
public struct EditSpottingSheet: View {
    public let spot: SpottedTrain

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \TrainModel.seriesCode) private var allTrains: [TrainModel]

    @State private var selectedTrain: TrainModel?
    @State private var stationInput: String
    @State private var tzInput: String
    @State private var notesInput: String
    @State private var spottedDate: Date
    @State private var photoData: Data?
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var showingCamera = false
    @State private var showCameraUnavailableAlert = false

    public init(spot: SpottedTrain) {
        self.spot = spot
        self._selectedTrain = State(initialValue: spot.trainModel)
        self._stationInput = State(initialValue: spot.stationOrLocationName ?? "")
        self._tzInput = State(initialValue: spot.tzNumber ?? "")
        self._notesInput = State(initialValue: spot.notes ?? "")
        self._spottedDate = State(initialValue: spot.spottedAt)
        self._photoData = State(initialValue: spot.photoData)
    }

    public var body: some View {
        NavigationStack {
            Form {
                Section("Zug-Baureihe") {
                    Picker("Baureihe", selection: $selectedTrain) {
                        ForEach(allTrains) { train in
                            Text("\(train.seriesCode) · \(train.commercialName)")
                                .tag(Optional(train))
                        }
                    }
                }

                Section("Ort & Zeitpunkt") {
                    TextField("Bahnhof / Ort (z. B. Köln Hbf)", text: $stationInput)

                    DatePicker(
                        "Zeitpunkt",
                        selection: $spottedDate,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                }

                Section("Details") {
                    TextField("Triebzug-Nummer (z. B. 8012)", text: $tzInput)
                        .keyboardType(.numbersAndPunctuation)

                    TextField("Notiz (Gleis, Verspätung, Fahrtziel)", text: $notesInput, axis: .vertical)
                        .lineLimit(2...4)
                }

                Section("Beweisfoto") {
                    if let data = photoData,
                       let uiImage = UIImage(data: data) {
                        ZStack(alignment: .topTrailing) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity)
                                .frame(height: 170)
                                .clipped()
                                .clipShape(RoundedRectangle(cornerRadius: 12))

                            Button {
                                photoData = nil
                                selectedPhotoItem = nil
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.title2)
                                    .foregroundStyle(.white, .black.opacity(0.6))
                                    .padding(8)
                            }
                        }
                    } else {
                        Button {
                            if CameraPickerView.isCameraAvailable {
                                showingCamera = true
                            } else {
                                showCameraUnavailableAlert = true
                            }
                        } label: {
                            Label("Kamera aufnehmen", systemImage: "camera.fill")
                        }

                        PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                            Label("Foto aus Mediathek wählen", systemImage: "photo.on.rectangle")
                        }
                        .onChange(of: selectedPhotoItem) { _, newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                    let compressed = ImageCompressor.compress(imageData: data) ?? data
                                    await MainActor.run {
                                        photoData = compressed
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .scrollDismissesKeyboard(.interactively)
            .fullScreenCover(isPresented: $showingCamera) {
                CameraPickerView { compressedData in
                    photoData = compressedData
                }
                .ignoresSafeArea()
            }
            .alert("Kamera nicht verfügbar", isPresented: $showCameraUnavailableAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Auf diesem Gerät steht aktuell keine Live-Kamera zur Verfügung.")
            }
            .navigationTitle("Sichtung bearbeiten")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Speichern") {
                        saveChanges()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }

    private func saveChanges() {
        let trimmedStation = stationInput.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedTz = tzInput.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedNotes = notesInput.trimmingCharacters(in: .whitespacesAndNewlines)

        spot.trainModel = selectedTrain
        spot.stationOrLocationName = trimmedStation.isEmpty ? nil : trimmedStation
        spot.tzNumber = trimmedTz.isEmpty ? nil : trimmedTz
        spot.notes = trimmedNotes.isEmpty ? nil : trimmedNotes
        spot.spottedAt = spottedDate
        spot.photoData = photoData

        ImageCompressor.invalidateThumbnail(id: spot.id)
        try? modelContext.save()

        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        dismiss()
    }
}

// MARK: - Sheet: Karten-Pin Detailvorschau
private struct MapSpotDetailSheet: View {
    let spot: SpottedTrain
    let onEdit: () -> Void
    let onOpenCatalog: () -> Void
    let onPreviewPhoto: () -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 14) {
                HStack(spacing: 14) {
                    if let photoData = spot.photoData,
                       let uiImg = ImageCompressor.thumbnail(id: spot.id, data: photoData, maxPixelSize: 220) {
                        Button(action: onPreviewPhoto) {
                            Image(uiImage: uiImg)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 78, height: 60)
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        }
                        .buttonStyle(.plain)
                    } else {
                        TrainImageView(assetName: spot.trainModel?.assetName ?? "tram.fill")
                            .frame(width: 78, height: 60)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(spot.trainModel?.seriesCode ?? "Zugsichtung")
                                .font(.headline.weight(.bold))
                            Spacer()
                            if let rarity = spot.trainModel?.rarity {
                                RarityBadgeView(rarity: rarity, style: .minimal)
                            }
                        }

                        if let name = spot.trainModel?.commercialName {
                            Text(name)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }

                        if let tz = spot.tzNumber, !tz.isEmpty {
                            Text("Tz \(tz)")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(Color.accentColor)
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 4) {
                    if let location = spot.stationOrLocationName {
                        Label(location, systemImage: "location.fill")
                            .font(.caption.weight(.medium))
                            .foregroundStyle(.secondary)
                    }
                    Label(spot.spottedAt.formatted(date: .abbreviated, time: .shortened), systemImage: "clock")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                    if let notes = spot.notes, !notes.isEmpty {
                        Text(notes)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .padding(.top, 2)
                    }
                }

                HStack(spacing: 10) {
                    Button(action: onEdit) {
                        Label("Bearbeiten", systemImage: "pencil")
                            .font(.subheadline.weight(.semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 11)
                            .background(Color(uiColor: .secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                    .buttonStyle(.plain)

                    if spot.trainModel != nil {
                        Button(action: onOpenCatalog) {
                            Label("Im Train-Dex", systemImage: "tram.fill")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 11)
                                .background(Color.accentColor, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(16)
            .background(Color(uiColor: .systemGroupedBackground))
            .navigationTitle("Sichtung auf Karte")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Schließen") { dismiss() }
                }
            }
        }
        .presentationDetents([.height(290), .medium])
    }
}
