import SwiftUI
import SwiftData
import MapKit

public struct SpottedHistoryView: View {
    @Query(sort: \SpottedTrain.spottedAt, order: .reverse) private var spottings: [SpottedTrain]
    @State private var viewMode: ViewMode = .list
    
    enum ViewMode: String, CaseIterable {
        case list = "Liste"
        case map = "Karte"
    }
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            Group {
                if spottings.isEmpty {
                    ContentUnavailableView(
                        "Noch keine Sichtungen",
                        systemImage: "tram",
                        description: Text("Nutze die Schnell-Sichtung am Bahnsteig, um deinen ersten Zug zu erfassen!")
                    )
                } else {
                    VStack(spacing: 0) {
                        Picker("Ansicht", selection: $viewMode) {
                            ForEach(ViewMode.allCases, id: \.self) { mode in
                                Text(mode.rawValue).tag(mode)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        
                        if viewMode == .list {
                            List {
                                ForEach(spottings) { spot in
                                    SpottingRow(spot: spot)
                                }
                            }
                            .listStyle(.insetGrouped)
                        } else {
                            Map {
                                ForEach(spottings) { spot in
                                    if let coord = spot.coordinate {
                                        Annotation(
                                            spot.trainModel?.seriesCode ?? "Zug",
                                            coordinate: coord
                                        ) {
                                            Image(systemName: "tram.fill")
                                                .padding(6)
                                                .background(spot.trainModel?.rarity.color ?? .accentColor)
                                                .foregroundColor(.white)
                                                .clipShape(Circle())
                                                .shadow(radius: 4)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Logbuch")
        }
    }
}

struct SpottingRow: View {
    let spot: SpottedTrain
    
    var body: some View {
        HStack(spacing: 14) {
            if let photoData = spot.photoData, let uiImage = UIImage(data: photoData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 54, height: 54)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill((spot.trainModel?.rarity.color ?? .gray).opacity(0.15))
                        .frame(width: 54, height: 54)
                    
                    Image(systemName: spot.trainModel?.assetName ?? "tram.fill")
                        .font(.title3)
                        .foregroundStyle(spot.trainModel?.rarity.color ?? .primary)
                }
            }
            
            VStack(alignment: .leading, spacing: 3) {
                HStack {
                    Text(spot.trainModel?.seriesCode ?? "Unbekannt")
                        .font(.headline)
                    Spacer()
                    if let rarity = spot.trainModel?.rarity {
                        RarityBadgeView(rarity: rarity, style: .minimal)
                    }
                }
                
                if let tz = spot.tzNumber {
                    Text("Tz: \(tz)")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.secondary)
                }
                
                HStack(spacing: 8) {
                    if let location = spot.stationOrLocationName {
                        Label(location, systemImage: "location")
                            .lineLimit(1)
                    }
                    Spacer()
                    Text(spot.spottedAt.formatted(date: .abbreviated, time: .shortened))
                }
                .font(.caption2)
                .foregroundStyle(.tertiary)
            }
        }
        .padding(.vertical, 4)
    }
}
