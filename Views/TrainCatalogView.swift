import SwiftUI
import SwiftData

@MainActor
public struct TrainCatalogView: View {
    @Query(sort: \TrainModel.seriesCode) private var trains: [TrainModel]
    @State private var selectedCategory: TrainCategory?
    @State private var searchText: String = ""
    @State private var inspectedTrain: TrainModel?
    
    public init() {}
    
    var spottedCount: Int {
        trains.filter { $0.isSpotted }.count
    }
    
    var filteredTrains: [TrainModel] {
        trains.filter { train in
            let matchesCategory = selectedCategory == nil || train.category == selectedCategory
            let matchesSearch = searchText.isEmpty ||
                train.seriesCode.localizedCaseInsensitiveContains(searchText) ||
                train.commercialName.localizedCaseInsensitiveContains(searchText) ||
                (train.designation?.localizedCaseInsensitiveContains(searchText) ?? false)
            return matchesCategory && matchesSearch
        }
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    
                    // 1. Progress Banner (Sammel-Fortschritt)
                    progressHeader
                    
                    // 2. Filter Chips
                    categoryFilterBar
                    
                    // 3. Train Trading Card Grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(filteredTrains) { train in
                            TrainCatalogCard(train: train)
                                .onTapGesture {
                                    let impact = UIImpactFeedbackGenerator(style: .light)
                                    impact.impactOccurred()
                                    inspectedTrain = train
                                }
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.vertical, 12)
            }
            .searchable(text: $searchText, prompt: "Suche nach Baureihe oder Name")
            .navigationTitle("Train-Dex")
            .background(Color(uiColor: .systemGroupedBackground))
            .sheet(item: $inspectedTrain) { train in
                TrainDetailView(train: train)
            }
        }
    }
    
    // MARK: - Components
    
    private var progressHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("SAMMLUNG")
                    .font(.caption2.weight(.heavy))
                    .foregroundStyle(.secondary)
                    .tracking(1.2)
                
                Text("\(spottedCount) von \(trains.count) Zügen entdeckt")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.primary)
            }
            
            Spacer()
            
            // Circular mini progress
            ZStack {
                Circle()
                    .stroke(Color.secondary.opacity(0.15), lineWidth: 4)
                Circle()
                    .trim(from: 0, to: trains.isEmpty ? 0 : CGFloat(spottedCount) / CGFloat(trains.count))
                    .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                
                Text(trains.isEmpty ? "0%" : "\(Int((Double(spottedCount) / Double(trains.count)) * 100))%")
                    .font(.system(size: 11, weight: .heavy, design: .rounded))
            }
            .frame(width: 44, height: 44)
        }
        .padding(14)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .padding(.horizontal, 16)
    }
    
    private var categoryFilterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterChip(title: "Alle", isSelected: selectedCategory == nil) {
                    selectedCategory = nil
                }
                
                ForEach(TrainCategory.allCases, id: \.self) { cat in
                    FilterChip(title: cat.rawValue, isSelected: selectedCategory == cat) {
                        selectedCategory = cat
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

// MARK: - Filter Chip
struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.weight(.medium))
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(isSelected ? Color.accentColor : Color(uiColor: .secondarySystemGroupedBackground))
                .foregroundColor(isSelected ? .white : .primary)
                .clipShape(Capsule())
        }
    }
}

// MARK: - Premium Sammelkarte (Trading Card)
struct TrainCatalogCard: View {
    let train: TrainModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            // 1. Bild-Rahmen (16:10 Seitenverhältnis)
            ZStack(alignment: .topTrailing) {
                TrainImageView(assetName: train.assetName, isSilhouette: !train.isSpotted)
                    .frame(height: 115)
                    .frame(maxWidth: .infinity)
                    .clipped()
                
                // Rarity Badge oben rechts
                RarityBadgeView(rarity: train.rarity, style: .minimal)
                    .padding(8)
                
                // Schloss-Overlay wenn unentdeckt
                if !train.isSpotted {
                    ZStack {
                        Capsule()
                            .fill(.ultraThinMaterial)
                        HStack(spacing: 3) {
                            Image(systemName: "lock.fill")
                                .font(.system(size: 9))
                            Text("GESPERRT")
                                .font(.system(size: 9, weight: .heavy))
                        }
                        .foregroundColor(.primary)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                    }
                    .frame(height: 20)
                    .padding(8)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                }
            }
            .background(Color.secondary.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            
            // 2. Info-Bereich
            VStack(alignment: .leading, spacing: 4) {
                Text(train.seriesCode)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(train.isSpotted ? .primary : .secondary)
                    .lineLimit(1)
                
                Text(train.commercialName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                
                Spacer(minLength: 6)
                
                // Footer: Sichtungen oder Seltenheits-Score
                HStack {
                    if train.isSpotted {
                        HStack(spacing: 3) {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundColor(.green)
                            Text("\(train.spotCount)x erfasst")
                                .font(.caption2.weight(.bold))
                                .foregroundColor(.green)
                        }
                    } else {
                        Text("\(train.rarity.points) XP")
                            .font(.caption2.weight(.semibold))
                            .foregroundStyle(.tertiary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }
            }
            .padding(.horizontal, 10)
            .padding(.top, 10)
            .padding(.bottom, 12)
        }
        .frame(height: 205)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(
                    train.isSpotted ? train.rarity.color.opacity(0.35) : Color.primary.opacity(0.06),
                    lineWidth: train.isSpotted ? 1.5 : 1
                )
        )
        .shadow(color: train.isSpotted ? train.rarity.color.opacity(0.12) : Color.black.opacity(0.03), radius: 8, y: 4)
    }
}
