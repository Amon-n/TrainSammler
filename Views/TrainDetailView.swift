import SwiftUI
import SwiftData

@MainActor
public struct TrainDetailView: View {
    let train: TrainModel
    var onSpotThisTrain: (() -> Void)? = nil
    @Environment(\.dismiss) private var dismiss
    
    public init(train: TrainModel, onSpotThisTrain: (() -> Void)? = nil) {
        self.train = train
        self.onSpotThisTrain = onSpotThisTrain
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // 1. Hero Image Header
                    ZStack(alignment: .bottomLeading) {
                        TrainImageView(assetName: train.assetName, isSilhouette: !train.isSpotted)
                            .frame(height: 220)
                            .clipped()
                        
                        LinearGradient(
                            colors: [.clear, .black.opacity(0.8)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(train.seriesCode)
                                    .font(.title.weight(.heavy))
                                    .foregroundColor(.white)
                                
                                Text(train.commercialName)
                                    .font(.headline)
                                    .foregroundColor(.white.opacity(0.9))
                            }
                            Spacer()
                            RarityBadgeView(rarity: train.rarity, style: train.rarity == .legendary ? .glowing : .standard)
                        }
                        .padding(16)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .padding(.horizontal, 16)
                    
                    // 2. Schnell-Fakten (Speed, Category, Status)
                    HStack(spacing: 12) {
                        if let speed = train.maxSpeedKmH {
                            FactPill(icon: "speedometer", title: "Top-Speed", value: "\(speed) km/h")
                        }
                        
                        FactPill(icon: train.category.icon, title: "Kategorie", value: train.category.rawValue.components(separatedBy: " ").first ?? "")
                        
                        FactPill(
                            icon: train.isSpotted ? "checkmark.seal.fill" : "lock.fill",
                            title: "Status",
                            value: train.isSpotted ? "\(train.spotCount)x Gespottet" : "Unentdeckt",
                            valueColor: train.isSpotted ? .green : .secondary
                        )
                    }
                    .padding(.horizontal, 16)
                    
                    // 3. Beschreibung & Details
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Über diesen Zug")
                            .font(.headline)
                        
                        Text(train.overviewDescription)
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .lineSpacing(4)
                        
                        if let desig = train.designation {
                            HStack {
                                Text("Besonderheit / Taufname:")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(.secondary)
                                Text(desig)
                                    .font(.subheadline.weight(.bold))
                                    .foregroundStyle(.primary)
                            }
                            .padding(.top, 4)
                        }
                    }
                    .padding(18)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .padding(.horizontal, 16)
                    
                    // 4. Deine Sichtungen
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Deine Sichtungen (\(train.spotCount))")
                            .font(.headline)
                            .padding(.horizontal, 16)
                        
                        if train.spottings.isEmpty {
                            VStack(spacing: 8) {
                                Image(systemName: "camera.viewfinder")
                                    .font(.largeTitle)
                                    .foregroundStyle(.secondary)
                                Text("Du hast diesen Zug noch nicht gesichtet.")
                                    .font(.subheadline.weight(.medium))
                                    .foregroundStyle(.secondary)
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
                    
                    // 5. Button: Zug jetzt spotten
                    Button {
                        dismiss()
                        onSpotThisTrain?()
                    } label: {
                        HStack {
                            Image(systemName: "bolt.fill")
                            Text("Diesen Zug jetzt spotten")
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
                    .padding(.top, 8)
                    .padding(.bottom, 24)
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
        }
    }
}

struct FactPill: View {
    let icon: String
    let title: String
    let value: String
    var valueColor: Color = .primary
    
    var body: some View {
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
