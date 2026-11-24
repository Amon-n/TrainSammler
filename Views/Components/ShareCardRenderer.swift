import SwiftUI
import UniformTypeIdentifiers

public struct ShareableCardImage: Transferable {
    public let uiImage: UIImage

    public init(uiImage: UIImage) {
        self.uiImage = uiImage
    }

    public static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .png) { item in
            item.uiImage.pngData() ?? Data()
        }
    }
}

public struct BingoShareCardView: View {
    public let game: BingoGame

    public init(game: BingoGame) {
        self.game = game
    }

    private var totalNonJoker: Int {
        game.cells.filter { !$0.isJoker }.count
    }

    public var body: some View {
        let size = game.gridSize
        let spacing: CGFloat = size == 5 ? 4 : 6
        let columns = Array(repeating: GridItem(.flexible(), spacing: spacing), count: size)
        let title = (game.travelTitle?.isEmpty == false) ? game.travelTitle! : "Meine Zugfahrt"

        VStack(alignment: .leading, spacing: 14) {
            // Header
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 3) {
                    Text("TRAINSAMMLER • DB-BINGO")
                        .font(.system(size: 10, weight: .heavy))
                        .foregroundStyle(.secondary)
                        .tracking(1.0)

                    Text(title)
                        .font(.title3.weight(.bold))
                        .foregroundStyle(.primary)
                        .lineLimit(1)

                    Text(game.startedAt.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    if game.isBingoAchieved {
                        Label("BINGO!", systemImage: "trophy.fill")
                            .font(.caption2.weight(.heavy))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.green, in: Capsule())
                    }

                    Text("\(game.checkedIncidentsCount)/\(totalNonJoker) • +\(game.earnedXP) XP")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(.orange)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.orange.opacity(0.14), in: Capsule())
                }
            }

            // Kompaktes Bingo-Brett
            LazyVGrid(columns: columns, spacing: spacing) {
                ForEach(game.sortedCells) { cell in
                    VStack(spacing: 3) {
                        Image(systemName: cell.iconName)
                            .font(.system(size: size == 5 ? 10 : 12, weight: .semibold))
                            .foregroundStyle(cell.isChecked ? .white : Color.accentColor)

                        Text(cell.isJoker ? "FREIFELD" : cell.text)
                            .font(.system(size: size == 5 ? 7.5 : (size == 4 ? 8.5 : 10), weight: cell.isChecked ? .semibold : .medium))
                            .multilineTextAlignment(.center)
                            .lineLimit(3)
                            .minimumScaleFactor(0.6)
                            .foregroundStyle(cell.isChecked ? .white : .primary)
                    }
                    .padding(4)
                    .frame(maxWidth: .infinity)
                    .frame(height: size == 5 ? 52 : (size == 4 ? 62 : 76))
                    .background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(
                                cell.isChecked
                                    ? (cell.isJoker ? Color.orange : Color.accentColor)
                                    : Color(uiColor: .secondarySystemBackground)
                            )
                    )
                }
            }
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color(uiColor: .tertiarySystemBackground))
            )

            // Footer
            HStack {
                Label("TrainSammler für iPhone", systemImage: "tram.fill")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(size)×\(size) Karte")
                    .font(.caption2.weight(.medium))
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(16)
        .frame(width: 360)
        .background(Color(uiColor: .systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(Color.primary.opacity(0.08), lineWidth: 1)
        )
    }
}

public struct SpottingShareCardView: View {
    public let spot: SpottedTrain

    public init(spot: SpottedTrain) {
        self.spot = spot
    }

    public var body: some View {
        let train = spot.trainModel
        let series = train?.seriesCode ?? "Zugsichtung"
        let commercial = train?.commercialName ?? "Deutsche Bahn / DACH"

        VStack(alignment: .leading, spacing: 12) {
            // Zug-Foto oder Katalog-Bild
            ZStack(alignment: .topLeading) {
                Group {
                    if let data = spot.photoData, let uiImg = UIImage(data: data) {
                        Image(uiImage: uiImg)
                            .resizable()
                            .scaledToFill()
                    } else if let asset = train?.assetName, let catalogImg = UIImage(named: asset) {
                        Image(uiImage: catalogImg)
                            .resizable()
                            .scaledToFill()
                    } else {
                        ZStack {
                            Color.secondary.opacity(0.12)
                            Image(systemName: "tram.fill")
                                .font(.system(size: 48))
                                .foregroundStyle(Color.accentColor)
                        }
                    }
                }
                .frame(width: 328, height: 190)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                if let rarity = train?.rarity {
                    RarityBadgeView(rarity: rarity, style: rarity == .legendary ? .glowing : .standard)
                        .padding(10)
                }
            }

            // Zug-Infos
            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .firstTextBaseline) {
                    Text(series)
                        .font(.title2.weight(.heavy))
                        .foregroundStyle(.primary)
                    Spacer()
                    if let normTz = SpottedTrain.normalizedTz(spot.tzNumber) {
                        Text("Tz \(normTz)")
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(.secondary)
                    }
                }

                Text(commercial)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.secondary)

                Divider()
                    .padding(.vertical, 4)

                HStack {
                    if let station = spot.stationOrLocationName {
                        Label(station, systemImage: "location.fill")
                            .lineLimit(1)
                    } else {
                        Label("Sichtung erfasst", systemImage: "checkmark.seal.fill")
                    }
                    Spacer()
                    Text(spot.spottedAt.formatted(date: .abbreviated, time: .shortened))
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }

            HStack {
                Label("TrainSammler", systemImage: "tram.fill")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(Color.accentColor)
                Spacer()
                Text("+\(spot.pointsEarned) XP")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.orange)
            }
        }
        .padding(16)
        .frame(width: 360)
        .background(Color(uiColor: .systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(Color.primary.opacity(0.08), lineWidth: 1)
        )
    }
}

@MainActor
public enum ShareCardRenderer {
    public static func renderBingoCard(game: BingoGame) -> ShareableCardImage? {
        let view = BingoShareCardView(game: game)
            .environment(\.colorScheme, .light)
        let renderer = ImageRenderer(content: view)
        renderer.scale = 3.0
        guard let image = renderer.uiImage else { return nil }
        return ShareableCardImage(uiImage: image)
    }

    public static func renderSpottingCard(spot: SpottedTrain) -> ShareableCardImage? {
        let view = SpottingShareCardView(spot: spot)
            .environment(\.colorScheme, .light)
        let renderer = ImageRenderer(content: view)
        renderer.scale = 3.0
        guard let image = renderer.uiImage else { return nil }
        return ShareableCardImage(uiImage: image)
    }
}
