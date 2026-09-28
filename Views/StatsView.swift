import SwiftUI
import SwiftData

public struct StatsView: View {
    @Query private var allTrains: [TrainModel]
    @Query(sort: \SpottedTrain.spottedAt, order: .reverse) private var allSpottings: [SpottedTrain]
    
    public init() {}
    
    private var stats: (
        totalSpottings: Int,
        uniqueTrainsSpotted: Int,
        totalTrainsInCatalog: Int,
        totalScore: Int,
        completionPercentage: Double,
        categoryProgress: [CategoryProgress],
        rarityCounts: [RarityCount],
        rarestSpot: SpottedTrain?
    ) {
        StatsCalculator.computeStats(allTrains: allTrains, allSpottings: allSpottings)
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // 1. Hero Score Banner
                    scoreHeroCard
                    
                    // 2. Sammlungsfortschritt Gesamt
                    overallProgressCard
                    
                    // 3. Seltenster Fund (Showcase)
                    if let rarest = stats.rarestSpot, let train = rarest.trainModel {
                        rarestCatchCard(spotted: rarest, train: train)
                    }
                    
                    // 4. Fortschritt nach Kategorien
                    categoryProgressSection
                    
                    // 5. Seltenheits-Verteilung
                    rarityDistributionSection
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .navigationTitle("Spotter-Statistiken")
            .background(Color(uiColor: .systemGroupedBackground))
        }
    }
    
    // MARK: - Components
    
    private var scoreHeroCard: some View {
        VStack(spacing: 8) {
            Text("GESAMT-PUNKTE")
                .font(.caption.weight(.bold))
                .foregroundStyle(.secondary)
                .tracking(1.5)
            
            Text("\(stats.totalScore)")
                .font(.system(size: 46, weight: .heavy, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.orange, .red],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            HStack(spacing: 20) {
                Label("\(stats.totalSpottings) Sichtungen", systemImage: "eye.fill")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.secondary)
                
                Label("\(stats.uniqueTrainsSpotted) von \(stats.totalTrainsInCatalog) Zügen", systemImage: "checkmark.circle.fill")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
    
    private var overallProgressCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Gesamt-Katalog")
                    .font(.headline)
                Spacer()
                Text(String(format: "%.1f %%", stats.completionPercentage))
                    .font(.headline.weight(.heavy))
                    .foregroundStyle(.primary)
            }
            
            ProgressView(value: stats.completionPercentage, total: 100.0)
                .tint(.accentColor)
                .scaleEffect(x: 1, y: 2.2, anchor: .center)
                .clipShape(Capsule())
            
            Text("Entdecke noch \(stats.totalTrainsInCatalog - stats.uniqueTrainsSpotted) Baureihen zur Vervollständigung.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(18)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
    
    private func rarestCatchCard(spotted: SpottedTrain, train: TrainModel) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "trophy.fill")
                    .foregroundStyle(.yellow)
                    .font(.title3)
                Text("Seltenster Fund")
                    .font(.headline.weight(.bold))
                Spacer()
                RarityBadgeView(rarity: train.rarity, style: .glowing)
            }
            
            HStack(spacing: 16) {
                Image(systemName: train.assetName)
                    .font(.system(size: 32))
                    .foregroundStyle(train.rarity.color)
                    .frame(width: 56, height: 56)
                    .background(train.rarity.color.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(train.seriesCode) - \(train.commercialName)")
                        .font(.headline)
                    
                    if let tz = spotted.tzNumber {
                        Text("Triebzug: \(tz)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                    if let location = spotted.stationOrLocationName {
                        Text(location)
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                }
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(uiColor: .secondarySystemGroupedBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(train.rarity.color.opacity(0.4), lineWidth: 1.5)
        )
        .shadow(color: train.rarity.color.opacity(0.15), radius: 10, y: 4)
    }
    
    private var categoryProgressSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Fortschritt nach Kategorien")
                .font(.headline)
                .padding(.horizontal, 4)
            
            ForEach(stats.categoryProgress) { cat in
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Label(cat.category.rawValue, systemImage: cat.category.icon)
                            .font(.subheadline.weight(.medium))
                        Spacer()
                        Text("\(cat.spottedCount) / \(cat.totalCount)")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.secondary)
                    }
                    
                    ProgressView(value: cat.percentage, total: 100.0)
                        .tint(cat.percentage == 100 ? .green : .accentColor)
                }
                .padding(14)
                .background(Color(uiColor: .secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
        }
    }
    
    private var rarityDistributionSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Seltenheits-Verteilung")
                .font(.headline)
                .padding(.horizontal, 4)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(stats.rarityCounts) { item in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            RarityBadgeView(rarity: item.rarity, style: .minimal)
                            Spacer()
                        }
                        
                        Text("\(item.count)")
                            .font(.title2.weight(.heavy))
                            .foregroundStyle(.primary)
                        
                        Text("x gesichtet")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    .padding(14)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
            }
        }
    }
}
