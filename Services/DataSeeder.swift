import Foundation
import SwiftData

public struct DataSeeder {
    @MainActor
    public static func seedCatalogIfNeeded(context: ModelContext) {
        let descriptor = FetchDescriptor<TrainModel>()
        do {
            let existingTrains = try context.fetch(descriptor)
            
            let defaultTrains: [TrainModel] = [
                // MARK: - 1. SONDER- & TESTZÜGE (Special & Legendary)
                TrainModel(
                    seriesCode: "BR 403 (Tz 304)",
                    commercialName: "Regenbogen-ICE",
                    designation: "München",
                    rarity: .legendary,
                    category: .special,
                    overviewDescription: "Der berühmte ICE 3 mit Regenbogen-Zierstreifen für Toleranz, Vielfalt und Respekt auf deutschen Schienen.",
                    assetName: "ice_regenbogen",
                    maxSpeedKmH: 330
                ),
                TrainModel(
                    seriesCode: "BR 406 (Tz 4601)",
                    commercialName: "Europa-ICE",
                    designation: "Europa / Frankfurt am Main",
                    rarity: .legendary,
                    category: .special,
                    overviewDescription: "ICE 3M Mehrsystemzug mit blauem Europa-Streifen und europäischen Sternen als Botschafter für ein vereintes Europa.",
                    assetName: "ice_europa",
                    maxSpeedKmH: 330
                ),
                TrainModel(
                    seriesCode: "BR 412 (Tz 9457)",
                    commercialName: "ICE Bundesrepublik Deutschland",
                    designation: "Bundesrepublik Deutschland",
                    rarity: .legendary,
                    category: .special,
                    overviewDescription: "Feierlicher Jubiläums-ICE 4 mit schwarz-rot-goldener Flaggen-Linierung an beiden Endwagen.",
                    assetName: "ice_4_brd",
                    maxSpeedKmH: 265
                ),
                TrainModel(
                    seriesCode: "BR 412 (Tz 9015)",
                    commercialName: "Female ICE",
                    designation: "Mainz",
                    rarity: .legendary,
                    category: .special,
                    overviewDescription: "Symbolzug für Frauenförderung im Schienenverkehr, der 2022 von einer rein weiblichen Besatzung pilotiert wurde.",
                    assetName: "ice_4",
                    maxSpeedKmH: 265
                ),
                TrainModel(
                    seriesCode: "BR 410",
                    commercialName: "ICE S",
                    designation: "Mess- & Erprobungszug",
                    rarity: .legendary,
                    category: .special,
                    overviewDescription: "Hochgeschwindigkeits-Messzug der DB Systemtechnik. Hielt mit 393 km/h zeitweise den deutschen Schienenrekord.",
                    assetName: "ice_s",
                    maxSpeedKmH: 393
                ),
                TrainModel(
                    seriesCode: "BR 605",
                    commercialName: "advanced TrainLab",
                    designation: "Fahrendes Digitallabor",
                    rarity: .legendary,
                    category: .special,
                    overviewDescription: "Ehemaliger dieselgetriebener ICE TD, der heute als Versuchsträger für Sensorik, 5G und automatisiertes Fahren dient.",
                    assetName: "ice_2",
                    maxSpeedKmH: 200
                ),
                
                // MARK: - 2. FERNVERKEHR / ICE & IC (High Speed)
                TrainModel(
                    seriesCode: "BR 408",
                    commercialName: "ICE 3neo",
                    designation: "Velaro MS",
                    rarity: .rare,
                    category: .highSpeed,
                    overviewDescription: "Modernste Weiterentwicklung der Siemens-Velaro-Plattform mit 320 km/h, mobilfunkdurchlässigen Scheiben und Fahrradstellplätzen.",
                    assetName: "ice_3neo",
                    maxSpeedKmH: 320
                ),
                TrainModel(
                    seriesCode: "BR 407",
                    commercialName: "ICE 3 (Velaro D)",
                    designation: "Eurostar / Frankreich",
                    rarity: .uncommon,
                    category: .highSpeed,
                    overviewDescription: "Viersystem-ICE der 3. Generation für den anspruchsvollen internationalen Verkehr nach Paris und Brüssel.",
                    assetName: "ice_3_velaro",
                    maxSpeedKmH: 320
                ),
                TrainModel(
                    seriesCode: "BR 403",
                    commercialName: "ICE 3 (1./2. Bauserie)",
                    designation: "Der Ur-Sprinter",
                    rarity: .uncommon,
                    category: .highSpeed,
                    overviewDescription: "Die Design-Ikone der Schnellfahrstrecke Köln–Rhein/Main mit Lounge-Blick direkt hinter dem Lokführer.",
                    assetName: "ice_3_velaro",
                    maxSpeedKmH: 330
                ),
                TrainModel(
                    seriesCode: "BR 406",
                    commercialName: "ICE 3M",
                    designation: "Mehrsystem-Triebzug",
                    rarity: .uncommon,
                    category: .highSpeed,
                    overviewDescription: "Internationale Variante des ICE 3 für Fahrten unter vier verschiedenen europäischen Bahnstromsystemen.",
                    assetName: "ice_europa",
                    maxSpeedKmH: 330
                ),
                TrainModel(
                    seriesCode: "BR 412",
                    commercialName: "ICE 4 (12-Teiler)",
                    designation: "Rückgrat der DB",
                    rarity: .common,
                    category: .highSpeed,
                    overviewDescription: "Das moderne Arbeitspferd im DB-Fernverkehr mit modularem Powercar-Konzept und hoher Energieeffizienz.",
                    assetName: "ice_4",
                    maxSpeedKmH: 265
                ),
                TrainModel(
                    seriesCode: "BR 412 (XXL)",
                    commercialName: "ICE 4 XXL (13-Teiler)",
                    designation: "374-Meter-Kapazitätsriese",
                    rarity: .rare,
                    category: .highSpeed,
                    overviewDescription: "Längster Triebzug im DB-Netz mit 13 Wagen und Platz für 918 Fahrgäste auf hochfrequentierten Magistralen.",
                    assetName: "ice_4",
                    maxSpeedKmH: 265
                ),
                TrainModel(
                    seriesCode: "BR 412 (K7)",
                    commercialName: "ICE 4 (7-Teiler)",
                    designation: "Kurzzug / Sprinter",
                    rarity: .uncommon,
                    category: .highSpeed,
                    overviewDescription: "Kurze 7-Wagen-Garnitur des ICE 4 für Linien mit mittlerer Nachfrage oder flexible Zugflügelung.",
                    assetName: "ice_4",
                    maxSpeedKmH: 265
                ),
                TrainModel(
                    seriesCode: "BR 411",
                    commercialName: "ICE T (7-Teiler)",
                    designation: "Elektrischer Neigezug",
                    rarity: .rare,
                    category: .highSpeed,
                    overviewDescription: "Mit Neigetechnik ausgestatteter ICE für bogenreiche Strecken wie die Gäubahn oder das Saaletal.",
                    assetName: "ice_t",
                    maxSpeedKmH: 230
                ),
                TrainModel(
                    seriesCode: "BR 415",
                    commercialName: "ICE T (5-Teiler)",
                    designation: "Kurzer Neigezug",
                    rarity: .rare,
                    category: .highSpeed,
                    overviewDescription: "Kürzere 5-Wagen-Ausführung des ICE T, häufig in Doppeltraktion oder auf grenzüberschreitenden Routen nach Österreich unterwegs.",
                    assetName: "ice_t",
                    maxSpeedKmH: 230
                ),
                TrainModel(
                    seriesCode: "BR 401",
                    commercialName: "ICE 1 (LDV)",
                    designation: "Lebensdauerverlängerung",
                    rarity: .uncommon,
                    category: .highSpeed,
                    overviewDescription: "Der Ur-ICE von 1991. Aufwändig modernisiert mit verkürzten 9-Wagen-Garnituren und zeitlosem Komfort.",
                    assetName: "ice_1",
                    maxSpeedKmH: 280
                ),
                TrainModel(
                    seriesCode: "BR 402",
                    commercialName: "ICE 2",
                    designation: "Halbzug mit Steuerwagen",
                    rarity: .uncommon,
                    category: .highSpeed,
                    overviewDescription: "Die 2. ICE-Generation mit Triebkopf und Steuerwagen, berühmt für das Flügelungskonzept in Hamm (Westf).",
                    assetName: "ice_2",
                    maxSpeedKmH: 280
                ),
                TrainModel(
                    seriesCode: "BR 105",
                    commercialName: "ICE L",
                    designation: "Talgo 230 Niederflur",
                    rarity: .rare,
                    category: .highSpeed,
                    overviewDescription: "Die neueste Generation barrierefreier Fernverkehrszüge von Talgo mit stufenlosem Einstieg für Urlauberlinien.",
                    assetName: "ice_l",
                    maxSpeedKmH: 230
                ),
                TrainModel(
                    seriesCode: "BR 101",
                    commercialName: "Intercity 1",
                    designation: "Lokbespannter Klassiker",
                    rarity: .uncommon,
                    category: .highSpeed,
                    overviewDescription: "Die legendäre Schnellzuglokomotive der 90er Jahre vor traditionellen Intercity-Wagengarnituren.",
                    assetName: "br_101",
                    maxSpeedKmH: 220
                ),
                TrainModel(
                    seriesCode: "BR 146.5 / 147.5",
                    commercialName: "Intercity 2 (Twindexx)",
                    designation: "Doppelstock-Intercity",
                    rarity: .common,
                    category: .highSpeed,
                    overviewDescription: "Weiß lackierter Bombardier-Doppelstockzug mit Lokomotive und Panoramablick aus dem Oberdeck.",
                    assetName: "twindexx_vario",
                    maxSpeedKmH: 160
                ),
                TrainModel(
                    seriesCode: "BR 4110",
                    commercialName: "Intercity 2 (KISS)",
                    designation: "Stadler Dosto-Triebzug",
                    rarity: .rare,
                    category: .highSpeed,
                    overviewDescription: "Ursprünglich für die österreichische WESTbahn gebaute, besonders spurtschnelle Doppelstock-Triebzüge auf der Gäubahn und Ostseeküste.",
                    assetName: "ic2_kiss",
                    maxSpeedKmH: 200
                ),
                TrainModel(
                    seriesCode: "Nightjet Viaggio",
                    commercialName: "ÖBB Nightjet",
                    designation: "Neuer Nachtzug der Zukunft",
                    rarity: .rare,
                    category: .highSpeed,
                    overviewDescription: "Hochmoderne Nachtzug-Garnituren von Siemens mit Mini-Cabins für ungestörten Schlaf quer durch Europa.",
                    assetName: "ice_3_velaro",
                    maxSpeedKmH: 230
                ),
                
                // MARK: - 3. REGIONALVERKEHR & S-BAHN (Regional)
                TrainModel(
                    seriesCode: "BR 462",
                    commercialName: "Siemens Desiro HC",
                    designation: "Rhein-Ruhr-Express (RRX)",
                    rarity: .uncommon,
                    category: .regional,
                    overviewDescription: "Teil-Doppelstocktriebzug mit einstöckigen Endwagen und doppelstöckigen Mittelwagen für hohe Fahrgastströme.",
                    assetName: "desiro_hc",
                    maxSpeedKmH: 160
                ),
                TrainModel(
                    seriesCode: "BR 442",
                    commercialName: "Talent 2",
                    designation: "„Hamsterbacke“",
                    rarity: .common,
                    category: .regional,
                    overviewDescription: "Charakteristischer Regionaltriebzug von Bombardier mit prägnantem Frontdesign, in ganz Deutschland im RE- und S-Bahn-Einsatz.",
                    assetName: "talent_2",
                    maxSpeedKmH: 160
                ),
                TrainModel(
                    seriesCode: "BR 1428 / 1429",
                    commercialName: "Stadler FLIRT 3",
                    designation: "Flinker Leichter Regionaltriebzug",
                    rarity: .common,
                    category: .regional,
                    overviewDescription: "Spurtschneller Niederflurtriebzug mit hervorragender Beschleunigung auf elektrifizierten Nahverkehrslinien.",
                    assetName: "flirt_3",
                    maxSpeedKmH: 160
                ),
                TrainModel(
                    seriesCode: "BR 463",
                    commercialName: "Siemens Mireo",
                    designation: "Leichtbau-Zukunftszug",
                    rarity: .uncommon,
                    category: .regional,
                    overviewDescription: "Extrem energieeffizienter, leichter Nahverkehrszug, auch als Batterie- (Plus B) und Wasserstoffvariante (Plus H) im Einsatz.",
                    assetName: "mireo",
                    maxSpeedKmH: 160
                ),
                TrainModel(
                    seriesCode: "BR 445 / 446",
                    commercialName: "Twindexx Vario",
                    designation: "Doppelstock-Triebzug",
                    rarity: .common,
                    category: .regional,
                    overviewDescription: "Bewährter Doppelstock-Triebzug der DB Regio für dichten Berufsverkehr in Ballungsräumen.",
                    assetName: "twindexx_vario",
                    maxSpeedKmH: 160
                ),
                TrainModel(
                    seriesCode: "BR 1440",
                    commercialName: "Coradia Continental",
                    designation: "Alstom Nahverkehrszug",
                    rarity: .common,
                    category: .regional,
                    overviewDescription: "Weitverbreiteter elektrischer Gelenktriebzug für S-Bahn-Netze (z. B. Breisgau, Hannover) und Regionalbahnen.",
                    assetName: "ice_2",
                    maxSpeedKmH: 160
                ),
                TrainModel(
                    seriesCode: "BR 622 / 648",
                    commercialName: "Coradia LINT",
                    designation: "Diesel-Regionalzug",
                    rarity: .common,
                    category: .regional,
                    overviewDescription: "Der unbestrittene König nicht elektrifizierter Nebenbahnen im ländlichen Raum Deutschlands.",
                    assetName: "coradia_lint",
                    maxSpeedKmH: 140
                ),
                TrainModel(
                    seriesCode: "BR 423 / 430",
                    commercialName: "S-Bahn Triebzug",
                    designation: "Metropolen-Express",
                    rarity: .common,
                    category: .regional,
                    overviewDescription: "Das unermüdliche Rückgrat der großen S-Bahn-Netze in München, Frankfurt am Main, Stuttgart und Köln.",
                    assetName: "et_423",
                    maxSpeedKmH: 140
                ),
                TrainModel(
                    seriesCode: "BR 425",
                    commercialName: "ET 425",
                    designation: "„Quietschie“",
                    rarity: .common,
                    category: .regional,
                    overviewDescription: "Kult-Regionalbahn mit unverwechselbarem Frequenzumrichter-Quietschen beim Anfahren.",
                    assetName: "et_425",
                    maxSpeedKmH: 160
                )
            ]
            
            if existingTrains.isEmpty {
                // Frische Datenbank: Alle Züge einfügen
                for train in defaultTrains {
                    context.insert(train)
                }
                try context.save()
                print("✅ Katalog mit \(defaultTrains.count) Zügen initialisiert!")
            } else {
                // Bestehende Datenbank: Neue Baureihen hinzufügen & Bilder aktualisieren
                let existingCodes = Set(existingTrains.map { $0.seriesCode })
                var changesMade = false
                
                // 1. Neue Züge aus dem Katalog ergänzen
                for defTrain in defaultTrains {
                    if !existingCodes.contains(defTrain.seriesCode) {
                        context.insert(defTrain)
                        changesMade = true
                        print("➕ Neue Baureihe ergänzt: \(defTrain.seriesCode)")
                    }
                }
                
                // 2. Bestehende Züge auf die neuesten Bild-Assets und Daten synchronisieren
                let defaultMap = Dictionary(uniqueKeysWithValues: defaultTrains.map { ($0.seriesCode, $0) })
                for train in existingTrains {
                    if let updated = defaultMap[train.seriesCode] {
                        if train.assetName != updated.assetName {
                            train.assetName = updated.assetName
                            changesMade = true
                        }
                        if train.overviewDescription != updated.overviewDescription {
                            train.overviewDescription = updated.overviewDescription
                            changesMade = true
                        }
                        if train.maxSpeedKmH != updated.maxSpeedKmH {
                            train.maxSpeedKmH = updated.maxSpeedKmH
                            changesMade = true
                        }
                    }
                }
                
                if changesMade {
                    try context.save()
                    print("✅ Katalog auf vollständige Sammlung (\(defaultTrains.count) Züge) aktualisiert!")
                }
            }
        } catch {
            print("Fehler beim Seeden des Katalogs: \(error.localizedDescription)")
        }
    }
}
