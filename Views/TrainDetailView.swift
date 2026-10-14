import SwiftUI
import SwiftData
import PhotosUI

public enum DetailPhotoItem: Identifiable, Hashable {
    case user(id: UUID, data: Data, station: String?, date: Date)
    case catalog(photo: TrainPhotoDetail)
    
    public var id: String {
        switch self {
        case .user(let uid, _, _, _):
            return "user_\(uid.uuidString)"
        case .catalog(let photo):
            return "cat_\(photo.assetName)"
        }
    }
}

@MainActor
public struct TrainDetailView: View {
    let train: TrainModel
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var selectedPhotoIndex: Int = 0
    @State private var isShowingSpotSheet = false
    @State private var spotSuccessToast = false
    @State private var selectedAttributionPhoto: TrainPhotoDetail? = nil
    @State private var previewSpot: SpottedTrain? = nil
    
    // Direkt-Spotting Form
    @State private var tzInput: String = ""
    @State private var notesInput: String = ""
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var capturedPhotoData: Data?
    
    enum SpotField: Hashable {
        case tz
        case notes
    }
    @FocusState private var spotFocusedField: SpotField?
    
    private let locationManager = LocationManager()
    
    public init(train: TrainModel) {
        self.train = train
    }
    
    /// Alle verfügbaren Fotos: Zuerst persönliche Nutzer-Fotos, dann alle offiziellen Katalog-Bilder
    private var allPhotos: [DetailPhotoItem] {
        var items: [DetailPhotoItem] = []
        
        // 1. Eigene Fotos des Nutzers für diesen Zug
        for spot in train.spottings.sorted(by: { $0.spottedAt > $1.spottedAt }) {
            if let data = spot.photoData {
                items.append(.user(id: spot.id, data: data, station: spot.stationOrLocationName, date: spot.spottedAt))
            }
        }
        
        // 2. Offizielle kuratierte Katalog-Bilder mit charakteristischen Merkmalen
        for photo in train.galleryPhotos {
            items.append(.catalog(photo: photo))
        }
        
        return items
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    
                    // 1. Flüssig wischbare Bildergalerie & Thumbnail-Leiste
                    heroGallerySection
                    
                    // 2. Titel & Baureihe & Seltenheit
                    titleCard
                    
                    // 3. Schnell-Fakten (Speed, Category, Status)
                    quickFactsSection
                    
                    // 4. Spotter-Guide ("Woran erkenne ich ihn?")
                    spotterGuideSection
                    
                    // 5. Zug-Charakteristiken & Galerie-Details
                    trainCharacteristicsGallerySection
                    
                    // 6. Beschreibung & Details
                    overviewSection
                    
                    // 6. Deine Sichtungen (inkl. Fotovorschau)
                    pastSpottingsSection
                    
                    // 7. Action Button: Jetzt erfassen
                    spotActionButton
                }
                .padding(.top, 8)
            }
            .background(Color(uiColor: .systemGroupedBackground))
            .navigationTitle(train.seriesCode)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Fertig") { dismiss() }
                        .fontWeight(.semibold)
                }
            }
            .sheet(isPresented: $isShowingSpotSheet) {
                directSpotSheet
            }
            .sheet(item: $selectedAttributionPhoto) { photo in
                PhotoAttributionDetailSheet(photo: photo)
            }
            .sheet(item: $previewSpot) { spot in
                PhotoPreviewSheet(spot: spot)
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
    
    // MARK: - 1. Hero Gallery & Thumbnails
    
    private var heroGallerySection: some View {
        VStack(spacing: 10) {
            let photos = allPhotos
            
            // A. Großer wischbarer Image Slider
            TabView(selection: $selectedPhotoIndex) {
                ForEach(Array(photos.enumerated()), id: \.element.id) { index, photo in
                    ZStack(alignment: .bottomLeading) {
                        switch photo {
                        case .user(_, let data, _, _):
                            if let uiImg = UIImage(data: data) {
                                Image(uiImage: uiImg)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 235)
                                    .clipped()
                            } else {
                                Color.secondary.opacity(0.12)
                                    .frame(height: 235)
                            }
                        case .catalog(let catPhoto):
                            TrainImageView(assetName: catPhoto.assetName, isSilhouette: false)
                                .frame(maxWidth: .infinity)
                                .frame(height: 235)
                                .clipped()
                        }
                        
                        // Dezenter Gradient am Boden für Lesbarkeit
                        LinearGradient(
                            colors: [.clear, .black.opacity(0.75)],
                            startPoint: .center,
                            endPoint: .bottom
                        )
                        .allowsHitTesting(false)
                        
                        // Badge oben & Bildmerkmale/Bildrechte unten
                        VStack(spacing: 0) {
                            // Top Bar
                            HStack {
                                switch photo {
                                case .user(let uid, _, let station, _):
                                    Button {
                                        if let spot = train.spottings.first(where: { $0.id == uid }) {
                                            previewSpot = spot
                                        }
                                    } label: {
                                        HStack(spacing: 5) {
                                            Image(systemName: "camera.fill")
                                                .font(.system(size: 11))
                                            Text("Dein Foto" + (station != nil ? " · \(station!)" : ""))
                                                .font(.caption2.weight(.bold))
                                            Image(systemName: "arrow.up.left.and.down.right.magnifyingglass")
                                                .font(.system(size: 9))
                                        }
                                        .foregroundColor(.black)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 5)
                                        .background(Color.yellow)
                                        .clipShape(Capsule())
                                        .shadow(radius: 4)
                                    }
                                    .buttonStyle(.plain)
                                case .catalog(let catPhoto):
                                    HStack(spacing: 5) {
                                        Image(systemName: "photo.on.rectangle.angled")
                                            .font(.system(size: 11))
                                        Text("Katalog · \(catPhoto.label)")
                                            .font(.caption2.weight(.bold))
                                    }
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(.ultraThinMaterial)
                                    .clipShape(Capsule())
                                }
                                
                                Spacer()
                                
                                Text("\(index + 1) / \(photos.count)")
                                    .font(.caption2.weight(.bold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.black.opacity(0.6))
                                    .clipShape(Capsule())
                            }
                            .padding(12)
                            
                            Spacer()
                            
                            // Bottom Bar: Charakteristik & Urheber
                            if case .catalog(let catPhoto) = photo {
                                HStack(alignment: .bottom, spacing: 8) {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(catPhoto.characteristicDescription)
                                            .font(.system(size: 11, weight: .medium))
                                            .foregroundColor(.white)
                                            .lineLimit(2)
                                            .shadow(color: .black.opacity(0.9), radius: 3)
                                        
                                        HStack(spacing: 4) {
                                            Image(systemName: "c.circle")
                                                .font(.system(size: 9))
                                            Text("\(catPhoto.photographer) · \(catPhoto.license)")
                                                .font(.system(size: 10, weight: .semibold))
                                        }
                                        .foregroundColor(.white.opacity(0.9))
                                        .shadow(color: .black.opacity(0.9), radius: 2)
                                    }
                                    
                                    Spacer()
                                    
                                    Button {
                                        selectedAttributionPhoto = catPhoto
                                    } label: {
                                        Image(systemName: "info.circle.fill")
                                            .font(.system(size: 18))
                                            .foregroundColor(.white.opacity(0.95))
                                            .padding(5)
                                            .background(.ultraThinMaterial)
                                            .clipShape(Circle())
                                    }
                                }
                                .padding(.horizontal, 12)
                                .padding(.bottom, 8)
                            }
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .tag(index)
                }
            }
            .frame(height: 235)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .padding(.horizontal, 16)
            
            // B. Interaktive Thumbnail-Leiste
            if photos.count > 1 {
                ScrollViewReader { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(Array(photos.enumerated()), id: \.element.id) { index, photo in
                                Button {
                                    let impact = UIImpactFeedbackGenerator(style: .light)
                                    impact.impactOccurred()
                                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                        selectedPhotoIndex = index
                                    }
                                } label: {
                                    ZStack(alignment: .bottomTrailing) {
                                        switch photo {
                                        case .user(_, let data, _, _):
                                            if let uiImg = UIImage(data: data) {
                                                Image(uiImage: uiImg)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: 58, height: 40)
                                                    .clipped()
                                            }
                                            // Mini Kamera-Icon für eigenes Foto
                                            Image(systemName: "camera.fill")
                                                .font(.system(size: 7))
                                                .foregroundColor(.black)
                                                .padding(3)
                                                .background(Color.yellow)
                                                .clipShape(Circle())
                                                .padding(2)
                                        case .catalog(let photo):
                                            TrainImageView(assetName: photo.assetName, isSilhouette: false)
                                                .frame(width: 58, height: 40)
                                                .clipped()
                                        }
                                    }
                                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                                            .stroke(selectedPhotoIndex == index ? Color.accentColor : Color.clear, lineWidth: 2.5)
                                    )
                                    .opacity(selectedPhotoIndex == index ? 1.0 : 0.5)
                                }
                                .id(index)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 2)
                    }
                    .onChange(of: selectedPhotoIndex) { _, newIndex in
                        withAnimation {
                            proxy.scrollTo(newIndex, anchor: .center)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - 2. Titel-Karte
    
    private var titleCard: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                Text(train.seriesCode)
                    .font(.title2.weight(.heavy))
                    .foregroundStyle(.primary)
                
                Text(train.commercialName)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            RarityBadgeView(rarity: train.rarity, style: train.rarity == .legendary ? .glowing : .standard)
        }
        .padding(.horizontal, 16)
    }
    

    // MARK: - Zug-Charakteristiken & Galerie
    private var trainCharacteristicsGallerySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("Zug-Charakteristiken & Galerie", systemImage: "sparkles.rectangle.stack.fill")
                    .font(.headline)
                    .foregroundStyle(.primary)
                Spacer()
                Text("\(train.galleryPhotos.count) Perspektiven")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            VStack(spacing: 10) {
                ForEach(Array(train.galleryPhotos.enumerated()), id: \.element.id) { index, photo in
                    Button {
                        let userPhotosCount = train.spottings.filter { $0.photoData != nil }.count
                        let targetIndex = userPhotosCount + index
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                            selectedPhotoIndex = targetIndex
                        }
                    } label: {
                        HStack(alignment: .top, spacing: 12) {
                            TrainImageView(assetName: photo.assetName, isSilhouette: false)
                                .frame(width: 82, height: 60)
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .stroke(Color.secondary.opacity(0.15), lineWidth: 1)
                                )
                            
                            VStack(alignment: .leading, spacing: 3) {
                                HStack {
                                    Text(photo.label)
                                        .font(.subheadline.weight(.semibold))
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Image(systemName: "arrow.up.left.and.down.right.magnifyingglass")
                                        .font(.caption2)
                                        .foregroundStyle(.tertiary)
                                }
                                
                                Text(photo.characteristicDescription)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.leading)
                                
                                HStack(spacing: 4) {
                                    Image(systemName: "c.circle")
                                        .font(.system(size: 9))
                                    Text("\(photo.photographer) · \(photo.license)")
                                        .font(.caption2)
                                }
                                .foregroundColor(.secondary.opacity(0.85))
                                .padding(.top, 1)
                            }
                        }
                        .padding(10)
                        .background(Color(uiColor: .secondarySystemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.horizontal, 16)
    }

    // MARK: - 3. Schnell-Fakten
    
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
    
    // MARK: - 4. Spotter-Guide
    
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
    
    // MARK: - 5. Übersicht & Besonderheiten
    
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
    
    // MARK: - 6. Deine Sichtungen
    
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
                    Text("Sobald du diesen Zug am Gleis erfasst, wird er mit deinen Fotos hier gespeichert.")
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
                        Button {
                            if spot.photoData != nil {
                                previewSpot = spot
                            }
                        } label: {
                            HStack(spacing: 12) {
                                if let data = spot.photoData, let uiImg = UIImage(data: data) {
                                    ZStack(alignment: .bottomTrailing) {
                                        Image(uiImage: uiImg)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 44, height: 44)
                                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                                        
                                        Image(systemName: "arrow.up.left.and.down.right.magnifyingglass")
                                            .font(.system(size: 7, weight: .bold))
                                            .foregroundColor(.white)
                                            .padding(2)
                                            .background(Color.black.opacity(0.65))
                                            .clipShape(Circle())
                                            .padding(1)
                                    }
                                } else {
                                    Image(systemName: "tram.fill")
                                        .foregroundColor(train.rarity.color)
                                        .padding(10)
                                        .background(train.rarity.color.opacity(0.12))
                                        .clipShape(Circle())
                                }
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(spot.stationOrLocationName ?? "Standort erfasst")
                                        .font(.subheadline.weight(.semibold))
                                        .foregroundStyle(.primary)
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
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
    
    // MARK: - 7. Action Button
    
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
                        .focused($spotFocusedField, equals: .tz)
                        .submitLabel(.next)
                        .onSubmit { spotFocusedField = .notes }
                    
                    TextField("Notizen (optional)", text: $notesInput)
                        .focused($spotFocusedField, equals: .notes)
                        .submitLabel(.done)
                        .onSubmit { spotFocusedField = nil }
                }
                
                Section("Eigenes Foto (Optional)") {
                    if let data = capturedPhotoData, let uiImage = UIImage(data: data) {
                        ZStack(alignment: .topTrailing) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity)
                                .frame(height: 150)
                                .clipped()
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            
                            Button {
                                capturedPhotoData = nil
                                selectedPhotoItem = nil
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.title2)
                                    .foregroundStyle(.white, .black.opacity(0.6))
                                    .padding(8)
                            }
                        }
                    } else {
                        PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                            HStack(spacing: 8) {
                                Image(systemName: "camera.fill")
                                Text("Foto aufnehmen oder auswählen")
                            }
                            .foregroundColor(.accentColor)
                        }
                        .onChange(of: selectedPhotoItem) { _, newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                    await MainActor.run {
                                        capturedPhotoData = data
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("Zug erfassen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Fertig") {
                        spotFocusedField = nil
                    }
                    .fontWeight(.semibold)
                }
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
        .presentationDetents([.medium, .large])
    }
    
    private func saveDirectSpot() {
        let coord = locationManager.lastLocation?.coordinate
        let newSpot = SpottedTrain(
            spottedAt: Date(),
            tzNumber: tzInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : tzInput,
            latitude: coord?.latitude,
            longitude: coord?.longitude,
            stationOrLocationName: locationManager.currentPlaceName.isEmpty ? nil : locationManager.currentPlaceName,
            photoData: capturedPhotoData,
            notes: notesInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : notesInput,
            trainModel: train
        )
        modelContext.insert(newSpot)
        do {
            try modelContext.save()
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            isShowingSpotSheet = false
            capturedPhotoData = nil
            selectedPhotoItem = nil
            tzInput = ""
            notesInput = ""
            // Galerie auf das neue Bild setzen
            selectedPhotoIndex = 0
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

// MARK: - Fact Pill Component
private struct FactPill: View {
    let icon: String
    let title: String
    let value: String
    var valueColor: Color = .primary
    
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(Color.accentColor)
            
            Text(title)
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            Text(value)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(valueColor)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .padding(.horizontal, 8)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}


// MARK: - Foto-Attribution Detail Sheet
struct PhotoAttributionDetailSheet: View {
    let photo: TrainPhotoDetail
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    TrainImageView(assetName: photo.assetName, isSilhouette: false)
                        .frame(maxWidth: .infinity)
                        .frame(height: 220)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .clipped()
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text(photo.label)
                            .font(.title3.bold())
                        Text(photo.characteristicDescription)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Bildnachweis & Lizenz")
                            .font(.headline)
                        
                        VStack(spacing: 10) {
                            HStack {
                                Text("Urheber / Fotograf:")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text(photo.photographer)
                                    .font(.subheadline.weight(.semibold))
                                    .multilineTextAlignment(.trailing)
                            }
                            Divider()
                            HStack {
                                Text("Lizenz:")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text(photo.license)
                                    .font(.subheadline.weight(.semibold))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 3)
                                    .background(Color.accentColor.opacity(0.12))
                                    .clipShape(Capsule())
                            }
                            if let urlStr = photo.commonsUrl, let url = URL(string: urlStr) {
                                Divider()
                                Link(destination: url) {
                                    HStack {
                                        Label("Auf Wikimedia Commons ansehen", systemImage: "arrow.up.right.square")
                                            .font(.subheadline.weight(.medium))
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .font(.caption2)
                                    }
                                }
                                .padding(.top, 4)
                            }
                        }
                        .padding(14)
                        .background(Color(uiColor: .secondarySystemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                }
                .padding(16)
            }
            .background(Color(uiColor: .systemGroupedBackground))
            .navigationTitle("Bildnachweis")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Schließen") { dismiss() }
                        .fontWeight(.semibold)
                }
            }
        }
    }
}
