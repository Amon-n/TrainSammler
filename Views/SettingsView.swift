import SwiftUI
import SwiftData
import UniformTypeIdentifiers

@MainActor
public struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var spottings: [SpottedTrain]
    @Query(filter: #Predicate<BingoGame> { $0.isArchived }) private var archivedBingos: [BingoGame]

    @State private var showDeleteAllAlert = false
    @State private var showDeleteBingoAlert = false
    @State private var showAttributionSheet = false

    // Backup-Zustände
    @State private var backupDocument = BackupFileDocument()
    @State private var showingExporter = false
    @State private var showingImporter = false
    @State private var backupStatusTitle = ""
    @State private var backupStatusMessage: String?

    public init() {}

    private var defaultBackupFilename: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return "TrainSammler-Backup-\(formatter.string(from: Date()))"
    }

    public var body: some View {
        NavigationStack {
            List {
                // 1. App Info Header
                Section {
                    HStack(spacing: 16) {
                        Image(systemName: "tram.fill")
                            .font(.system(size: 34))
                            .foregroundColor(.white)
                            .frame(width: 64, height: 64)
                            .background(
                                LinearGradient(
                                    colors: [Color.orange, Color.red],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .shadow(color: Color.red.opacity(0.3), radius: 8, y: 4)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("TrainSammler")
                                .font(.title3.weight(.bold))

                            Text(appVersionString)
                                .font(.caption)
                                .foregroundStyle(.secondary)

                            Text("Offenes Trainspotting für iOS")
                                .font(.caption2.weight(.medium))
                                .foregroundStyle(Color.accentColor)
                        }
                    }
                    .padding(.vertical, 4)
                }

                // 2. Datenschutz & Privatsphäre (DSGVO / GDPR)
                Section(header: Text("Datenschutz & Privatsphäre")) {
                    HStack(spacing: 12) {
                        Image(systemName: "hand.raised.fill")
                            .foregroundColor(.green)
                            .frame(width: 24)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("100% Offline & Privat")
                                .font(.subheadline.weight(.semibold))
                            Text("Alle Fotos, GPS-Bahnhofsstamps und Sichtungsdaten verbleiben ausschließlich lokal auf deinem Gerät.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 4)

                    HStack(spacing: 12) {
                        Image(systemName: "network.slash")
                            .foregroundColor(.blue)
                            .frame(width: 24)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Kein Tracking & keine Accounts")
                                .font(.subheadline.weight(.semibold))
                            Text("Keine Analyse-Tools, keine Werbetracker, keine Registrierung.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }

                // 3. Open Source & Community
                Section(header: Text("Open Source & Lizenzen")) {
                    Link(destination: URL(string: "https://github.com/Amon-n/TrainSammler")!) {
                        HStack {
                            Image(systemName: "chevron.left.forwardslash.chevron.right")
                                .foregroundColor(.primary)
                                .frame(width: 24)
                            Text("Quellcode auf GitHub")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "arrow.up.right")
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                        }
                    }

                    Button {
                        showAttributionSheet = true
                    } label: {
                        HStack {
                            Image(systemName: "photo.stack")
                                .foregroundColor(.orange)
                                .frame(width: 24)
                            Text("Bildnachweise (Wikimedia Commons)")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                        }
                    }

                    HStack {
                        Image(systemName: "doc.plaintext")
                            .foregroundColor(.secondary)
                            .frame(width: 24)
                        Text("Lizenz: MIT License")
                            .font(.subheadline)
                        Spacer()
                    }
                }

                // 4. Lokales Backup & Wiederherstellung
                Section(
                    header: Text("Lokales Backup"),
                    footer: Text("Exportiert deine Sichtungen (inkl. Fotos) und gespeicherten Bingo-Fahrten als lokale JSON-Datei in die Dateien-App – komplett ohne Cloud-Konto.")
                ) {
                    Button {
                        exportBackup()
                    } label: {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(.accentColor)
                                .frame(width: 24)
                            Text("Backup exportieren (.json)")
                                .font(.subheadline)
                                .foregroundStyle(.primary)
                        }
                    }
                    .disabled(spottings.isEmpty && archivedBingos.isEmpty)
                    .fileExporter(
                        isPresented: $showingExporter,
                        document: backupDocument,
                        contentType: .json,
                        defaultFilename: defaultBackupFilename
                    ) { result in
                        switch result {
                        case .success:
                            backupStatusTitle = "Backup exportiert"
                            backupStatusMessage = "\(spottings.count) Sichtungen und \(archivedBingos.count) Bingo-Fahrten wurden lokal gesichert."
                        case .failure(let error):
                            backupStatusTitle = "Export fehlgeschlagen"
                            backupStatusMessage = error.localizedDescription
                        }
                    }

                    Button {
                        showingImporter = true
                    } label: {
                        HStack {
                            Image(systemName: "square.and.arrow.down")
                                .foregroundColor(.accentColor)
                                .frame(width: 24)
                            Text("Backup importieren…")
                                .font(.subheadline)
                                .foregroundStyle(.primary)
                        }
                    }
                    .fileImporter(
                        isPresented: $showingImporter,
                        allowedContentTypes: [.json]
                    ) { result in
                        handleImportResult(result)
                    }
                }

                // 5. Datenverwaltung
                Section(header: Text("Datenverwaltung")) {
                    Button(role: .destructive) {
                        showDeleteAllAlert = true
                    } label: {
                        HStack {
                            Image(systemName: "trash")
                            Text("Alle Zugsichtungen löschen (\(spottings.count))")
                        }
                        .font(.subheadline)
                    }
                    .disabled(spottings.isEmpty)

                    Button(role: .destructive) {
                        showDeleteBingoAlert = true
                    } label: {
                        HStack {
                            Image(systemName: "checkerboard.rectangle")
                            Text("Bingo-Logbuch leeren (\(archivedBingos.count))")
                        }
                        .font(.subheadline)
                    }
                    .disabled(archivedBingos.isEmpty)
                }

                // 6. Footer / Credits
                Section {
                    VStack(alignment: .center, spacing: 6) {
                        Text("Entwickelt mit ❤️ für alle Bahn-Fans.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text("Nicht offiziell mit der Deutschen Bahn AG verbunden.")
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
                }
                .listRowBackground(Color.clear)
            }
            .navigationTitle("Einstellungen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Fertig") { dismiss() }
                }
            }
            .alert("Alle Sichtungen löschen?", isPresented: $showDeleteAllAlert) {
                Button("Abbrechen", role: .cancel) {}
                Button("Löschen", role: .destructive) {
                    deleteAllSpottings()
                }
            } message: {
                Text("Bist du sicher? Alle deine gesammelten Zugsichtungen und Fotos werden unwiderruflich gelöscht.")
            }
            .alert("Bingo-Logbuch leeren?", isPresented: $showDeleteBingoAlert) {
                Button("Abbrechen", role: .cancel) {}
                Button("Löschen", role: .destructive) {
                    deleteAllArchivedBingos()
                }
            } message: {
                Text("Möchtest du alle gespeicherten DB-Bingo-Fahrten aus dem Logbuch löschen?")
            }
            .alert(backupStatusTitle, isPresented: Binding(
                get: { backupStatusMessage != nil },
                set: { if !$0 { backupStatusMessage = nil } }
            )) {
                Button("OK") { backupStatusMessage = nil }
            } message: {
                Text(backupStatusMessage ?? "")
            }
            .sheet(isPresented: $showAttributionSheet) {
                AttributionSheetView()
            }
        }
    }

    private var appVersionString: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.9"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "Version \(version) (Build \(build))"
    }

    private func exportBackup() {
        do {
            let data = try BackupService.createBackupData(spottings: spottings, archivedBingos: archivedBingos)
            backupDocument = BackupFileDocument(data: data)
            showingExporter = true
        } catch {
            backupStatusTitle = "Export fehlgeschlagen"
            backupStatusMessage = error.localizedDescription
        }
    }

    private func handleImportResult(_ result: Result<URL, Error>) {
        switch result {
        case .success(let url):
            let accessing = url.startAccessingSecurityScopedResource()
            defer {
                if accessing {
                    url.stopAccessingSecurityScopedResource()
                }
            }
            do {
                let data = try Data(contentsOf: url)
                let summary = try BackupService.importBackup(from: data, context: modelContext)
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
                backupStatusTitle = "Backup importiert"
                backupStatusMessage = "\(summary.importedSpottings) neue Sichtungen und \(summary.importedBingos) Bingo-Fahrten wiederhergestellt (Duplikate übersprungen)."
            } catch {
                backupStatusTitle = "Import fehlgeschlagen"
                backupStatusMessage = "Die ausgewählte Datei konnte nicht eingelesen werden: \(error.localizedDescription)"
            }
        case .failure(let error):
            backupStatusTitle = "Import fehlgeschlagen"
            backupStatusMessage = error.localizedDescription
        }
    }

    private func deleteAllSpottings() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
        for spot in spottings {
            ImageCompressor.invalidateThumbnail(id: spot.id)
            modelContext.delete(spot)
        }
        try? modelContext.save()
    }

    private func deleteAllArchivedBingos() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
        for game in archivedBingos {
            modelContext.delete(game)
        }
        try? modelContext.save()
    }
}

// MARK: - Bildnachweise (Dynamisch aus TrainModel.photoCatalog)
private struct TrainImageAttribution: Identifiable {
    let id: String
    let category: String
    let train: String
    let perspective: String
    let author: String
    let license: String
    let commonsUrl: String?
}

struct AttributionSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \TrainModel.seriesCode) private var trains: [TrainModel]
    @State private var searchText = ""

    private var attributions: [TrainImageAttribution] {
        var entries: [TrainImageAttribution] = []
        var seen = Set<String>()

        for train in trains {
            let categoryTitle = train.category.rawValue
            let trainTitle = "\(train.commercialName) (\(train.seriesCode))"
            for photo in train.galleryPhotos {
                let uniqueKey = "\(train.seriesCode)_\(photo.assetName)"
                guard !seen.contains(uniqueKey) else { continue }
                seen.insert(uniqueKey)

                entries.append(
                    TrainImageAttribution(
                        id: uniqueKey,
                        category: categoryTitle,
                        train: trainTitle,
                        perspective: photo.label,
                        author: photo.photographer,
                        license: photo.license,
                        commonsUrl: photo.commonsUrl
                    )
                )
            }
        }

        if entries.isEmpty {
            for photo in TrainModel.photoCatalog.values.sorted(by: { $0.assetName < $1.assetName }) {
                entries.append(
                    TrainImageAttribution(
                        id: photo.assetName,
                        category: "Gesamtkatalog",
                        train: photo.label,
                        perspective: photo.characteristicDescription,
                        author: photo.photographer,
                        license: photo.license,
                        commonsUrl: photo.commonsUrl
                    )
                )
            }
        }

        return entries
    }

    private var filteredAttributions: [TrainImageAttribution] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return attributions }
        return attributions.filter {
            $0.train.localizedCaseInsensitiveContains(query) ||
            $0.perspective.localizedCaseInsensitiveContains(query) ||
            $0.author.localizedCaseInsensitiveContains(query) ||
            $0.category.localizedCaseInsensitiveContains(query)
        }
    }

    private var groupedAttributions: [String: [TrainImageAttribution]] {
        Dictionary(grouping: filteredAttributions, by: \.category)
    }

    private var orderedCategories: [String] {
        let preferred = [
            TrainCategory.special.rawValue,
            TrainCategory.highSpeed.rawValue,
            TrainCategory.regional.rawValue,
            "Gesamtkatalog"
        ]
        return preferred.filter { (groupedAttributions[$0]?.isEmpty == false) }
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 8) {
                            Image(systemName: "info.circle.fill")
                                .foregroundColor(Color.accentColor)
                            Text("Open-Content Bildnachweise")
                                .font(.subheadline.weight(.semibold))
                        }
                        Text("Alle Modell- und Galeriebilder stammen aus Wikimedia Commons und stehen unter freien Creative-Commons-Lizenzen (CC BY / CC BY-SA / CC0). Sie werden in Übereinstimmung mit den jeweiligen Lizenzbestimmungen und Urheberangaben genutzt.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }

                ForEach(orderedCategories, id: \.self) { cat in
                    if let items = groupedAttributions[cat], !items.isEmpty {
                        Section(header: Text(cat)) {
                            ForEach(items) { item in
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(item.train)
                                        .font(.subheadline.weight(.semibold))

                                    HStack {
                                        Text(item.perspective)
                                            .font(.caption2)
                                            .foregroundStyle(.secondary)
                                        Spacer()
                                        Text(item.license)
                                            .font(.caption2.weight(.bold))
                                            .foregroundStyle(Color.accentColor)
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 2)
                                            .background(Color.accentColor.opacity(0.12))
                                            .clipShape(Capsule())
                                    }

                                    HStack {
                                        Text("Foto: \(item.author)")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                        Spacer()
                                        if let urlStr = item.commonsUrl, let url = URL(string: urlStr) {
                                            Link(destination: url) {
                                                Image(systemName: "arrow.up.right.square")
                                                    .font(.caption)
                                                    .foregroundStyle(Color.accentColor)
                                            }
                                        }
                                    }
                                }
                                .padding(.vertical, 3)
                            }
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Zug, Baureihe oder Fotograf suchen...")
            .navigationTitle("Bildnachweise (\(attributions.count))")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Fertig") { dismiss() }
                }
            }
        }
    }
}
