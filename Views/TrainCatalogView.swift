import SwiftUI
import SwiftData

@MainActor
public struct TrainCatalogView: View {
    @Query(sort: \TrainModel.seriesCode) private var trains: [TrainModel]
    @State private var selectedCategory: TrainCategory?
    @State private var onlyUnspotted: Bool = false
    @State private var sortOption: SortOption = .series
    @State private var searchText: String = ""
    @State private var inspectedTrain: TrainModel?
    
    public enum SortOption: String, CaseIterable, Identifiable {
        case series = "Baureihe (Standard)"
        case rarity = "Seltenheit (Seltenste zuerst)"
        case name = "Name (A–Z)"
        case unspottedFirst = "Unentdeckt zuerst"
        
        public var id: String { rawValue }
        
        public var icon: String {
            switch self {
            case .series: return "number"
            case .rarity: return "sparkles"
            case .name: return "textformat"
            case .unspottedFirst: return "eye.slash"
            }
        }
    }
    
    public init() {}
    
    var spottedCount: Int {
        trains.filter { $0.isSpotted }.count
    }
    
    var filteredTrains: [TrainModel] {
        let base = trains.filter { train in
            let matchesCategory = selectedCategory == nil || train.category == selectedCategory
            let matchesUnspotted = !onlyUnspotted || !train.isSpotted
            let matchesSearch = searchText.isEmpty ||
                train.seriesCode.localizedCaseInsensitiveContains(searchText) ||
                train.commercialName.localizedCaseInsensitiveContains(searchText) ||
                (train.designation?.localizedCaseInsensitiveContains(searchText) ?? false)
            return matchesCategory && matchesUnspotted && matchesSearch
        }
        
        return base.sorted { a, b in
            switch sortOption {
            case .series:
                return a.seriesCode.localizedStandardCompare(b.seriesCode) == .orderedAscending
            case .rarity:
                if a.rarity.points != b.rarity.points {
                    return a.rarity.points > b.rarity.points
                }
                return a.seriesCode.localizedStandardCompare(b.seriesCode) == .orderedAscending
            case .name:
                return a.commercialName.localizedStandardCompare(b.commercialName) == .orderedAscending
            case .unspottedFirst:
                if a.isSpotted != b.isSpotted {
                    return !a.isSpotted && b.isSpotted
                }
                return a.seriesCode.localizedStandardCompare(b.seriesCode) == .orderedAscending
            }
        }
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    
                    // 1. Progress Banner (Sammel-Fortschritt)
                    progressHeader
                    
                    // 2. Filter Chips (Kategorien & Fehlt-Filter)
                    categoryFilterBar
                    
                    // 3. Train Trading Card Grid oder Empty State
                    if filteredTrains.isEmpty {
                        emptyStateView
                    } else {
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
                }
                .padding(.vertical, 12)
            }
            .scrollDismissesKeyboard(.interactively)
            .searchable(text: $searchText, prompt: "Suche nach Baureihe oder Name")
            .navigationTitle("Train-Dex")
            .background(Color(uiColor: .systemGroupedBackground))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Picker("Sortierung", selection: $sortOption) {
                            ForEach(SortOption.allCases) { option in
                                Label(option.rawValue, systemImage: option.icon).tag(option)
                            }
                        }
                    } label: {
                        Image(systemName: "arrow.up.arrow.down.circle")
                            .font(.system(size: 17))
                            .foregroundStyle(sortOption == .series ? Color.secondary : Color.accentColor)
                    }
                }
            }
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
                    .font(.caption2.weight(.heavy))
                    .foregroundStyle(.primary)
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
                // "Noch unentdeckt" Schnell-Filter
                Button {
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        onlyUnspotted.toggle()
                    }
                } label: {
                    HStack(spacing: 5) {
                        Image(systemName: onlyUnspotted ? "eye.slash.fill" : "eye.slash")
                        Text("Fehlt mir")
                    }
                    .font(.subheadline.weight(.medium))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(onlyUnspotted ? Color.orange : Color(uiColor: .secondarySystemGroupedBackground))
                    .foregroundColor(onlyUnspotted ? .white : .primary)
                    .clipShape(Capsule())
                }
                
                FilterChip(title: "Alle", isSelected: selectedCategory == nil && !onlyUnspotted) {
                    selectedCategory = nil
                    onlyUnspotted = false
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
    
    private var emptyStateView: some View {
        Group {
            if !searchText.isEmpty {
                ContentUnavailableView.search(text: searchText)
                    .padding(.top, 40)
            } else if onlyUnspotted {
                ContentUnavailableView(
                    "Alle Züge entdeckt! 🎉",
                    systemImage: "trophy.fill",
                    description: Text("Du hast in dieser Auswahl bereits jeden einzelnen Zug gespottet. Großartige Leistung!")
                )
                .padding(.top, 40)
            } else {
                ContentUnavailableView(
                    "Keine Züge gefunden",
                    systemImage: "tram",
                    description: Text("In dieser Kategorie sind aktuell keine Baureihen hinterlegt.")
                )
                .padding(.top, 40)
            }
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
                
                // Entdeckt Badge ODER Rarity
                if train.isSpotted {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.subheadline)
                        .foregroundStyle(Color.green)
                        .background(Circle().fill(.white).padding(2))
                        .padding(8)
                }
            }
            
            // 2. Karten-Body
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(train.seriesCode)
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                    Spacer()
                    RarityBadgeView(rarity: train.rarity, style: .minimal)
                }
                
                Text(train.commercialName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                
                HStack {
                    Text(train.category.rawValue)
                        .font(.caption2.weight(.medium))
                        .foregroundStyle(.tertiary)
                    Spacer()
                    if train.isSpotted {
                        Text("\(train.spottings.count)× gespottet")
                            .font(.caption2.weight(.semibold))
                            .foregroundStyle(Color.accentColor)
                    } else {
                        Text("Unentdeckt")
                            .font(.caption2.weight(.medium))
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.top, 4)
            }
            .padding(10)
        }
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(train.isSpotted ? train.rarity.color.opacity(0.3) : Color.clear, lineWidth: 1.5)
        )
        .shadow(color: Color.black.opacity(0.04), radius: 6, y: 3)
    }
}
