import Foundation
import SwiftData

public struct DataSeeder {
    @MainActor
    public static func seedCatalogIfNeeded(context: ModelContext) {
        let descriptor = FetchDescriptor<TrainModel>()
        do {
            let count = try context.fetchCount(descriptor)
            guard count == 0 else { return }
            
            let defaultTrains: [TrainModel] = [
                // Legendary: Sonder-ICEs
                TrainModel(
                    seriesCode: "BR 403 (Tz 304)",
                    commercialName: "Regenbogen-ICE",
                    designation: "München",
                    rarity: .legendary,
                    category: .special,
                    overviewDescription: "Der berühmte ICE 3 mit Regenbogen-Zierstreifen für Toleranz und Vielfalt.",
                    assetName: "train.side.rear.car",
                    maxSpeedKmH: 330
                ),
                TrainModel(
                    seriesCode: "BR 406 (Tz 4601)",
                    commercialName: "Europa-ICE",
                    designation: "Europa / Frankfurt am Main",
                    rarity: .legendary,
                    category: .special,
                    overviewDescription: "ICE 3M Mehrsystemzug mit blauem Europa-Streifen und Europa-Sternen.",
                    assetName: "train.side.front.car",
                    maxSpeedKmH: 330
                ),
                TrainModel(
                    seriesCode: "BR 410",
                    commercialName: "ICE S",
                    designation: "Mess- & Erprobungszug",
                    rarity: .legendary,
                    category: .special,
                    overviewDescription: "Spezieller Hochgeschwindigkeits-Versuchszug von DB Systemtechnik.",
                    assetName: "bolt.badge.clock",
                    maxSpeedKmH: 393
                ),
                
                // Rare: Neueste & seltene Baureihen
                TrainModel(
                    seriesCode: "BR 408",
                    commercialName: "ICE 3neo",
                    designation: "Velaro MS",
                    rarity: .rare,
                    category: .highSpeed,
                    overviewDescription: "Die modernste Weiterentwicklung des ICE 3 mit mobilfunkdurchlässigen Scheiben und 320 km/h.",
                    assetName: "tram.fill",
                    maxSpeedKmH: 320
                ),
                TrainModel(
                    seriesCode: "BR 411 / BR 415",
                    commercialName: "ICE T",
                    designation: "Neigetechnik",
                    rarity: .rare,
                    category: .highSpeed,
                    overviewDescription: "Elektrischer Neigezug für kurvenreiche Strecken (z.B. Gäubahn, Saaletal).",
                    assetName: "arrow.triangle.swap",
                    maxSpeedKmH: 230
                ),
                
                // Uncommon: Etablierte Baureihen
                TrainModel(
                    seriesCode: "BR 407",
                    commercialName: "ICE 3 (Velaro D)",
                    designation: "Eurostar / Frankreich",
                    rarity: .uncommon,
                    category: .highSpeed,
                    overviewDescription: "Viersystem-ICE der 3. Generation von Siemens für Inlands- und Frankreich-Verkehr.",
                    assetName: "tram.fill",
                    maxSpeedKmH: 320
                ),
                TrainModel(
                    seriesCode: "BR 401",
                    commercialName: "ICE 1 (LDV)",
                    designation: "Lebensdauerverlängerung",
                    rarity: .uncommon,
                    category: .highSpeed,
                    overviewDescription: "Die Ikone seit 1991. Aufwändig modernisiert mit verkürzten 9-Wagen-Garnituren.",
                    assetName: "tram.fill",
                    maxSpeedKmH: 280
                ),
                TrainModel(
                    seriesCode: "BR 402",
                    commercialName: "ICE 2",
                    designation: "Halbzug mit Steuerwagen",
                    rarity: .uncommon,
                    category: .highSpeed,
                    overviewDescription: "Zweite Generation mit Flügelungskonzept für flexiblere Zugteilungen.",
                    assetName: "tram.fill",
                    maxSpeedKmH: 280
                ),
                
                // Common: Der Alltags-König
                TrainModel(
                    seriesCode: "BR 412",
                    commercialName: "ICE 4",
                    designation: "Rückgrat der DB",
                    rarity: .common,
                    category: .highSpeed,
                    overviewDescription: "Das moderne Arbeitspferd im DB-Fernverkehr als 7-, 12- oder 13-Teiler (XXL-ICE).",
                    assetName: "tram.fill",
                    maxSpeedKmH: 265
                ),
                TrainModel(
                    seriesCode: "BR 446 / BR 445",
                    commercialName: "Twindexx Vario",
                    designation: "Doppelstock-Triebzug",
                    rarity: .common,
                    category: .regional,
                    overviewDescription: "Elektrischer Doppelstocktriebzug von Bombardier für dichten Regional-Express-Verkehr.",
                    assetName: "tram",
                    maxSpeedKmH: 160
                )
            ]
            
            for train in defaultTrains {
                context.insert(train)
            }
            try context.save()
        } catch {
            print("Fehler beim Seeden des Katalogs: \(error.localizedDescription)")
        }
    }
}
