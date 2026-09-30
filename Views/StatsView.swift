import SwiftUI
import SwiftData

@MainActor
public struct StatsView: View {
    @Query private var allTrains: [TrainModel]
    @Query(sort: \SpottedTrain.spottedAt, order: .reverse) private var allSpottings: [SpottedTrain]
    @State private var showingSettings = false
    
    public init() {}
    
    private var stats: TrainStats {
        StatsCalculator.computeStats(allTrains: allTrains, allSpottings: allSpottings)
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // 1. Hero Score Banner mit Rang
                    scoreHeroCard
                    
                    // 2. Trophäen-Showcase: Seltenster Fund
                    if let rarest = stats.rarestSpot, let train = rarest.trainModel {
                        rarestCatchShowcase(spotted: rarest, train: train)
                    }
                    
                    // 3. Sammlungsfortschritt Gesamt
                    overallProgressCard
                    
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
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
        }
    }
    
    // MARK: - Components
    
    private var scoreHeroCard: some View {
        VStack(spacing: 12) {
            HStack {
                Label(stats.userRank.rawValue, systemImage: stats.userRank.icon)
                    .font(.caption.weight(.heavy))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(.white.opacity(0.2))
                    .clipShape(Capsule())
                
                Spacer()
                
                Text("LEVEL \(stats.level)")
                    .font(.caption2.weight(.heavy))
                    .foregroundStyle(.white.opacity(0.8))
                    .tracking(1)
            }
            
            VStack(spacing: 2) {
                Text("\(stats.totalScore)")
                    .font(.system(size: 52, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                
                Text("BAHN-PUNKTE (XP)")
                    .font(.caption2.weight(.bold))
                    .foregroundColor(.white.opacity(0.85))
                    .tracking(1.5)
            }
            .padding(.vertical, 4)
            
            Divider().background(.white.opacity(0.25))
            
            HStack {
                Label("\(stats.totalSpottings) Sichtungen", systemImage: "eye.fill")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.95))
                
                Spacer()
                
                Label("\(stats.uniqueTrainsSpotted) / \(stats.totalTrainsInCatalog) Zügen", systemImage: "checkmark.seal.fill")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.95))
            }
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [Color.orange, Color.red.opacity(0.9)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: Color.orange.opacity(0.3), radius: 12, y: 6)
    }
    
    private func rarestCatchShowcase(spotted: SpottedTrain, train: TrainModel) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            
            // Header Bar
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "trophy.fill")
                        .foregroundStyle(.yellow)
                    Text("SELTENSTER FUND")
                        .font(.caption2.weight(.heavy))
                        .foregroundStyle(.secondary)
                        .tracking(1)
                }
                Spacer()
                RarityBadgeView(rarity: train.rarity, style: .glowing)
            }
            .padding(.horizontal, 16)
            .padding(.top, 14)
            .padding(.bottom, 10)
            
            // Large Hero Image
            TrainImageView(assetName: train.assetName)
                .frame(height: 140)
                .frame(maxWidth: .infinity)
                .clipped()
            
            // Details Footer
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("\(train.seriesCode) - \(train.commercialName)")
                        .font(.headline.weight(.bold))
                    Spacer()
                    if let tz = spotted.tzNumber {
                        Text("Tz \(tz)")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.secondary)
                    }
                }
                
                if let location = spotted.stationOrLocationName {
                    HStack(spacing: 4) {
                        Image(systemName: "location.fill")
                            .font(.caption2)
                        Text(location)
                            .font(.caption)
                    }
                    .foregroundStyle(.secondary)
                }
            }
            .padding(14)
        }
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(train.rarity.color.opacity(0.4), lineWidth: 1.5)
        )
        .shadow(color: train.rarity.color.opacity(0.18), radius: 12, y: 6)
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
            
            Text("Entdecke noch \(stats.remainingTrains) Baureihen zur Vervollständigung.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(18)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
    
    private var categoryProgressSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Fortschritt nach Kategorien")
                .font(.headline)
                .padding(.horizontal, 4)
            
            ForEach(stats.categoryProgress) { cat in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Label(cat.category.rawValue, systemImage: cat.category.icon)
                            .font(.subheadline.weight(.medium))
                        Spacer()
                        Text("\(cat.spottedCount) / \(cat.totalCount)")
                            .font(.caption.weight(.bold))
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
        VStack(alignment: .leading, spacing: 12) {
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
                            .font(.title.weight(.heavy))
                            .foregroundStyle(.primary)
                        
                        Text("x gesichtet")
                            .font(.caption2.weight(.medium))
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
