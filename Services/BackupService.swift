import Foundation
import SwiftData
import SwiftUI
import UniformTypeIdentifiers

public struct TrainSammlerBackup: Codable {
    public let schemaVersion: Int
    public let exportedAt: Date
    public let appVersion: String
    public let spottings: [SpottingBackupDTO]
    public let bingoGames: [BingoGameBackupDTO]
}

public struct SpottingBackupDTO: Codable {
    public let id: UUID
    public let spottedAt: Date
    public let tzNumber: String?
    public let latitude: Double?
    public let longitude: Double?
    public let stationOrLocationName: String?
    public let notes: String?
    public let trainSeriesCode: String?
    public let photoBase64: String?
}

public struct BingoGameBackupDTO: Codable {
    public let id: UUID
    public let startedAt: Date
    public let completedAt: Date?
    public let gridSize: Int
    public let travelTitle: String?
    public let isBingoAchieved: Bool
    public let cells: [BingoCellBackupDTO]
}

public struct BingoCellBackupDTO: Codable {
    public let id: UUID
    public let text: String
    public let iconName: String
    public let rarityRaw: String
    public let isChecked: Bool
    public let isJoker: Bool
    public let positionIndex: Int
    public let likelihoodPercent: Int
    public let category: String
}

public struct BackupFileDocument: FileDocument {
    public static var readableContentTypes: [UTType] { [.json] }

    public var data: Data

    public init(data: Data = Data()) {
        self.data = data
    }

    public init(configuration: ReadConfiguration) throws {
        self.data = configuration.file.regularFileContents ?? Data()
    }

    public func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: data)
    }
}

@MainActor
public enum BackupService {
    public struct ImportSummary {
        public let importedSpottings: Int
        public let importedBingos: Int
    }

    public static func createBackupData(
        spottings: [SpottedTrain],
        archivedBingos: [BingoGame]
    ) throws -> Data {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.9"

        let spottingDTOs = spottings.map { spot in
            SpottingBackupDTO(
                id: spot.id,
                spottedAt: spot.spottedAt,
                tzNumber: spot.tzNumber,
                latitude: spot.latitude,
                longitude: spot.longitude,
                stationOrLocationName: spot.stationOrLocationName,
                notes: spot.notes,
                trainSeriesCode: spot.trainModel?.seriesCode,
                photoBase64: spot.photoData?.base64EncodedString()
            )
        }

        let bingoDTOs = archivedBingos.map { game in
            BingoGameBackupDTO(
                id: game.id,
                startedAt: game.startedAt,
                completedAt: game.completedAt,
                gridSize: game.gridSize,
                travelTitle: game.travelTitle,
                isBingoAchieved: game.isBingoAchieved,
                cells: game.sortedCells.map { cell in
                    BingoCellBackupDTO(
                        id: cell.id,
                        text: cell.text,
                        iconName: cell.iconName,
                        rarityRaw: cell.rarityRaw,
                        isChecked: cell.isChecked,
                        isJoker: cell.isJoker,
                        positionIndex: cell.positionIndex,
                        likelihoodPercent: cell.likelihoodPercent,
                        category: cell.category
                    )
                }
            )
        }

        let backup = TrainSammlerBackup(
            schemaVersion: 1,
            exportedAt: Date(),
            appVersion: appVersion,
            spottings: spottingDTOs,
            bingoGames: bingoDTOs
        )

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return try encoder.encode(backup)
    }

    public static func importBackup(
        from data: Data,
        context: ModelContext
    ) throws -> ImportSummary {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let backup = try decoder.decode(TrainSammlerBackup.self, from: data)

        let existingTrains = (try? context.fetch(FetchDescriptor<TrainModel>())) ?? []
        let trainsBySeries = Dictionary(uniqueKeysWithValues: existingTrains.map { ($0.seriesCode, $0) })

        let existingSpottings = (try? context.fetch(FetchDescriptor<SpottedTrain>())) ?? []
        var existingSpottingIDs = Set(existingSpottings.map(\.id))

        let existingBingos = (try? context.fetch(FetchDescriptor<BingoGame>())) ?? []
        var existingBingoIDs = Set(existingBingos.map(\.id))

        var importedSpottings = 0
        for dto in backup.spottings where !existingSpottingIDs.contains(dto.id) {
            var decodedPhoto: Data? = nil
            if let base64 = dto.photoBase64, let rawData = Data(base64Encoded: base64) {
                decodedPhoto = ImageCompressor.compress(imageData: rawData) ?? rawData
            }

            let spot = SpottedTrain(
                id: dto.id,
                spottedAt: dto.spottedAt,
                tzNumber: dto.tzNumber,
                latitude: dto.latitude,
                longitude: dto.longitude,
                stationOrLocationName: dto.stationOrLocationName,
                photoData: decodedPhoto,
                notes: dto.notes,
                trainModel: dto.trainSeriesCode.flatMap { trainsBySeries[$0] }
            )
            context.insert(spot)
            existingSpottingIDs.insert(dto.id)
            importedSpottings += 1
        }

        var importedBingos = 0
        for dto in backup.bingoGames where !existingBingoIDs.contains(dto.id) {
            let cells = dto.cells.map { cellDTO in
                BingoCell(
                    id: cellDTO.id,
                    text: cellDTO.text,
                    iconName: cellDTO.iconName,
                    rarityRaw: cellDTO.rarityRaw,
                    isChecked: cellDTO.isChecked,
                    isJoker: cellDTO.isJoker,
                    positionIndex: cellDTO.positionIndex,
                    likelihoodPercent: cellDTO.likelihoodPercent,
                    category: cellDTO.category
                )
            }

            let game = BingoGame(
                id: dto.id,
                startedAt: dto.startedAt,
                completedAt: dto.completedAt ?? dto.startedAt,
                gridSize: dto.gridSize,
                travelTitle: dto.travelTitle,
                isBingoAchieved: dto.isBingoAchieved,
                isArchived: true,
                cells: cells
            )
            context.insert(game)
            existingBingoIDs.insert(dto.id)
            importedBingos += 1
        }

        try context.save()
        return ImportSummary(importedSpottings: importedSpottings, importedBingos: importedBingos)
    }
}
