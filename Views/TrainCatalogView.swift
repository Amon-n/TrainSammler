import SwiftUI
import SwiftData

public struct TrainCatalogView: View {
    @Query(sort: \TrainModel.seriesCode) private var trains: [TrainModel]
    @State private var selectedCategory: TrainCategory?
    @State private var searchText: String = ""
    
    public init() {}
    
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
                    
                    // Filter Chips
                    categoryFilterBar
                    
                    // Train Grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                        ForEach(filteredTrains) { train in
                            TrainCatalogCard(train: train)
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.vertical, 12)
            }
            .searchable(text: $searchText, prompt: "Suche nach Baureihe oder Name")
            .navigationTitle("Train-Dex")
            .background(Color(uiColor: .systemGroupedBackground))
        }
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

// MARK: - Subviews
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

struct TrainCatalogCard: View {
    let train: TrainModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack(alignment: .topTrailing) {
                // Background icon or silhouette
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(train.isSpotted ? train.rarity.color.opacity(0.12) : Color.gray.opacity(0.1))
                    .frame(height: 100)
                    .overlay {
                        Image(systemName: train.assetName)
                            .font(.system(size: 42))
                            .foregroundStyle(train.isSpotted ? train.rarity.color : Color.secondary.opacity(0.3))
                    }
                
                RarityBadgeView(rarity: train.rarity, style: .minimal)
                    .padding(8)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(train.seriesCode)
                    .font(.headline)
                    .foregroundStyle(train.isSpotted ? .primary : .secondary)
                
                Text(train.commercialName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            
            Spacer(minLength: 0)
            
            HStack {
                if train.isSpotted {
                    Label("\(train.spotCount)x", systemImage: "checkmark.seal.fill")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(.green)
                } else {
                    Label("Unentdeckt", systemImage: "questionmark.circle")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }
        }
        .padding(12)
        .frame(height: 190)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(train.isSpotted ? train.rarity.color.opacity(0.3) : Color.clear, lineWidth: 1)
        )
        .opacity(train.isSpotted ? 1.0 : 0.75)
    }
}
