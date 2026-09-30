import SwiftUI
import SwiftData

@MainActor
public struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var spottings: [SpottedTrain]
    
    @State private var showDeleteAllAlert = false
    @State private var showResetCatalogAlert = false
    @State private var showAttributionSheet = false
    
    public init() {}
    
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
                            Text("trainSammler")
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
                
                // 4. Datenverwaltung
                Section(header: Text("Datenverwaltung")) {
                    Button(role: .destructive) {
                        showDeleteAllAlert = true
                    } label: {
                        HStack {
                            Image(systemName: "trash")
                            Text("Alle Sichtungen löschen (\(spottings.count))")
                        }
                        .font(.subheadline)
                    }
                    .disabled(spottings.isEmpty)
                }
                
                // 5. Footer / Credits
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
                Text("Bist du sicher? Alle deine gesammelten Sichtungen, Fotos und XP werden unwiderruflich gelöscht.")
            }
            .sheet(isPresented: $showAttributionSheet) {
                AttributionSheetView()
            }
        }
    }
    
    private var appVersionString: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.1"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "Version \(version) (Build \(build))"
    }
    
    private func deleteAllSpottings() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
        for spot in spottings {
            modelContext.delete(spot)
        }
        try? modelContext.save()
    }
}

// MARK: - Bildnachweise Datenmodell & Modal
struct TrainImageAttribution: Identifiable, Sendable {
    let id = UUID()
    let category: String
    let train: String
    let perspective: String
    let author: String
    let license: String
}

struct AttributionSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    
    private let attributions: [TrainImageAttribution] = [
        // MARK: 1. Sonderzüge & Erprobung
        TrainImageAttribution(
            category: "Sonderzüge & Erprobung",
            train: "Regenbogen-ICE (BR 403 · Tz 304)",
            perspective: "Hauptansicht (Strecke)",
            author: "Johannes Maximilian (Wikimedia Commons)",
            license: "CC BY-SA 4.0"
        ),
        TrainImageAttribution(
            category: "Sonderzüge & Erprobung",
            train: "Europa-ICE (BR 406 · Tz 4601)",
            perspective: "Hauptansicht (Europa-Zierstreifen)",
            author: "LWChris (Wikimedia Commons)",
            license: "CC BY 4.0"
        ),
        TrainImageAttribution(
            category: "Sonderzüge & Erprobung",
            train: "ICE Bundesrepublik Deutschland (BR 412 · Tz 9457)",
            perspective: "Jubiläumsdesign (Schwarz-Rot-Gold)",
            author: "Geogast (Wikimedia Commons)",
            license: "CC BY 4.0"
        ),
        TrainImageAttribution(
            category: "Sonderzüge & Erprobung",
            train: "Female ICE (BR 412 · Tz 9015)",
            perspective: "Hauptansicht (Berlin Hbf)",
            author: "Peter Nath / R.M. (Wikimedia Commons)",
            license: "CC BY 4.0"
        ),
        TrainImageAttribution(
            category: "Sonderzüge & Erprobung",
            train: "ICE S (BR 410)",
            perspective: "Hochgeschwindigkeits-Messzug",
            author: "Bvcmz248.5 / DB Systemtechnik",
            license: "CC0 / Public Domain"
        ),
        TrainImageAttribution(
            category: "Sonderzüge & Erprobung",
            train: "advanced TrainLab (BR 605)",
            perspective: "Fahrendes Digitallabor",
            author: "Matti Blume (Wikimedia Commons)",
            license: "CC BY-SA 4.0"
        ),
        
        // MARK: 2. ICE-Flotte (Fernverkehr)
        TrainImageAttribution(
            category: "ICE-Flotte (Fernverkehr)",
            train: "ICE 1 (BR 401)",
            perspective: "Hauptansicht (Berlin Hbf)",
            author: "Matti Blume (Wikimedia Commons)",
            license: "CC BY-SA 4.0"
        ),
        TrainImageAttribution(
            category: "ICE-Flotte (Fernverkehr)",
            train: "ICE 1 (BR 401)",
            perspective: "Frontpartie & Triebkopf",
            author: "Gerhard Jacobs (Wikimedia Commons)",
            license: "CC BY-SA 3.0"
        ),
        TrainImageAttribution(
            category: "ICE-Flotte (Fernverkehr)",
            train: "ICE 2 (BR 402)",
            perspective: "Hauptansicht (Berlin Hbf)",
            author: "RAIL P (RAIL.PHOTOGRAPHY) / Matti Blume",
            license: "CC0 / CC BY-SA 4.0"
        ),
        TrainImageAttribution(
            category: "ICE-Flotte (Fernverkehr)",
            train: "ICE 2 (BR 402)",
            perspective: "Steuerwagen / Frontansicht",
            author: "L. Willms (Wikimedia Commons)",
            license: "CC BY 3.0"
        ),
        TrainImageAttribution(
            category: "ICE-Flotte (Fernverkehr)",
            train: "ICE 3 (BR 403 · 1./2. Bauserie)",
            perspective: "Frontansicht am Kölner Dom",
            author: "New York-air (Wikimedia Commons)",
            license: "CC BY-SA 4.0"
        ),
        TrainImageAttribution(
            category: "ICE-Flotte (Fernverkehr)",
            train: "ICE 3M (BR 406 Mehrsystem)",
            perspective: "Frontansicht & Mehrsystemausrüstung",
            author: "New York-air (Wikimedia Commons)",
            license: "CC BY-SA 4.0"
        ),
        TrainImageAttribution(
            category: "ICE-Flotte (Fernverkehr)",
            train: "ICE 3 (BR 407 · Velaro D)",
            perspective: "Triebkopf & aerodynamische Front",
            author: "Stephan Preißler (Wikimedia Commons)",
            license: "CC BY-SA 3.0"
        ),
        TrainImageAttribution(
            category: "ICE-Flotte (Fernverkehr)",
            train: "ICE 3neo (BR 408 · Velaro MS)",
            perspective: "Hauptansicht (Köln Messe/Deutz)",
            author: "TheFrog001 (Wikimedia Commons)",
            license: "CC0 / Public Domain"
        ),
        TrainImageAttribution(
            category: "ICE-Flotte (Fernverkehr)",
            train: "ICE 3neo (BR 408 · Velaro MS)",
            perspective: "Fahrgastraum & Innendesign",
            author: "Wikimedia Commons Contributors",
            license: "CC BY-SA 4.0"
        ),
        TrainImageAttribution(
            category: "ICE-Flotte (Fernverkehr)",
            train: "ICE-T (BR 411 · 7-teilig)",
            perspective: "Streckenfahrt (Maria Anzbach)",
            author: "Linie29 (Wikimedia Commons)",
            license: "CC BY-SA 4.0"
        ),
        TrainImageAttribution(
            category: "ICE-Flotte (Fernverkehr)",
            train: "ICE-T (BR 411 / 415)",
            perspective: "Frontpartie (Wien Westbahnhof)",
            author: "80686 (Wikimedia Commons)",
            license: "CC BY 3.0"
        ),
        TrainImageAttribution(
            category: "ICE-Flotte (Fernverkehr)",
            train: "ICE 4 (BR 412 · 7- bis 13-teilig)",
            perspective: "Bahnsteig Berlin Hbf",
            author: "Peter Nath / Reinhold Möller",
            license: "CC BY 4.0"
        ),
        TrainImageAttribution(
            category: "ICE-Flotte (Fernverkehr)",
            train: "ICE 4 (BR 412)",
            perspective: "Streckenfahrt bei Altengronau",
            author: "Joachim Seyferth (Wikimedia Commons)",
            license: "CC BY 4.0"
        ),
        TrainImageAttribution(
            category: "ICE-Flotte (Fernverkehr)",
            train: "ICE L (BR 105 · Talgo 230)",
            perspective: "Lokomotive 105 019 auf Gleisen",
            author: "Sven-IngCH (Wikimedia Commons)",
            license: "CC BY-SA 4.0"
        ),
        TrainImageAttribution(
            category: "ICE-Flotte (Fernverkehr)",
            train: "ICE L (BR 105 · Talgo 230)",
            perspective: "Wagenzug & stufenloser Einstieg",
            author: "Wikimedia Commons Contributors",
            license: "CC BY-SA 4.0"
        ),
        
        // MARK: 3. Intercity & Lokomotiven
        TrainImageAttribution(
            category: "Intercity & Lokomotiven",
            train: "Intercity 1 (BR 101)",
            perspective: "Hauptansicht Streckenlok",
            author: "Lars Steffens (Wikimedia Commons)",
            license: "CC BY-SA 2.0"
        ),
        TrainImageAttribution(
            category: "Intercity & Lokomotiven",
            train: "Intercity 1 (BR 101)",
            perspective: "Führerstand & Detailansicht",
            author: "Harald Knauer / Staatsarchiv",
            license: "CC BY 4.0"
        ),
        TrainImageAttribution(
            category: "Intercity & Lokomotiven",
            train: "Intercity 2 (BR 4110 · KISS)",
            perspective: "Doppelstock-Triebzug auf Strecke",
            author: "Mirkone (Wikimedia Commons)",
            license: "CC BY-SA 4.0"
        ),
        TrainImageAttribution(
            category: "Intercity & Lokomotiven",
            train: "Intercity 2 (BR 4110 · KISS)",
            perspective: "Innenraum Oberdeck",
            author: "Entbert (Wikimedia Commons)",
            license: "CC BY-SA 4.0"
        ),
        TrainImageAttribution(
            category: "Intercity & Lokomotiven",
            train: "Intercity 2 (BR 146.5 / 147.5 · Twindexx)",
            perspective: "Doppelstock-Wendezug",
            author: "UMO1 / Foobian (Wikimedia)",
            license: "CC BY-SA 4.0"
        ),
        TrainImageAttribution(
            category: "Intercity & Lokomotiven",
            train: "Intercity 2 (BR 146.5 / 147.5 · Twindexx)",
            perspective: "Innenraum 1. & 2. Klasse",
            author: "Geogast (Wikimedia Commons)",
            license: "CC BY 4.0"
        ),
        
        // MARK: 4. Regionalverkehr & S-Bahn
        TrainImageAttribution(
            category: "Regionalverkehr & S-Bahn",
            train: "Desiro HC (BR 462 · RRX)",
            perspective: "Hauptansicht Wuppertal Hbf",
            author: "Gsadfaw1223 (Wikimedia Commons)",
            license: "CC BY-SA 4.0"
        ),
        TrainImageAttribution(
            category: "Regionalverkehr & S-Bahn",
            train: "Desiro HC (BR 462 · RRX)",
            perspective: "Innenraum & Mehrzweckbereich",
            author: "Wikimedia Commons Contributors",
            license: "CC BY-SA 4.0"
        ),
        TrainImageAttribution(
            category: "Regionalverkehr & S-Bahn",
            train: "Talent 2 (BR 442 · Hamsterbacke)",
            perspective: "Hauptansicht Hennigsdorf",
            author: "Sebastian Rittau (Wikimedia Commons)",
            license: "CC0 / Public Domain"
        ),
        TrainImageAttribution(
            category: "Regionalverkehr & S-Bahn",
            train: "Talent 2 (BR 442 · Hamsterbacke)",
            perspective: "Führerstand City-Tunnel Leipzig",
            author: "Hennix1989 (Wikimedia Commons)",
            license: "CC BY-SA 3.0"
        ),
        TrainImageAttribution(
            category: "Regionalverkehr & S-Bahn",
            train: "FLIRT 3 (BR 1428 / 1429)",
            perspective: "Hauptansicht Streckenfahrt",
            author: "Johannes Maximilian (Wikimedia Commons)",
            license: "CC BY-SA 4.0"
        ),
        TrainImageAttribution(
            category: "Regionalverkehr & S-Bahn",
            train: "FLIRT 3 (BR 1428 / 1429)",
            perspective: "Innenraum 1. Klasse Fahrgastbereich",
            author: "Hoff1980 (Wikimedia Commons)",
            license: "CC BY-SA 3.0"
        ),
        TrainImageAttribution(
            category: "Regionalverkehr & S-Bahn",
            train: "Mireo (BR 463)",
            perspective: "Hauptansicht Neufahrzeug",
            author: "Joachim Lutz (Wikimedia Commons)",
            license: "CC BY-SA 4.0"
        ),
        TrainImageAttribution(
            category: "Regionalverkehr & S-Bahn",
            train: "Mireo (BR 463)",
            perspective: "Innenraum Fahrgastbereich",
            author: "Metrophil (Wikimedia Commons)",
            license: "CC0 / Public Domain"
        ),
        TrainImageAttribution(
            category: "Regionalverkehr & S-Bahn",
            train: "Twindexx Vario (BR 445 / 446 · Regio)",
            perspective: "Hauptansicht Doppelstock-Triebzug",
            author: "UMO1 (Wikimedia Commons)",
            license: "CC BY-SA 4.0"
        ),
        TrainImageAttribution(
            category: "Regionalverkehr & S-Bahn",
            train: "S-Bahn ET 423 (BR 423 / 430 / 420)",
            perspective: "Streckenansicht S-Bahn",
            author: "Paul Smith (Wikimedia Commons)",
            license: "CC BY 2.0"
        ),
        TrainImageAttribution(
            category: "Regionalverkehr & S-Bahn",
            train: "S-Bahn ET 423 (BR 423)",
            perspective: "Fahrgastraum & Stehbereich",
            author: "Wikimedia Commons Contributors",
            license: "CC BY-SA 4.0"
        ),
        TrainImageAttribution(
            category: "Regionalverkehr & S-Bahn",
            train: "ET 425 (BR 425 · Quietschie)",
            perspective: "Hauptansicht Weinheim",
            author: "Zwiadowca21 (Wikimedia Commons)",
            license: "CC BY-SA 4.0"
        ),
        TrainImageAttribution(
            category: "Regionalverkehr & S-Bahn",
            train: "ET 425 (BR 425 · Quietschie)",
            perspective: "Führerstand & Innenansicht",
            author: "Wikimedia Commons Contributors",
            license: "CC BY-SA 4.0"
        ),
        TrainImageAttribution(
            category: "Regionalverkehr & S-Bahn",
            train: "Coradia LINT (BR 648 / 622)",
            perspective: "Hauptansicht Streckenfahrt LINT 27",
            author: "Spudgun67 (Wikimedia Commons)",
            license: "CC BY-SA 4.0"
        ),
        TrainImageAttribution(
            category: "Regionalverkehr & S-Bahn",
            train: "Coradia LINT (BR 648 / 622)",
            perspective: "Innenraum modernisierter LINT 41",
            author: "Pentium1000 (Wikimedia Commons)",
            license: "CC BY-SA 4.0"
        )
    ]
    
    private var filteredAttributions: [TrainImageAttribution] {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return attributions
        }
        return attributions.filter {
            $0.train.localizedCaseInsensitiveContains(searchText) ||
            $0.perspective.localizedCaseInsensitiveContains(searchText) ||
            $0.author.localizedCaseInsensitiveContains(searchText) ||
            $0.category.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    private var groupedAttributions: [String: [TrainImageAttribution]] {
        Dictionary(grouping: filteredAttributions, by: \.category)
    }
    
    private let categoryOrder = [
        "Sonderzüge & Erprobung",
        "ICE-Flotte (Fernverkehr)",
        "Intercity & Lokomotiven",
        "Regionalverkehr & S-Bahn"
    ]
    
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
                
                ForEach(categoryOrder, id: \.self) { cat in
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
                                    
                                    Text("Foto: \(item.author)")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
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
