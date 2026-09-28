import SwiftUI
import SwiftData
import PhotosUI

public struct QuickSpotView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \TrainModel.seriesCode) private var catalogTrains: [TrainModel]
    
    @State private var viewModel = QuickSpotViewModel()
    @State private var showingTrainPicker = false
    @State private var triggerSuccessHaptic = false
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // 1. GPS / Bahnhofs-Header
                    locationCard
                    
                    // 2. Baureihen-Auswahl (Hauptfokus)
                    trainSelectionCard
                    
                    // 3. Triebzugnummer (TZ) & Detail-Info
                    detailsCard
                    
                    // 4. Foto-Upload
                    photoCard
                    
                    // 5. Großer Action-Button für schnelles Loggen
                    submitButton
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .navigationTitle("Schnell-Sichtung")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(uiColor: .systemGroupedBackground))
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
            Image(systemName: "location.fill")
                .foregroundColor(.accentColor)
                .font(.title3)
                .symbolEffect(.pulse, isActive: viewModel.locationManager.isLocating)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Standort-Stamp")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)
                
                Text(viewModel.locationManager.currentPlaceName)
                    .font(.subheadline.weight(.medium))
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
                    .font(.callout)
                    .foregroundColor(.secondary)
                    .padding(8)
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .clipShape(Circle())
            }
        }
        .padding(14)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
    
    private var trainSelectionCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Zug-Baureihe")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
            
            if let selected = viewModel.selectedTrainModel {
                Button {
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                    showingTrainPicker = true
                } label: {
                    HStack(spacing: 14) {
                        Image(systemName: selected.assetName)
                            .font(.system(size: 28))
                            .foregroundStyle(selected.rarity.color)
                            .frame(width: 48, height: 48)
                            .background(selected.rarity.color.opacity(0.12))
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
                        }
                    }
                    .padding(14)
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(selected.rarity.color.opacity(0.5), lineWidth: 1.5)
                    )
                }
            } else {
                Button {
                    let impact = UIImpactFeedbackGenerator(style: .medium)
                    impact.impactOccurred()
                    showingTrainPicker = true
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                        Text("Baureihe auswählen...")
                            .font(.body.weight(.semibold))
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(.tertiary)
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity)
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
            }
        }
    }
    
    private var detailsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Zug-Details")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
            
            VStack(spacing: 0) {
                HStack {
                    Image(systemName: "number")
                        .foregroundColor(.secondary)
                        .frame(width: 24)
                    
                    TextField("Triebzug-Nr. (z.B. Tz 304 oder 408 001)", text: $viewModel.tzNumber)
                        .font(.body)
                        .keyboardType(.asciiCapable)
                        .autocorrectionDisabled()
                }
                .padding(14)
                
                Divider().padding(.leading, 46)
                
                HStack {
                    Image(systemName: "text.bubble")
                        .foregroundColor(.secondary)
                        .frame(width: 24)
                    
                    TextField("Optionale Notiz (Gleis, Verspätung, Ziel)", text: $viewModel.notes)
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
                        .frame(height: 180)
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
                            .font(.title3)
                        Text("Foto aufnehmen / auswählen")
                            .font(.subheadline.weight(.medium))
                    }
                    .foregroundColor(.accentColor)
                    .frame(maxWidth: .infinity)
                    .padding(16)
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
            
            if viewModel.saveSpotting(context: modelContext) {
                // Timer zum Ausblenden des Toasts
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation {
                        viewModel.showSuccessToast = false
                    }
                }
            }
        } label: {
            HStack {
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
                    : Color.gray.opacity(0.4)
            )
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .shadow(color: viewModel.selectedTrainModel != nil ? Color.accentColor.opacity(0.35) : .clear, radius: 10, y: 5)
        }
        .disabled(viewModel.selectedTrainModel == nil || viewModel.isSaving)
        .padding(.top, 8)
    }
    
    private var successToast: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.seal.fill")
                .font(.title2)
                .foregroundStyle(.green)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Zug erfolgreich erfasst!")
                    .font(.subheadline.weight(.bold))
                Text("Punkte wurden deinem Punktestand gutgeschrieben.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(radius: 12)
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }
}

// MARK: - Schnell-Auswahl Modal für Baureihen
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
                    HStack(spacing: 12) {
                        Image(systemName: train.assetName)
                            .font(.title3)
                            .foregroundStyle(train.rarity.color)
                            .frame(width: 36, height: 36)
                            .background(train.rarity.color.opacity(0.12))
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
