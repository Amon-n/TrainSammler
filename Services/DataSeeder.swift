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
                    overviewDescription: "Der berühmte ICE 3 mit sechsfarbigem Regenbogen-Zierstreifen für Toleranz, Vielfalt und Respekt auf deutschen Schienen.",
                    assetName: "ice_regenbogen",
                    maxSpeedKmH: 330
                ),
                TrainModel(
                    seriesCode: "BR 406 (Tz 4601)",
                    commercialName: "Europa-ICE",
                    designation: "Europa / Frankfurt am Main",
                    rarity: .legendary,
                    category: .special,
                    overviewDescription: "ICE 3M Mehrsystemzug mit blauem Europa-Streifen und Sternen als Botschafter für ein vereintes Europa.",
                    assetName: "ice_europa",
                    maxSpeedKmH: 320
                ),
                TrainModel(
                    seriesCode: "BR 412 (Tz 9457)",
                    commercialName: "ICE Bundesrepublik Deutschland",
                    designation: "Bundesrepublik Deutschland",
                    rarity: .legendary,
                    category: .special,
                    overviewDescription: "Feierlicher 13-teiliger Jubiläums-ICE 4 mit schwarz-rot-goldener Flaggen-Linierung an beiden Endwagen.",
                    assetName: "ice_4_brd",
                    maxSpeedKmH: 265
                ),
                TrainModel(
                    seriesCode: "BR 412 (Tz 9015)",
                    commercialName: "Female ICE",
                    designation: "Mainz",
                    rarity: .legendary,
                    category: .special,
                    overviewDescription: "Symbolzug für Frauenförderung im Schienenverkehr mit markanter Aktionsbeklebung am Triebkopf und Bordrestaurant.",
                    assetName: "ice_female_cab",
                    maxSpeedKmH: 265
                ),
                TrainModel(
                    seriesCode: "BR 410",
                    commercialName: "ICE S",
                    designation: "Mess- & Erprobungszug",
                    rarity: .legendary,
                    category: .special,
                    overviewDescription: "Hochgeschwindigkeits-Messzug der DB Systemtechnik für Streckenprüfungen und Stromabnehmer-Tests bis 393 km/h.",
                    assetName: "ice_s",
                    maxSpeedKmH: 393
                ),
                TrainModel(
                    seriesCode: "BR 605",
                    commercialName: "advanced TrainLab",
                    designation: "Fahrendes Digitallabor",
                    rarity: .legendary,
                    category: .special,
                    overviewDescription: "Ehemaliger dieselgetriebener ICE TD, der als Versuchsträger für Sensorik, Lidar, 5G und automatisiertes Fahren dient.",
                    assetName: "ice_605_trainlab",
                    maxSpeedKmH: 200
                ),
                
                // MARK: - 2. FERNVERKEHR / ICE, EC, RJ & LOKOMOTIVEN (High Speed)
                TrainModel(
                    seriesCode: "BR 408",
                    commercialName: "ICE 3neo",
                    designation: "Siemens Velaro MS",
                    rarity: .rare,
                    category: .highSpeed,
                    overviewDescription: "Neueste Viersystem-Weiterentwicklung der Siemens-Velaro-Plattform (15 kV / 25 kV AC, 1,5 kV / 3 kV DC) mit mobilfunkdurchlässigen Scheiben und neuem Innendesign.",
                    assetName: "ice_3neo",
                    maxSpeedKmH: 320
                ),
                TrainModel(
                    seriesCode: "BR 407",
                    commercialName: "ICE 3 (Velaro D)",
                    designation: "Mehrsystem-Sprinter",
                    rarity: .uncommon,
                    category: .highSpeed,
                    overviewDescription: "Viersystem-Hochgeschwindigkeitszug von Siemens für den internationalen Fernverkehr nach Frankreich und Belgien.",
                    assetName: "ice_3_velaro",
                    maxSpeedKmH: 320
                ),
                TrainModel(
                    seriesCode: "BR 403",
                    commercialName: "ICE 3 (1./2. Bauserie)",
                    designation: "Der Ur-Sprinter",
                    rarity: .uncommon,
                    category: .highSpeed,
                    overviewDescription: "Die Design-Ikone der Schnellfahrstrecke Köln–Rhein/Main mit Unterflurantrieb und Panorama-Lounge direkt hinter dem Führerstand.",
                    assetName: "ice_3_sfs",
                    maxSpeedKmH: 330
                ),
                TrainModel(
                    seriesCode: "BR 406",
                    commercialName: "ICE 3M",
                    designation: "Mehrsystem-Pionier",
                    rarity: .uncommon,
                    category: .highSpeed,
                    overviewDescription: "Erste internationale Mehrsystem-Variante des ICE 3 mit sechs Dachstromabnehmern für vier europäische Bahnstromsysteme.",
                    assetName: "ice_3m_multi",
                    maxSpeedKmH: 320
                ),
                TrainModel(
                    seriesCode: "BR 412",
                    commercialName: "ICE 4 (12-Teiler)",
                    designation: "Rückgrat des Fernverkehrs",
                    rarity: .common,
                    category: .highSpeed,
                    overviewDescription: "Das moderne Arbeitspferd im DB-Fernverkehr von Siemens mit modularem Powercar-Konzept und 28 Meter langen Großraumwagen.",
                    assetName: "ice_4",
                    maxSpeedKmH: 265
                ),
                TrainModel(
                    seriesCode: "BR 412 (XXL)",
                    commercialName: "ICE 4 XXL (13-Teiler)",
                    designation: "374-Meter-Kapazitätsriese",
                    rarity: .rare,
                    category: .highSpeed,
                    overviewDescription: "Längster Triebzug im DB-Netz (BR 412.4) mit 13 Wagen und 918 Sitzplätzen auf hochfrequentierten Nord-Süd-Magistralen.",
                    assetName: "ice_4_altengronau",
                    maxSpeedKmH: 265
                ),
                TrainModel(
                    seriesCode: "BR 412 (K7)",
                    commercialName: "ICE 4 (7-Teiler)",
                    designation: "Kurzzug / Flügelzug",
                    rarity: .uncommon,
                    category: .highSpeed,
                    overviewDescription: "Kompakte 7-Wagen-Ausführung (BR 412.2) des ICE 4 für bis zu 250 km/h, oft in Doppeltraktion oder auf Tagesrandlinien unterwegs.",
                    assetName: "ice_4_front",
                    maxSpeedKmH: 250
                ),
                TrainModel(
                    seriesCode: "BR 411",
                    commercialName: "ICE T (7-Teiler)",
                    designation: "Elektrischer Neigezug",
                    rarity: .rare,
                    category: .highSpeed,
                    overviewDescription: "Mit aktiver Neigetechnik ausgestatteter ICE für kurvenreiche Strecken in Mitteldeutschland und nach Österreich.",
                    assetName: "ice_t",
                    maxSpeedKmH: 230
                ),
                TrainModel(
                    seriesCode: "BR 415",
                    commercialName: "ICE T (5-Teiler)",
                    designation: "Kurzer Neigezug",
                    rarity: .rare,
                    category: .highSpeed,
                    overviewDescription: "Kürzere 5-Wagen-Variante des ICE T mit Neigetechnik für schnelle Verbindungen auf bogenreichen Hauptbahnen.",
                    assetName: "ice_t",
                    maxSpeedKmH: 230
                ),
                TrainModel(
                    seriesCode: "BR 401",
                    commercialName: "ICE 1 (LDV)",
                    designation: "Der Ur-ICE mit Buckelspeisewagen",
                    rarity: .uncommon,
                    category: .highSpeed,
                    overviewDescription: "Der Klassiker von 1991 mit zwei Triebköpfen und dem berühmten erhöhten Bordrestaurant, modernisiert als 9-Wagen-Zug.",
                    assetName: "ice_1",
                    maxSpeedKmH: 280
                ),
                TrainModel(
                    seriesCode: "BR 402",
                    commercialName: "ICE 2",
                    designation: "Halbzug mit Steuerwagen",
                    rarity: .uncommon,
                    category: .highSpeed,
                    overviewDescription: "Die 2. ICE-Generation mit einem Triebkopf und einem Steuerwagen (808), konzipiert für das Flügelzugkonzept.",
                    assetName: "ice_2",
                    maxSpeedKmH: 280
                ),
                TrainModel(
                    seriesCode: "BR 105",
                    commercialName: "ICE L",
                    designation: "Talgo 230 Niederflur",
                    rarity: .rare,
                    category: .highSpeed,
                    overviewDescription: "Neueste Generation stufenloser Fernverkehrszüge von Talgo mit Einzelrad-Fahrwerken, Steuerwagen und Mehrsystemlok BR 105.",
                    assetName: "ice_l_cab",
                    maxSpeedKmH: 230
                ),
                TrainModel(
                    seriesCode: "RABe 501",
                    commercialName: "SBB Giruno",
                    designation: "Stadler SMILE (EC 250)",
                    rarity: .rare,
                    category: .highSpeed,
                    overviewDescription: "Elfteiliger Schweizer Hochgeschwindigkeits-Niederflurtriebzug von Stadler Rail für den alpenquerenden Verkehr zwischen Deutschland, der Schweiz und Italien.",
                    assetName: "sbb_giruno_zurich",
                    maxSpeedKmH: 250
                ),
                TrainModel(
                    seriesCode: "RJ / BR 1116",
                    commercialName: "ÖBB Railjet",
                    designation: "Taurus & Viaggio Comfort",
                    rarity: .uncommon,
                    category: .highSpeed,
                    overviewDescription: "Hochgeschwindigkeits-Wendezug der Österreichischen Bundesbahnen (Siemens Viaggio Comfort & Rh 1116 „Taurus“) im DACH-Fernverkehr.",
                    assetName: "oebb_railjet",
                    maxSpeedKmH: 230
                ),
                TrainModel(
                    seriesCode: "BR 193",
                    commercialName: "Siemens Vectron",
                    designation: "Europas Universallokomotive",
                    rarity: .common,
                    category: .highSpeed,
                    overviewDescription: "Moderne Mehrsystem-Elektrolokomotive von Siemens Mobility vor internationalen EuroCity-, Nacht- und Güterzügen im gesamten DACH-Raum.",
                    assetName: "br_193_vectron",
                    maxSpeedKmH: 200
                ),
                TrainModel(
                    seriesCode: "BR 101",
                    commercialName: "Intercity 1 (BR 101)",
                    designation: "Drehstrom-Schnellzuglok",
                    rarity: .uncommon,
                    category: .highSpeed,
                    overviewDescription: "Die legendäre Hochleistungs-Schnellzuglokomotive von Adtranz vor klassischen Intercity- und EuroCity-Wagengarnituren.",
                    assetName: "br_101",
                    maxSpeedKmH: 220
                ),
                TrainModel(
                    seriesCode: "BR 146.5 / 147.5",
                    commercialName: "Intercity 2 (Twindexx)",
                    designation: "Doppelstock-Wendezug",
                    rarity: .common,
                    category: .highSpeed,
                    overviewDescription: "Weiß lackierter Bombardier-Doppelstock-Wendezug im Fernverkehrsdesign mit TRAXX-Lokomotive und Steuerwagen.",
                    assetName: "ic2_twindexx_cab",
                    maxSpeedKmH: 160
                ),
                TrainModel(
                    seriesCode: "BR 4110",
                    commercialName: "Intercity 2 (KISS)",
                    designation: "Stadler Dosto-Triebzug",
                    rarity: .rare,
                    category: .highSpeed,
                    overviewDescription: "Spurtschneller Doppelstock-Triebzug von Stadler Rail für 200 km/h mit markanter Front und hohem Reisekomfort.",
                    assetName: "ic2_kiss",
                    maxSpeedKmH: 200
                ),
                TrainModel(
                    seriesCode: "Nightjet Viaggio",
                    commercialName: "ÖBB Nightjet (NextGen)",
                    designation: "Siemens Viaggio Next Level",
                    rarity: .rare,
                    category: .highSpeed,
                    overviewDescription: "Siebenteilige Nachtzug-Generation von Siemens mit Steuerwagen, barrierefreiem Einstieg und innovativen Mini-Cabins.",
                    assetName: "nightjet_cab",
                    maxSpeedKmH: 230
                ),
                
                // MARK: - 3. REGIONALVERKEHR & S-BAHN (Regional)
                TrainModel(
                    seriesCode: "BR 462",
                    commercialName: "Siemens Desiro HC",
                    designation: "High Capacity (z. B. RRX)",
                    rarity: .uncommon,
                    category: .regional,
                    overviewDescription: "Teil-Doppelstocktriebzug von Siemens mit einstöckigen angetriebenen Endwagen und doppelstöckigen Mittelwagen (u. a. RRX, Franken-Thüringen-Express, Rheintalbahn).",
                    assetName: "desiro_hc",
                    maxSpeedKmH: 160
                ),
                TrainModel(
                    seriesCode: "BR 442",
                    commercialName: "Talent 2",
                    designation: "„Hamsterbacke“",
                    rarity: .common,
                    category: .regional,
                    overviewDescription: "Weitverbreiteter elektrischer Regional- und S-Bahn-Triebzug von Bombardier mit charakteristischer gewölbter Kopfform.",
                    assetName: "talent_2",
                    maxSpeedKmH: 160
                ),
                TrainModel(
                    seriesCode: "BR 1428 / 1429",
                    commercialName: "Stadler FLIRT 3",
                    designation: "Flinker Leichter Regionaltriebzug",
                    rarity: .common,
                    category: .regional,
                    overviewDescription: "Spurtschneller elektrischer Niederflurtriebzug von Stadler Rail (auch als BR 429 / 1430 / FLIRT 3 XL) im Regionalexpress- und S-Bahn-Dienst.",
                    assetName: "flirt_3",
                    maxSpeedKmH: 160
                ),
                TrainModel(
                    seriesCode: "BR 463",
                    commercialName: "Siemens Mireo",
                    designation: "Leichtbau-Regionaltriebzug",
                    rarity: .uncommon,
                    category: .regional,
                    overviewDescription: "Energieeffizienter Leichtbau-Triebzug von Siemens in Aluminium-Integralbauweise, auch als Batterie- (Plus B, BR 563) und Wasserstoffzug (Plus H) im Einsatz.",
                    assetName: "mireo",
                    maxSpeedKmH: 160
                ),
                TrainModel(
                    seriesCode: "BR 445 / 446",
                    commercialName: "Twindexx Vario (Regio)",
                    designation: "Doppelstock-Triebzug",
                    rarity: .common,
                    category: .regional,
                    overviewDescription: "Verkehrsroter oder im Landesdesign lackierter Doppelstock-Triebzug mit angetriebenen Endwagen für aufkommensstarke Regionallinien.",
                    assetName: "twindexx_vario",
                    maxSpeedKmH: 160
                ),
                TrainModel(
                    seriesCode: "BR 1440",
                    commercialName: "Coradia Continental",
                    designation: "„Grinsekatze“ (Alstom)",
                    rarity: .common,
                    category: .regional,
                    overviewDescription: "Elektrischer Niederflur-Triebzug von Alstom mit markanter Scheinwerferpartie und Dach-Antriebstechnik für S-Bahn- und Regionalnetze.",
                    assetName: "coradia_continental",
                    maxSpeedKmH: 160
                ),
                TrainModel(
                    seriesCode: "BR 622 / 648",
                    commercialName: "Coradia LINT",
                    designation: "Diesel-Regionaltriebwagen",
                    rarity: .common,
                    category: .regional,
                    overviewDescription: "Bewährter Dieseltriebwagen von Alstom (LINT 27 / 41 / 54 / 81) für nicht elektrifizierte Regional- und Nebenbahnen.",
                    assetName: "coradia_lint",
                    maxSpeedKmH: 140
                ),
                TrainModel(
                    seriesCode: "BR 423 / 430",
                    commercialName: "S-Bahn Triebzug",
                    designation: "Metropolen-S-Bahn",
                    rarity: .common,
                    category: .regional,
                    overviewDescription: "Vierteiliger S-Bahn-Triebzug mit 12 Einstiegstüren pro Seite für München, Frankfurt/Rhein-Main, Stuttgart und Köln.",
                    assetName: "et_423",
                    maxSpeedKmH: 140
                ),
                TrainModel(
                    seriesCode: "BR 425",
                    commercialName: "ET 425",
                    designation: "„Quietschie“",
                    rarity: .common,
                    category: .regional,
                    overviewDescription: "Klassischer Elektrotriebzug mit Jakobs-Drehgestellen und markantem Stromrichter-Klang im Regional- und S-Bahn-Verkehr.",
                    assetName: "et_425",
                    maxSpeedKmH: 160
                )
            ]
            
            if existingTrains.isEmpty {
                for train in defaultTrains {
                    context.insert(train)
                }
                try context.save()
                print("✅ Katalog mit \(defaultTrains.count) Zügen initialisiert!")
            } else {
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
                
                // 2. Bestehende Züge auf die neuesten Bild-Assets und technischen Daten synchronisieren
                let defaultMap = Dictionary(uniqueKeysWithValues: defaultTrains.map { ($0.seriesCode, $0) })
                for train in existingTrains {
                    if let updated = defaultMap[train.seriesCode] {
                        if train.assetName != updated.assetName {
                            train.assetName = updated.assetName
                            changesMade = true
                        }
                        if train.commercialName != updated.commercialName {
                            train.commercialName = updated.commercialName
                            changesMade = true
                        }
                        if train.designation != updated.designation {
                            train.designation = updated.designation
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
