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
                            
                            Text("Version 1.0.0 (Build 1)")
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
    
    private func deleteAllSpottings() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
        for spot in spottings {
            modelContext.delete(spot)
        }
        try? modelContext.save()
    }
}

// MARK: - Bildnachweise Modal
struct AttributionSheetView: View {
    @Environment(\.dismiss) private var dismiss
    
    let attributions: [(train: String, author: String, license: String)] = [
        ("Regenbogen-ICE (Tz 304)", "J.M. (Wikimedia Commons)", "CC BY-SA 4.0"),
        ("Europa-ICE (Tz 4601)", "Wikimedia Commons Contributors", "CC BY-SA 4.0"),
        ("ICE S (BR 410)", "DB Systemtechnik / Wikimedia", "CC BY-SA 4.0"),
        ("ICE 3neo (BR 408)", "Nicky Boogaard / Wikimedia", "CC BY-SA 4.0"),
        ("ICE T (BR 411)", "Herbert Ortner / Wikimedia", "CC BY-SA 3.0"),
        ("ICE 3 (BR 407 Velaro D)", "Siemens / Wikimedia", "CC BY-SA 3.0"),
        ("ICE 1 (BR 401)", "DB Fernverkehr / Wikimedia", "CC BY-SA 3.0"),
        ("ICE 2 (BR 402)", "Wikimedia Commons Contributors", "CC BY-SA 4.0"),
        ("ICE 4 (BR 412)", "R.M. / Wikimedia Commons", "CC BY-SA 4.0"),
        ("Twindexx Vario (BR 445)", "Bombardier / Wikimedia", "CC BY-SA 3.0")
    ]
    
    var body: some View {
        NavigationStack {
            List(attributions, id: \.train) { item in
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.train)
                        .font(.headline)
                    HStack {
                        Text("Urheber: \(item.author)")
                        Spacer()
                        Text(item.license)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(Color.accentColor)
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
                .padding(.vertical, 2)
            }
            .navigationTitle("Bildnachweise")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Schließen") { dismiss() }
                }
            }
        }
    }
}
