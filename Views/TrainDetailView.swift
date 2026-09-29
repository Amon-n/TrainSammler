import SwiftUI
import SwiftData

@MainActor
public struct TrainDetailView: View {
    let train: TrainModel
    var onSpotThisTrain: (() -> Void)? = nil
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var selectedImageIndex: Int = 0
    @State private var showSpotConfirmation = false
    @State private var spotSuccessToast = false
    @State private var tzInput: String = ""
    @State private var notesInput: String = ""
    @State private var isShowingSpotSheet = false
    
    private let locationManager = LocationManager()
    
    public init(train: TrainModel, onSpotThisTrain: (() -> Void)? = nil) {
        self.train = train
        self.onSpotThisTrain = onSpotThisTrain
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // 1. Hero Image Galerie (IMMER IN FARBE!)
                    heroGallery
                    
                    // 2. Schnell-Fakten (Speed, Category, Status)
                    quickFactsSection
                    
                    // 3. Neu: "Woran erkenne ich ihn?" (Spotter-Erkennungsmerkmale)
                    spotterGuideSection
                    
                    // 4. Beschreibung & Details
                    overviewSection
                    
                    // 5. Deine Sichtungen
                    pastSpottingsSection
                    
                    // 6. Action Button: Jetzt erfassen
                    spotActionButton
                }
                .padding(.top, 10)
            }
            .background(Color(uiColor: .systemGroupedBackground))
            .navigationTitle(train.seriesCode)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Fertig") { dismiss() }
                }
            }
            .sheet(isPresented: $isShowingSpotSheet) {
                directSpotSheet
            }
            .overlay(alignment: .top) {
                if spotSuccessToast {
                    successToast
                }
            }
            .onAppear {
                locationManager.requestLocation()
            }
        }
    }
    
    // MARK: - 1. Hero Image Galerie
    
    private var heroGallery: some View {
        ZStack(alignment: .bottomLeading) {
            let images = train.galleryImageNames
            
            TabView(selection: $selectedImageIndex) {
                ForEach(0..<images.count, id: \.self) { idx in
                    TrainImageView(assetName: images[idx], isSilhouette: false)
                        .tag(idx)
                        .frame(height: 230)
                        .clipped()
                }
            }
            .frame(height: 230)
            .tabViewStyle(.page(indexDisplayMode: images.count > 1 ? .always : .never))
            
            // Subtiler Verlauf für Lesbarkeit des Titels
            LinearGradient(
                colors: [.clear, .black.opacity(0.85)],
                startPoint: .center,
                endPoint: .bottom
            )
            
            // Header Info & Rarity
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(train.seriesCode)
                        .font(.title2.weight(.heavy))
                        .foregroundColor(.white)
                    
                    Text(train.commercialName)
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(.white.opacity(0.9))
                }
                Spacer()
                RarityBadgeView(rarity: train.rarity, style: train.rarity == .legendary ? .glowing : .standard)
            }
            .padding(16)
        }
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(alignment: .topTrailing) {
            if train.galleryImageNames.count > 1 {
                HStack(spacing: 4) {
                    Image(systemName: "photo.stack.fill")
                        .font(.system(size: 10))
                    Text("\(selectedImageIndex + 1)/\(train.galleryImageNames.count)")
                        .font(.system(size: 11, weight: .bold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(.ultraThinMaterial)
                .clipShape(Capsule())
                .padding(12)
            }
        }
        .padding(.horizontal, 16)
    }
    
    // MARK: - 2. Schnell-Fakten
    
    private var quickFactsSection: some View {
        HStack(spacing: 12) {
            if let speed = train.maxSpeedKmH {
                FactPill(icon: "speedometer", title: "Top-Speed", value: "\(speed) km/h")
            }
            
            FactPill(
                icon: train.category.icon,
                title: "Kategorie",
                value: train.category.rawValue.components(separatedBy: " ").first ?? ""
            )
            
            FactPill(
                icon: train.isSpotted ? "checkmark.seal.fill" : "lock.fill",
                title: "Status",
                value: train.isSpotted ? "\(train.spotCount)x Gespottet" : "Unentdeckt",
                valueColor: train.isSpotted ? .green : .secondary
            )
        }
        .padding(.horizontal, 16)
    }
    
    // MARK: - 3. Spotter-Guide ("Woran erkenne ich ihn?")
    
    private var spotterGuideSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Label("Woran erkenne ich ihn?", systemImage: "binoculars.fill")
                    .font(.headline)
                    .foregroundStyle(.primary)
                Spacer()
                Text("Spotter-Guide")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(Color.accentColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color.accentColor.opacity(0.12))
                    .clipShape(Capsule())
            }
            
            VStack(spacing: 10) {
                ForEach(train.spotterFeatures) { feature in
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: feature.icon)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(train.rarity.color)
                            .frame(width: 32, height: 32)
                            .background(train.rarity.color.opacity(0.12))
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(feature.title)
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.primary)
                            Text(feature.description)
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        Spacer(minLength: 0)
                    }
                    .padding(10)
                    .background(Color(uiColor: .tertiarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
            }
        }
        .padding(16)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .padding(.horizontal, 16)
    }
    
    // MARK: - 4. Übersicht & Besonderheiten
    
    private var overviewSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Über diese Baureihe")
                .font(.headline)
            
            Text(train.overviewDescription)
                .font(.body)
                .foregroundStyle(.secondary)
                .lineSpacing(4)
            
            if let desig = train.designation {
                Divider()
                    .padding(.vertical, 4)
                
                HStack {
                    Text("Besonderheit / Taufname:")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(desig)
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.primary)
                }
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .padding(.horizontal, 16)
    }
    
    // MARK: - 5. Deine Sichtungen
    
    private var pastSpottingsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Deine Sichtungen (\(train.spotCount))")
                .font(.headline)
                .padding(.horizontal, 16)
            
            if train.spottings.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "camera.viewfinder")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                    Text("Noch kein Eintrag im Logbuch")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.secondary)
                    Text("Sobald du diesen Zug erfasst, erscheint er hier in deiner Historie.")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
                .background(Color(uiColor: .secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .padding(.horizontal, 16)
            } else {
                VStack(spacing: 8) {
                    ForEach(train.spottings.sorted { $0.spottedAt > $1.spottedAt }) { spot in
                        HStack(spacing: 12) {
                            Image(systemName: "tram.fill")
                                .foregroundColor(train.rarity.color)
                                .padding(10)
                                .background(train.rarity.color.opacity(0.12))
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(spot.stationOrLocationName ?? "Standort erfasst")
                                    .font(.subheadline.weight(.semibold))
                                if let tz = spot.tzNumber {
                                    Text("Triebzug: \(tz)")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            
                            Spacer()
                            
                            Text(spot.spottedAt.formatted(date: .abbreviated, time: .omitted))
                                .font(.caption2)
                                .foregroundStyle(.tertiary)
                        }
                        .padding(12)
                        .background(Color(uiColor: .secondarySystemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
    
    // MARK: - 6. Action Button
    
    private var spotActionButton: some View {
        Button {
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
            isShowingSpotSheet = true
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "bolt.fill")
                Text("Diesen Zug jetzt erfassen")
                    .font(.headline)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.accentColor)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .shadow(color: Color.accentColor.opacity(0.35), radius: 10, y: 5)
        }
        .padding(.horizontal, 16)
        .padding(.top, 4)
        .padding(.bottom, 24)
    }
    
    // MARK: - Direkt-Spotting Sheet
    
    private var directSpotSheet: some View {
        NavigationStack {
            Form {
                Section("Zug") {
                    HStack {
                        TrainImageView(assetName: train.assetName, isSilhouette: false)
                            .frame(width: 60, height: 42)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        VStack(alignment: .leading, spacing: 2) {
                            Text(train.seriesCode)
                                .font(.headline)
                            Text(train.commercialName)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        RarityBadgeView(rarity: train.rarity, style: .minimal)
                    }
                }
                
                Section("Standort & Details") {
                    HStack {
                        Image(systemName: "location.fill")
                            .foregroundColor(.accentColor)
                        Text(locationManager.currentPlaceName.isEmpty ? "Standort wird ermittelt..." : locationManager.currentPlaceName)
                            .font(.subheadline)
                    }
                    
                    TextField("Triebzug-Nummer (z.B. Tz 408 015)", text: $tzInput)
                    TextField("Notizen (optional)", text: $notesInput)
                }
            }
            .navigationTitle("Zug erfassen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") { isShowingSpotSheet = false }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Speichern") {
                        saveDirectSpot()
                    }
                    .fontWeight(.bold)
                }
            }
        }
        .presentationDetents([.medium])
    }
    
    private func saveDirectSpot() {
        let coord = locationManager.lastLocation?.coordinate
        let newSpot = SpottedTrain(
            spottedAt: Date(),
            tzNumber: tzInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : tzInput,
            latitude: coord?.latitude,
            longitude: coord?.longitude,
            stationOrLocationName: locationManager.currentPlaceName.isEmpty ? nil : locationManager.currentPlaceName,
            photoData: nil,
            notes: notesInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : notesInput,
            trainModel: train
        )
        modelContext.insert(newSpot)
        do {
            try modelContext.save()
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            isShowingSpotSheet = false
            withAnimation(.spring()) {
                spotSuccessToast = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    spotSuccessToast = false
                }
            }
        } catch {
            print("Fehler beim Speichern: \(error)")
        }
    }
    
    private var successToast: some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
                .font(.title3)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Erfolgreich erfasst!")
                    .font(.subheadline.weight(.bold))
                Text("+\(train.rarity.points) Sammler-XP hinzugefügt")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color.black.opacity(0.12), radius: 12, y: 6)
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .transition(.move(edge: .top).combined(with: .opacity))
    }
}

public struct FactPill: View {
    let icon: String
    let title: String
    let value: String
    var valueColor: Color = .primary
    
    public init(icon: String, title: String, value: String, valueColor: Color = .primary) {
        self.icon = icon
        self.title = title
        self.value = value
        self.valueColor = valueColor
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.caption2)
                Text(title)
                    .font(.caption2.weight(.medium))
            }
            .foregroundStyle(.secondary)
            
            Text(value)
                .font(.footnote.weight(.bold))
                .foregroundColor(valueColor)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}
