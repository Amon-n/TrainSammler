import SwiftUI
import SwiftData
import PhotosUI

@MainActor
public struct QuickSpotView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \TrainModel.seriesCode) private var catalogTrains: [TrainModel]
    
    @State private var viewModel = QuickSpotViewModel()
    @State private var showingTrainPicker = false
    @State private var earnedPoints: Int = 0
    @FocusState private var isTzFocused: Bool
    
    public init() {}
    
    var quickSelectTrains: [TrainModel] {
        // Die 4 häufigsten Alltagszüge für den 1-Tap-Zugriff
        catalogTrains.filter { train in
            ["BR 412", "BR 408", "BR 401", "BR 446 / BR 445"].contains(train.seriesCode)
        }
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 18) {
                    
                    // 1. Live GPS Standort-Stamp
                    locationCard
                    
                    // 2. Baureihen-Auswahl mit Quick-Picks
                    trainSelectionSection
                    
                    // 3. Triebzugnummer & Notiz
                    detailsCard
                    
                    // 4. Beweisfoto (Optional)
                    photoCard
                    
                    // 5. Großer Action-Button
                    submitButton
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .navigationTitle("Schnell-Sichtung")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(uiColor: .systemGroupedBackground))
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Fertig") { isTzFocused = false }
                }
            }
            .onAppear {
                viewModel.onAppear()
            }
            .sheet(isPresented: $showingTrainPicker) {
                TrainPickerSheet(trains: catalogTrains, selectedTrain: $viewModel.selectedTrainModel)
            }
            .onChange(of: viewModel.selectedPhotoItem) { _, _ in
                Task {
                    await viewModel.loadSelectedPhoto()
                }
            }
            .alert("Hinweis", isPresented: Binding<Bool>(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )) {
                Button("OK") { viewModel.errorMessage = nil }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
            .overlay(alignment: .top) {
                if viewModel.showSuccessToast {
                    successToast
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
            .animation(.spring(response: 0.35, dampingFraction: 0.8), value: viewModel.showSuccessToast)
        }
    }
    
    // MARK: - Subviews
    
    private var locationCard: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.accentColor.opacity(0.12))
                    .frame(width: 36, height: 36)
                
                Image(systemName: "location.fill")
                    .foregroundColor(.accentColor)
                    .font(.subheadline)
                    .symbolEffect(.pulse, isActive: viewModel.locationManager.isLocating)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("STANDORT-STAMP")
                    .font(.caption2.weight(.heavy))
                    .foregroundStyle(.secondary)
                    .tracking(0.8)
                
                Text(viewModel.locationManager.currentPlaceName)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Button {
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
                viewModel.locationManager.requestLocation()
            } label: {
                Image(systemName: "arrow.clockwise")
                    .font(.caption.weight(.bold))
                    .foregroundColor(.secondary)
                    .padding(8)
                    .background(Color(uiColor: .tertiarySystemGroupedBackground))
                    .clipShape(Circle())
            }
        }
        .padding(12)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
    
    private var trainSelectionSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Zug-Baureihe")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
            
            if let selected = viewModel.selectedTrainModel {
                // Ausgewählte Baureihe im Detail
                Button {
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                    showingTrainPicker = true
                } label: {
                    HStack(spacing: 14) {
                        TrainImageView(assetName: selected.assetName)
                            .frame(width: 100, height: 70)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(selected.seriesCode)
                                    .font(.headline.weight(.bold))
                                    .foregroundStyle(.primary)
                                Spacer()
                                RarityBadgeView(rarity: selected.rarity, style: selected.rarity == .legendary ? .glowing : .standard)
                            }
                            
                            Text(selected.commercialName)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                            
                            Text("Tippen zum Ändern")
                                .font(.caption2.weight(.semibold))
                                .foregroundStyle(Color.accentColor)
                                .padding(.top, 2)
                        }
                    }
                    .padding(12)
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .strokeBorder(selected.rarity.color.opacity(0.4), lineWidth: 1.5)
                    )
                }
            } else {
                // Schnellauswahl Chips für Alltagszüge
                VStack(spacing: 10) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(quickSelectTrains) { train in
                                Button {
                                    let impact = UIImpactFeedbackGenerator(style: .medium)
                                    impact.impactOccurred()
                                    viewModel.selectedTrainModel = train
                                } label: {
                                    HStack(spacing: 8) {
                                        TrainImageView(assetName: train.assetName)
                                            .frame(width: 38, height: 28)
                                            .clipShape(RoundedRectangle(cornerRadius: 6))
                                        
                                        VStack(alignment: .leading, spacing: 1) {
                                            Text(train.commercialName)
                                                .font(.caption.weight(.bold))
                                                .foregroundStyle(.primary)
                                            Text(train.seriesCode)
                                                .font(.caption2)
                                                .foregroundStyle(.secondary)
                                        }
                                    }
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 8)
                                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                }
                            }
                        }
                    }
                    
                    // Haupt-Such-Button
                    Button {
                        let impact = UIImpactFeedbackGenerator(style: .medium)
                        impact.impactOccurred()
                        showingTrainPicker = true
                    } label: {
                        HStack {
                            Image(systemName: "magnifyingglass.circle.fill")
                                .font(.title3)
                                .foregroundStyle(Color.accentColor)
                            Text("Alle Baureihen durchsuchen...")
                                .font(.body.weight(.semibold))
                                .foregroundStyle(.primary)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.footnote.weight(.semibold))
                                .foregroundStyle(.tertiary)
                        }
                        .padding(14)
                        .background(Color(uiColor: .secondarySystemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }
                }
            }
        }
    }
    
    private var detailsCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Details")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
            
            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    Text("Tz-Nr.")
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.secondary)
                        .frame(width: 50, alignment: .leading)
                    
                    TextField("z.B. 304 oder 8012", text: $viewModel.tzNumber)
                        .font(.body)
                        .keyboardType(.numbersAndPunctuation)
                        .focused($isTzFocused)
                    
                    if !viewModel.tzNumber.isEmpty {
                        Button {
                            viewModel.tzNumber = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(14)
                
                Divider().padding(.leading, 14)
                
                HStack(spacing: 12) {
                    Image(systemName: "text.bubble")
                        .foregroundColor(.secondary)
                        .frame(width: 24)
                    
                    TextField("Notiz (Gleis, Verspätung, Fahrtziel)", text: $viewModel.notes)
                        .font(.body)
                }
                .padding(14)
            }
            .background(Color(uiColor: .secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
    }
    
    private var photoCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Beweisfoto (Optional)")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
            
            if let data = viewModel.photoData, let uiImage = UIImage(data: data) {
                ZStack(alignment: .topTrailing) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: 170)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    
                    Button {
                        viewModel.photoData = nil
                        viewModel.selectedPhotoItem = nil
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.white, .black.opacity(0.6))
                            .padding(10)
                    }
                }
            } else {
                PhotosPicker(selection: $viewModel.selectedPhotoItem, matching: .images) {
                    HStack(spacing: 10) {
                        Image(systemName: "camera.fill")
                            .font(.subheadline.weight(.semibold))
                        Text("Foto aufnehmen / auswählen")
                            .font(.subheadline.weight(.medium))
                    }
                    .foregroundColor(.accentColor)
                    .frame(maxWidth: .infinity)
                    .padding(14)
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(Color.accentColor.opacity(0.3), style: StrokeStyle(lineWidth: 1.5, dash: [6]))
                    )
                }
            }
        }
    }
    
    private var submitButton: some View {
        Button {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            
            earnedPoints = viewModel.selectedTrainModel?.rarity.points ?? 100
            
            if viewModel.saveSpotting(context: modelContext) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    withAnimation {
                        viewModel.showSuccessToast = false
                    }
                }
            }
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title3.bold())
                Text("Sichtung erfassen")
                    .font(.headline.weight(.bold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                viewModel.selectedTrainModel != nil
                    ? Color.accentColor
                    : Color.gray.opacity(0.35)
            )
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .shadow(color: viewModel.selectedTrainModel != nil ? Color.accentColor.opacity(0.35) : .clear, radius: 10, y: 5)
        }
        .disabled(viewModel.selectedTrainModel == nil || viewModel.isSaving)
        .padding(.top, 6)
    }
    
    private var successToast: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(Color.green)
                    .frame(width: 42, height: 42)
                Image(systemName: "checkmark")
                    .font(.title3.bold())
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Zug erfolgreich erfasst!")
                    .font(.headline.weight(.bold))
                Text("+\(earnedPoints) XP deinem Bahn-Score gutgeschrieben.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(16)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: .black.opacity(0.15), radius: 16, y: 8)
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }
}

// MARK: - Schnell-Auswahl Modal für Baureihen
@MainActor
struct TrainPickerSheet: View {
    let trains: [TrainModel]
    @Binding var selectedTrain: TrainModel?
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    
    var filteredTrains: [TrainModel] {
        if searchText.isEmpty {
            return trains
        } else {
            return trains.filter {
                $0.seriesCode.localizedCaseInsensitiveContains(searchText) ||
                $0.commercialName.localizedCaseInsensitiveContains(searchText) ||
                ($0.designation?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            List(filteredTrains) { train in
                Button {
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                    selectedTrain = train
                    dismiss()
                } label: {
                    HStack(spacing: 14) {
                        TrainImageView(assetName: train.assetName)
                            .frame(width: 58, height: 42)
                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                        
                        VStack(alignment: .leading, spacing: 2) {
                            HStack {
                                Text(train.seriesCode)
                                    .font(.headline)
                                    .foregroundStyle(.primary)
                                Spacer()
                                RarityBadgeView(rarity: train.rarity, style: .minimal)
                            }
                            Text(train.commercialName)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .searchable(text: $searchText, prompt: "Baureihe (z.B. 408, ICE 3)")
            .navigationTitle("Baureihe wählen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Schließen") { dismiss() }
                }
            }
        }
    }
}
