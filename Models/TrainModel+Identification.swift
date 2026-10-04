import SwiftUI

/// Metadaten zu einem kuratierten Foto mit Erkennungsmerkmal und Lizenznachweis
public struct TrainPhotoDetail: Identifiable, Hashable, Sendable {
    public let id: String
    public let assetName: String
    public let label: String
    public let characteristicDescription: String
    public let photographer: String
    public let license: String
    public let commonsUrl: String?
    
    public init(
        assetName: String,
        label: String,
        characteristicDescription: String,
        photographer: String,
        license: String,
        commonsUrl: String? = nil
    ) {
        self.id = assetName
        self.assetName = assetName
        self.label = label
        self.characteristicDescription = characteristicDescription
        self.photographer = photographer
        self.license = license
        self.commonsUrl = commonsUrl
    }
}

public struct SpotterFeature: Identifiable, Sendable {
    public let id: String
    public let icon: String
    public let title: String
    public let description: String
    
    public init(icon: String, title: String, description: String) {
        self.id = title
        self.icon = icon
        self.title = title
        self.description = description
    }
}

extension TrainModel {
    /// Globaler Katalog aller kuratierten Fotos mit Bildrechten & Merkmalen
    public static let photoCatalog: [String: TrainPhotoDetail] = [
        "ice_regenbogen": TrainPhotoDetail(
            assetName: "ice_regenbogen",
            label: "Hauptansicht (Strecke)",
            characteristicDescription: "Der berühmte ICE 3 mit sechsfarbigem Regenbogen-Zierstreifen für Toleranz und Vielfalt.",
            photographer: "Johannes Maximilian",
            license: "CC BY-SA 4.0",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:DB_403_026_2024-08-02_JM_5D413719.jpg"
        ),
        "ice_regenbogen_detail": TrainPhotoDetail(
            assetName: "ice_regenbogen_detail",
            label: "Regenbogen-Zierstreifen & Front",
            characteristicDescription: "Der charakteristische sechsfarbige Streifen und die Haifischnase des Triebzuges 304 München.",
            photographer: "Jedesto",
            license: "CC BY-SA 4.0",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:Regenbogen-ICE_in_Stuttgart.jpg"
        ),
        "ice_europa": TrainPhotoDetail(
            assetName: "ice_europa",
            label: "Hauptansicht (Europa-Zierstreifen)",
            characteristicDescription: "ICE 3M Triebzug mit blauem Europa-Streifen und europäischen Sternen als Botschafter für ein vereintes Europa.",
            photographer: "LWChris",
            license: "CC BY 4.0",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:DB_406_501_2024-08-02_JM_5D413712.jpg"
        ),
        "ice_europa_detail": TrainPhotoDetail(
            assetName: "ice_europa_detail",
            label: "Europa-Sterne & Flagge",
            characteristicDescription: "Die europäischen Sterne und der blaue Kontraststreifen am Triebkopf von Tz 4601.",
            photographer: "universalamateur / LWChris",
            license: "CC BY-SA 4.0",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:ICE_%22Europa-Europe%22_End_2.jpg"
        ),
        "ice_4_brd": TrainPhotoDetail(
            assetName: "ice_4_brd",
            label: "Jubiläumsdesign (Schwarz-Rot-Gold)",
            characteristicDescription: "Feierlicher Jubiläums-ICE 4 mit schwarz-rot-goldener Flaggen-Linierung an beiden Endwagen.",
            photographer: "Geogast",
            license: "CC BY 4.0",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:ICE_Bundesrepublik_Deutschland.jpg"
        ),
        "ice_female_cab": TrainPhotoDetail(
            assetName: "ice_female_cab",
            label: "Female ICE Triebkopf",
            characteristicDescription: "Triebkopf Tz 9015 Mainz mit der auffälligen Female-ICE-Symbolbeklebung.",
            photographer: "Foobian",
            license: "CC BY-SA 4.0",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:Female_ICE_driving_end.jpg"
        ),
        "ice_female_restaurant": TrainPhotoDetail(
            assetName: "ice_female_restaurant",
            label: "Bordrestaurant Tz 9015",
            characteristicDescription: "Speisewagen mit besonderem Aktionsdesign zur Frauenförderung im Schienenverkehr.",
            photographer: "Foobian",
            license: "CC BY-SA 4.0",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:Female_ICE_Bordrestaurant.jpg"
        ),
        "ice_s": TrainPhotoDetail(
            assetName: "ice_s",
            label: "Hochgeschwindigkeits-Messzug",
            characteristicDescription: "Erprobungszug der DB Systemtechnik für Geschwindigkeiten bis 393 km/h.",
            photographer: "Bvcmz248.5 / DB Systemtechnik",
            license: "CC0 / Public Domain",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:ICE_S_410.jpg"
        ),
        "ice_s_run": TrainPhotoDetail(
            assetName: "ice_s_run",
            label: "Messfahrt bei 300+ km/h",
            characteristicDescription: "Erprobungszug der DB Systemtechnik bei einer Hochgeschwindigkeits-Testfahrt auf der Schnellfahrstrecke.",
            photographer: "Sebastian Terfloth User:Sese_Ingolstadt",
            license: "CC BY-SA 4.0",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:ICE_S_Geisbergtunnel.jpg"
        ),
        "ice_605_trainlab": TrainPhotoDetail(
            assetName: "ice_605_trainlab",
            label: "Fahrendes Digitallabor",
            characteristicDescription: "Ehemaliger dieselgetriebener ICE-TD mit Kameras, Lidar und Sensoren am Triebkopf.",
            photographer: "Anton B. Krüger",
            license: "CC BY-SA 4.0",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:Das_advanced_TrainLab_mit_Sensorik_am_Endwagen.jpg"
        ),
        "ice_605_sensors": TrainPhotoDetail(
            assetName: "ice_605_sensors",
            label: "Messfahrt & Sensorik",
            characteristicDescription: "Ehemaliger ICE-TD Triebzug bei der Sensor-Erprobung mit 5G-Antennen auf freier Strecke.",
            photographer: "Bybbisch94, Christian Gebhardt",
            license: "CC BY-SA 4.0",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:20230916.Advanced_TrainLab.-011.jpg"
        ),
        "ice_1": TrainPhotoDetail(
            assetName: "ice_1",
            label: "Hauptansicht (Berlin Hbf)",
            characteristicDescription: "Der Ur-ICE von 1991 im Jubiläumsdesign bei der Ausfahrt aus Berlin Hbf.",
            photographer: "Matti Blume",
            license: "CC BY-SA 4.0",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:ICE_1_Berlin_Hbf.jpg"
        ),
        "ice_1_powerhead": TrainPhotoDetail(
            assetName: "ice_1_powerhead",
            label: "Klassischer Triebkopf",
            characteristicDescription: "Charakteristische, geschwungene Nase des Triebkopfes 401 mit DB-Keks ohne Fronttüren.",
            photographer: "Yannick Bammert",
            license: "CC BY 2.0",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:Triebkopf_ICE_1_(4872423367).jpg"
        ),
        "ice_1_restaurant": TrainPhotoDetail(
            assetName: "ice_1_restaurant",
            label: "Buckelspeisewagen",
            characteristicDescription: "Das unverkennbare Bordrestaurant mit erhöhtem Dach – das absolute Wahrzeichen des ICE 1.",
            photographer: "Ra Boe / Wikipedia",
            license: "CC BY-SA 3.0 de",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:Deutsche_Bahn_ICE_2020_-DBAG_Class_401_Speisewagen-_by_RaBoe00102.jpg"
        ),
        "ice_1_interior": TrainPhotoDetail(
            assetName: "ice_1_interior",
            label: "Fahrgastabteil Redesign",
            characteristicDescription: "Modernisierter Fahrgastraum im Lebensdauerverlängerungs-Programm (LDV).",
            photographer: "MaxEmanuel",
            license: "CC0 / Public Domain",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:ICE_1-Abteil_zweiter_Klasse_nach_zweitem_Redesign.jpg"
        ),
        "ice_2": TrainPhotoDetail(
            assetName: "ice_2",
            label: "Hauptansicht (Berlin Hbf)",
            characteristicDescription: "Halbzug mit Triebkopf und Steuerwagen für das flexible Flügelungskonzept.",
            photographer: "RAIL P / Matti Blume",
            license: "CC0 / CC BY-SA 4.0",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:ICE_2_Berlin_Hbf.jpg"
        ),
        "ice_2_cab": TrainPhotoDetail(
            assetName: "ice_2_cab",
            label: "Steuerwagen 808 Front",
            characteristicDescription: "Der Steuerwagen mit integriertem Führerstand und Fahrgastabteil am Zugende.",
            photographer: "Falk2",
            license: "CC BY-SA 4.0",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:J33_160_Bf_Hannover_Hbf,_808_003.jpg"
        ),
        "ice_2_front": TrainPhotoDetail(
            assetName: "ice_2_front",
            label: "Fahrgastraum Steuerwagen",
            characteristicDescription: "Reiseabteil im Steuerwagen mit charakteristischer Deckenbeleuchtung und bequemen Sitzen.",
            photographer: "L. Willms",
            license: "CC BY 3.0",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:Passenger_compartment_of_an_ICE-2_driving_van_trailer.jpg"
        ),
        "ice_3_sfs": TrainPhotoDetail(
            assetName: "ice_3_sfs",
            label: "Schnellfahrstrecke 300 km/h",
            characteristicDescription: "Der Hochgeschwindigkeits-Klassiker mit 300 km/h auf der KRM-Neubaustrecke bei Weilbach.",
            photographer: "Mylius / Joachim Seyferth",
            license: "CC BY-SA 3.0",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:ICE_3_auf_der_Schnellfahrstrecke_K%C3%B6ln_-_Rhein-Main_bei_Weilbach.jpg"
        ),
        "ice_3_lounge": TrainPhotoDetail(
            assetName: "ice_3_lounge",
            label: "Lounge mit Lokführerblick",
            characteristicDescription: "Einzigartiger Lounge-Blick durch die Panoramascheibe direkt auf die Strecke.",
            photographer: "Sebastian Terfloth User:Sese_Ingolstadt",
            license: "CC BY-SA 3.0",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:Lounge_ICE_3.jpg"
        ),
        "ice_3m_multi": TrainPhotoDetail(
            assetName: "ice_3m_multi",
            label: "Mehrsystem-Dachausrüstung",
            characteristicDescription: "Vier verschiedene Dachstromabnehmer für Bahnstrom in Deutschland, Frankreich, Belgien und den Niederlanden.",
            photographer: "InterCityExpress / Felix O",
            license: "CC BY-SA 2.0",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:406_001_-_DB_Fernverkehr_--_Eschweiler_-_2._April_2014_(14304734175).jpg"
        ),
        "ice_3_velaro": TrainPhotoDetail(
            assetName: "ice_3_velaro",
            label: "Aerodynamische Front",
            characteristicDescription: "Fließende Velaro-Kopfform für minimalen Luftwiderstand und internationale Zulassung.",
            photographer: "Stephan Preißler",
            license: "CC BY-SA 3.0",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:DBAG_Class_407.jpg"
        ),
        "ice_407_interior": TrainPhotoDetail(
            assetName: "ice_407_interior",
            label: "Velaro D Fahrgastraum",
            characteristicDescription: "Moderne 2. Klasse des Siemens Velaro D mit ergonomischen Sitzen und Deckenmonitoren.",
            photographer: "Florian Bausch",
            license: "CC BY-SA 3.0",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:DBAG_Class_407_interior_2nd_2014-01.jpg"
        ),
        "ice_3neo": TrainPhotoDetail(
            assetName: "ice_3neo",
            label: "Hauptansicht (Köln Messe/Deutz)",
            characteristicDescription: "Modernste Weiterentwicklung der Siemens-Velaro-Plattform mit 320 km/h.",
            photographer: "TheFrog001",
            license: "CC0 / Public Domain",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:ICE_3neo_DB_408.jpg"
        ),
        "ice_3neo_interior": TrainPhotoDetail(
            assetName: "ice_3neo_interior",
            label: "Neues DB-Innendesign",
            characteristicDescription: "Neues Designkonzept der Deutschen Bahn mit Holztönen, warmen Stoffen und Tablet-Haltern.",
            photographer: "MaxEmanuel",
            license: "CC0 / Public Domain",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:DBAG_Class_408_Interior.jpg"
        ),
        "ice_t": TrainPhotoDetail(
            assetName: "ice_t",
            label: "Streckenfahrt (Maria Anzbach)",
            characteristicDescription: "Mit Neigetechnik ausgestatteter ICE für bogenreiche Strecken.",
            photographer: "Linie29",
            license: "CC BY-SA 4.0",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:DB_Class_411_ICE-T.jpg"
        ),
        "ice_4": TrainPhotoDetail(
            assetName: "ice_4",
            label: "Hauptansicht (Berlin Hbf)",
            characteristicDescription: "Das moderne Arbeitspferd im DB-Fernverkehr mit hoher Energieeffizienz.",
            photographer: "Peter Nath / Reinhold Möller",
            license: "CC BY 4.0",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:ICE_4_Berlin_Hbf.jpg"
        ),
        "ice_4_front": TrainPhotoDetail(
            assetName: "ice_4_front",
            label: "Kantige Frontpartie",
            characteristicDescription: "Die markante, kantig-aerodynamische Kopfform der Baureihe 412 mit LED-Lichtband.",
            photographer: "Martin Lechler",
            license: "CC BY-SA 4.0",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:ICE4_Front.jpg"
        ),
        "ice_4_altengronau": TrainPhotoDetail(
            assetName: "ice_4_altengronau",
            label: "Streckenfahrt bei Altengronau",
            characteristicDescription: "Moderne Zugbildung im Hochgeschwindigkeits-Netz der DB in Hessen.",
            photographer: "Joachim Seyferth",
            license: "CC BY 4.0",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:ICE_4_Altengronau.jpg"
        ),
        "ice_4_interior": TrainPhotoDetail(
            assetName: "ice_4_interior",
            label: "ICE 4 Fahrgastbereich",
            characteristicDescription: "Großzügiger Fahrgastraum mit flexibler Sitzplatzanordnung und modernem Raumklima.",
            photographer: "Robot8A / Joachim Seyferth",
            license: "CC BY-SA 4.0",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:ICE_4_(29690076593).jpg"
        ),
        "ice_l": TrainPhotoDetail(
            assetName: "ice_l",
            label: "Lokomotive 105 019",
            characteristicDescription: "Lokomotive der neuesten Generation barrierefreier Fernverkehrszüge von Talgo.",
            photographer: "Sven-IngCH",
            license: "CC BY-SA 4.0",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:ICE_L_105.jpg"
        ),
        "ice_l_cab": TrainPhotoDetail(
            assetName: "ice_l_cab",
            label: "ICE L Steuerwagen",
            characteristicDescription: "Modernster Steuerwagen von Talgo für den Wendezugbetrieb auf Urlaubsstrecken.",
            photographer: "E235JREMU",
            license: "CC BY-SA 4.0",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:ICE_L_SteuerwagenLV_12.23.jpg"
        ),
        "ice_l_side": TrainPhotoDetail(
            assetName: "ice_l_side",
            label: "Talgo-Niederflurwagen",
            characteristicDescription: "Stufenloser Einstieg direkt auf Höhe der Standardbahnsteige.",
            photographer: "Sven-IngCH",
            license: "CC BY-SA 4.0",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:ICE_L_Talgo.jpg"
        ),
        "ice_l_interior": TrainPhotoDetail(
            assetName: "ice_l_interior",
            label: "Stufenloser Niederflur-Einstieg",
            characteristicDescription: "Barrierefreier Fahrgastraum mit ebenem Boden ohne Stufen zwischen den Wagen.",
            photographer: "Pablo Lopez Estape",
            license: "CC BY-SA 4.0",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:Talgo_230_DB_ICE-L_at_InnoTrans_2022_05.jpg"
        ),
        "br_101": TrainPhotoDetail(
            assetName: "br_101",
            label: "Hauptansicht Streckenlok",
            characteristicDescription: "Die legendäre Schnellzuglokomotive der 90er Jahre vor traditionellen Intercity-Wagen.",
            photographer: "Lars Steffens",
            license: "CC BY-SA 2.0",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:DB_Class_101.jpg"
        ),
        "br_101_cab": TrainPhotoDetail(
            assetName: "br_101_cab",
            label: "BR 101 Führerstand",
            characteristicDescription: "Echter Führertisch der Baureihe 101 mit Fahrschalter, Ebula-Display und MFA-Instrumenten.",
            photographer: "Sebastian Terfloth User:Sese_Ingolstadt",
            license: "CC BY 2.5",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:DB_AG_101_F%C3%BChrerstand.jpg"
        ),
        "twindexx_vario": TrainPhotoDetail(
            assetName: "twindexx_vario",
            label: "Doppelstock-Wendezug",
            characteristicDescription: "Doppelstock-Garnitur mit Panoramablick aus dem oberen Stockwerk.",
            photographer: "UMO1 / Foobian",
            license: "CC BY-SA 4.0",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:Twindexx_Vario.jpg"
        ),
        "ic2_twindexx_cab": TrainPhotoDetail(
            assetName: "ic2_twindexx_cab",
            label: "Weißer IC2 Steuerwagen",
            characteristicDescription: "Weiß lackierter Doppelstock-Steuerwagen im ICE-Farbkleid mit spitzer Nase.",
            photographer: "Falk2",
            license: "CC BY-SA 4.0",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:J24_331_Sch%C3%B6nefelder_Gruppe,_DBpbzfa_668.2.jpg"
        ),
        "ic2_kiss": TrainPhotoDetail(
            assetName: "ic2_kiss",
            label: "Stadler KISS auf Strecke",
            characteristicDescription: "Spurtschneller Doppelstock-Triebzug aus der Schweiz im Intercity-Dienst.",
            photographer: "Mirkone",
            license: "CC BY-SA 4.0",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:Stadler_KISS_DB_4110.jpg"
        ),
        "ic2_kiss_front": TrainPhotoDetail(
            assetName: "ic2_kiss_front",
            label: "Stadler KISS Front",
            characteristicDescription: "Kraftvoller Doppelstock-Triebkopf des Schweizer Herstellers Stadler im DB-Fernverkehr.",
            photographer: "Zug Videos Bilder",
            license: "CC BY-SA 4.0",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:4110_110(2)_Kiss.jpg"
        ),
        "ic2_kiss_wien": TrainPhotoDetail(
            assetName: "ic2_kiss_wien",
            label: "BR 4110 Doppelstockzug",
            characteristicDescription: "Spurtschneller 6-teiliger Doppelstock-Triebzug am Bahnsteig.",
            photographer: "Rosso Robot",
            license: "CC BY-SA 4.0",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:2021-06-18_Stadler_KISS_BR_4110_at_Wien_Hauptbahnhof.jpg"
        ),
        "nightjet_viaggio": TrainPhotoDetail(
            assetName: "nightjet_viaggio",
            label: "ÖBB Nightjet (Viaggio)",
            characteristicDescription: "Neuer Nachtzug der Zukunft im charakteristischen nachtblauen Siemens-Design.",
            photographer: "TheFrog001",
            license: "CC0 / Public Domain",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:Siemens_Viaggio_Next_Level_%C3%96BB_nightjet_2023-12_-_05.jpg"
        ),
        "nightjet_cab": TrainPhotoDetail(
            assetName: "nightjet_cab",
            label: "Nightjet Steuerwagen",
            characteristicDescription: "Aerodynamischer Steuerwagen für den schnellen Wendezugbetrieb bei 230 km/h.",
            photographer: "TheFrog001",
            license: "CC0 / Public Domain",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:Steuerwagen_Siemens_Viaggio_Next_Level_%C3%96BB_nightjet_2023-12_-_03.jpg"
        ),
        "nightjet_minicabin": TrainPhotoDetail(
            assetName: "nightjet_minicabin",
            label: "Mini-Cabin Schlafkapseln",
            characteristicDescription: "Die revolutionären Mini-Cabins für ungestörten Schlaf von Alleinreisenden im Nachtzug.",
            photographer: "TheFrog001",
            license: "CC0 / Public Domain",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:Mini_cabin_coach_of_Siemens_Viaggio_Next_Level_%C3%96BB_nightjet_2023-12_-_06.jpg"
        ),
        "desiro_hc": TrainPhotoDetail(
            assetName: "desiro_hc",
            label: "Hauptansicht (Wuppertal Hbf)",
            characteristicDescription: "Rhein-Ruhr-Express Triebzug im modernen RRX-Farbdesign.",
            photographer: "Gsadfaw1223",
            license: "CC BY-SA 4.0",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:Siemens_Desiro_HC_RRX.jpg"
        ),
        "desiro_hc_hybrid": TrainPhotoDetail(
            assetName: "desiro_hc_hybrid",
            label: "Hybrid-Wagenzug (Dosto & Flach)",
            characteristicDescription: "Übergang vom einstöckigen Endwagen zum doppelstöckigen Mittelwagen – die Besonderheit des Desiro HC.",
            photographer: "Falk2",
            license: "CC BY-SA 4.0",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:J33_779_Desiro_HC_(462_083).jpg"
        ),
        "desiro_hc_interior": TrainPhotoDetail(
            assetName: "desiro_hc_interior",
            label: "RRX Fahrgastraum",
            characteristicDescription: "Moderner Rhein-Ruhr-Express Innenraum mit Steckdosen, Monitoren und Leselampen.",
            photographer: "Sacrety",
            license: "CC BY-SA 4.0",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:RRX_2.Klasse.jpg"
        ),
        "talent_2": TrainPhotoDetail(
            assetName: "talent_2",
            label: "Hauptansicht (Hennigsdorf)",
            characteristicDescription: "Charakteristischer Regionaltriebzug von Bombardier im RE- und S-Bahn-Einsatz.",
            photographer: "Sebastian Rittau",
            license: "CC0 / Public Domain",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:Bombardier_Talent_2.jpg"
        ),
        "talent_2_front": TrainPhotoDetail(
            assetName: "talent_2_front",
            label: "Charakteristische Hamsterbacke",
            characteristicDescription: "Die prägnante, tiefgezogene Kopfform, die dem Bombardier Talent 2 seinen Kult-Kosenamen gab.",
            photographer: "Matti Blume",
            license: "CC BY-SA 4.0",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:Talent,_Stralsund_(LRM_20240104_140825).jpg"
        ),
        "talent_2_interior": TrainPhotoDetail(
            assetName: "talent_2_interior",
            label: "Fahrgastraum & Niederflur",
            characteristicDescription: "Niederfluriger Einstiegsbereich mit Jakobs-Drehgestellübergang und bequemen Sitzen.",
            photographer: "Falk2",
            license: "CC BY-SA 4.0",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:I11_333_Bombardier_Talent_2,_Innenraum.jpg"
        ),
        "flirt_3": TrainPhotoDetail(
            assetName: "flirt_3",
            label: "Hauptansicht Streckenfahrt",
            characteristicDescription: "Spurtschneller Niederflurtriebzug mit hervorragender Beschleunigung.",
            photographer: "Johannes Maximilian",
            license: "CC BY-SA 4.0",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:Stadler_FLIRT_3.jpg"
        ),
        "flirt_3_front": TrainPhotoDetail(
            assetName: "flirt_3_front",
            label: "FLIRT 3 Frontpartie",
            characteristicDescription: "Markante, kantige Stadler-FLIRT-Kopfform im schnittigen SÜWEX-Design mit LED-Leuchten.",
            photographer: "Hoff1980",
            license: "CC BY-SA 3.0",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:S%C3%BCwex_Flirt_Mannheim_Hbf.JPG"
        ),
        "flirt_3_interior": TrainPhotoDetail(
            assetName: "flirt_3_interior",
            label: "Großraum-Fahrgastabteil",
            characteristicDescription: "Heller, stufenloser Innenraum mit Jakobs-Gelenken und Panoramaverglasung.",
            photographer: "JoachimKohler-HB",
            license: "CC BY-SA 4.0",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:Fahrgastraum_eines_Stadler_FLIRT_3_XL_der_NWB_(2024).jpg"
        ),
        "mireo": TrainPhotoDetail(
            assetName: "mireo",
            label: "Hauptansicht Neufahrzeug",
            characteristicDescription: "Extrem energieeffizienter, leichter Nahverkehrszug.",
            photographer: "Joachim Lutz",
            license: "CC BY-SA 4.0",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:Siemens_Mireo.jpg"
        ),
        "mireo_front": TrainPhotoDetail(
            assetName: "mireo_front",
            label: "Mireo Aerodynamik-Front",
            characteristicDescription: "Energieeffiziente, windschnittige Kopfform der Siemens-Mireo-Familie im bwegt-Design.",
            photographer: "Kevin.B",
            license: "CC BY-SA 4.0",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:Mireo_Bwegt_-_Offenburg.jpg"
        ),
        "mireo_interior": TrainPhotoDetail(
            assetName: "mireo_interior",
            label: "Mireo Fahrgastraum",
            characteristicDescription: "Großzügiges Leichtbau-Fahrgastabteil mit moderner LED-Ambientebeleuchtung.",
            photographer: "MireoDriver",
            license: "CC BY-SA 4.0",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:FahrgastraumMireoNetz4.jpg"
        ),
        "twindexx_regio_cab": TrainPhotoDetail(
            assetName: "twindexx_regio_cab",
            label: "Twindexx Vario Triebwagen",
            characteristicDescription: "Angetriebener Doppelstock-Endwagen (BR 445) mit vollwertigem Antrieb unter den Drehgestellen.",
            photographer: "Malte Hübner",
            license: "CC BY-SA 4.0",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:Twindexx_445_013_Nortorf.jpg"
        ),
        "coradia_continental": TrainPhotoDetail(
            assetName: "coradia_continental",
            label: "Coradia Continental (BR 1440)",
            characteristicDescription: "Elektrischer Triebzug mit dem markanten, freundlichen Frontlächeln („Grinsekatze“).",
            photographer: "Metrophil44",
            license: "CC BY-SA 4.0",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:DB-Baureihe_1440-Alstom_Coradia_Continental_in_Hagen_Hbf.jpg"
        ),
        "coradia_continental_front": TrainPhotoDetail(
            assetName: "coradia_continental_front",
            label: "Grinsekatze Frontpartie",
            characteristicDescription: "Geschwungene Scheinwerfermaske und aerodynamische Kopfform der Baureihe 1440.",
            photographer: "Der Messer",
            license: "CC BY-SA 4.0",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:Alstom_Coradia_Continental_(1440)_am_Bw_Aachen.jpg"
        ),
        "coradia_lint": TrainPhotoDetail(
            assetName: "coradia_lint",
            label: "Streckenfahrt LINT 27",
            characteristicDescription: "Der unbestrittene König nicht elektrifizierter Nebenbahnen im ländlichen Raum.",
            photographer: "Spudgun67",
            license: "CC BY-SA 4.0",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:Alstom_Coradia_LINT.jpg"
        ),
        "coradia_lint_front": TrainPhotoDetail(
            assetName: "coradia_lint_front",
            label: "LINT Triebwagen-Front",
            characteristicDescription: "Charakteristische Nahverkehrs-Diesel-Front mit hochgesetzter Scheibe und Scharfenbergkupplung.",
            photographer: "EM311",
            license: "CC BY-SA 4.0",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:DB_Regio_623_505_Alstom_Coradia_LINT_Weinheim.jpg"
        ),
        "coradia_lint_interior": TrainPhotoDetail(
            assetName: "coradia_lint_interior",
            label: "LINT 41 Innenraum",
            characteristicDescription: "Moderner Regional-Fahrgastraum für Nebenstrecken mit großflächigen Fenstern.",
            photographer: "Pentium1000~dewiki",
            license: "CC BY-SA 4.0",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:Innenraum_eines_modernisierten_LNVG_Lint_41.JPG"
        ),
        "et_423": TrainPhotoDetail(
            assetName: "et_423",
            label: "Streckenansicht S-Bahn",
            characteristicDescription: "Das unermüdliche Rückgrat der großen S-Bahn-Netze in Ballungsräumen.",
            photographer: "Paul Smith",
            license: "CC BY 2.0",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:DBAG_Class_423.jpg"
        ),
        "et_423_front": TrainPhotoDetail(
            assetName: "et_423_front",
            label: "S-Bahn Frontpartie",
            characteristicDescription: "Kompakte, abgerundete Kopfform mit Zielanzeige für schnellen Fahrgastwechsel im S-Bahn-Netz.",
            photographer: "Wikimedia-User Jivee Blau",
            license: "CC BY-SA 4.0",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:Mainz-Kastel-_Bahnhof-_auf_Br%C3%BCcke_der_Bundesstra%C3%9Fe_40-_Richtung_Frankfurt_am_Main-_DBAG-Baureihe_423_873-9_4.6.2010.jpg"
        ),
        "et_423_interior": TrainPhotoDetail(
            assetName: "et_423_interior",
            label: "S-Bahn Großraumwagen",
            characteristicDescription: "Durchgängiger Großraumtriebzug ohne Trenntüren mit Haltestangen für hohen Pendlerandrang.",
            photographer: "User:Mattes",
            license: "Public Domain",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:S-Bahn_M%C3%BCnchen,_Klasse_423,_Waggon_2._Klasse,_innen_%E2%80%94_2005.jpg"
        ),
        "et_425": TrainPhotoDetail(
            assetName: "et_425",
            label: "Hauptansicht Weinheim",
            characteristicDescription: "Kult-Regionalbahn mit unverwechselbarem Frequenzumrichter-Quietschen beim Anfahren.",
            photographer: "Photographs by Radosław Drożdżewski (User:Zwiadowca21)",
            license: "CC BY-SA 4.0",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:DB_Baureihe_425.jpg"
        ),
        "et_425_front": TrainPhotoDetail(
            assetName: "et_425_front",
            label: "ET 425 Front & Falttüren",
            characteristicDescription: "Flache, steile Frontpartie und zahlreiche Außenschwenktüren für schnelle Halte.",
            photographer: "Photographs by Radosław Drożdżewski (User:Zwiadowca21)",
            license: "CC BY-SA 4.0",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:Bahnhof_Weinheim_-_DB-Baureihe_425_-_425-818_-_2019-02-13_14-46-41.jpg"
        ),
        "et_425_interior": TrainPhotoDetail(
            assetName: "et_425_interior",
            label: "ET 425 Innenraum",
            characteristicDescription: "Klassischer Regionalbahn-Innenraum mit Klappsitzen im Mehrzweckbereich.",
            photographer: "Wikimedia-User Jivee Blau",
            license: "CC BY-SA 3.0",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:DBAG-Baureihe_425-_Interieur.JPG"
        )
    ]
    
    /// Alle kuratierten Fotos für diesen Zug mit charakteristischen Merkmalen und Lizenzdaten
    public var galleryPhotos: [TrainPhotoDetail] {
        let catalog = TrainModel.photoCatalog
        
        switch seriesCode {
        case _ where seriesCode.contains("403 (Tz 304)"):
            return [catalog["ice_regenbogen"], catalog["ice_regenbogen_detail"], catalog["ice_3_lounge"]].compactMap { $0 }
        case _ where seriesCode.contains("406 (Tz 4601)"):
            return [catalog["ice_europa"], catalog["ice_europa_detail"], catalog["ice_3m_multi"]].compactMap { $0 }
        case _ where seriesCode.contains("412 (Tz 9457)"):
            return [catalog["ice_4_brd"], catalog["ice_4_altengronau"], catalog["ice_4_interior"]].compactMap { $0 }
        case _ where seriesCode.contains("412 (Tz 9015)"):
            return [catalog["ice_4"], catalog["ice_female_cab"], catalog["ice_female_restaurant"]].compactMap { $0 }
        case _ where seriesCode.contains("410"):
            return [catalog["ice_s"], catalog["ice_s_run"]].compactMap { $0 }
        case _ where seriesCode.contains("605"):
            return [catalog["ice_605_trainlab"], catalog["ice_605_sensors"]].compactMap { $0 }
        case _ where seriesCode.contains("408"):
            return [catalog["ice_3neo"], catalog["ice_3neo_interior"]].compactMap { $0 }
        case _ where seriesCode.contains("407"):
            return [catalog["ice_3_velaro"], catalog["ice_407_interior"]].compactMap { $0 }
        case _ where seriesCode.contains("403"):
            return [catalog["ice_3_sfs"], catalog["ice_3_lounge"], catalog["ice_3_velaro"]].compactMap { $0 }
        case _ where seriesCode.contains("406"):
            return [catalog["ice_europa"], catalog["ice_3m_multi"], catalog["ice_3_lounge"]].compactMap { $0 }
        case _ where seriesCode.contains("412 (XXL)"):
            return [catalog["ice_4"], catalog["ice_4_altengronau"], catalog["ice_4_front"]].compactMap { $0 }
        case _ where seriesCode.contains("412 (K7)"):
            return [catalog["ice_4"], catalog["ice_4_front"], catalog["ice_4_interior"]].compactMap { $0 }
        case _ where seriesCode.contains("412"):
            return [catalog["ice_4"], catalog["ice_4_front"], catalog["ice_4_altengronau"], catalog["ice_4_interior"]].compactMap { $0 }
        case _ where seriesCode.contains("411"):
            return [catalog["ice_t"], catalog["ice_3_lounge"]].compactMap { $0 }
        case _ where seriesCode.contains("415"):
            return [catalog["ice_t"], catalog["ice_3_lounge"]].compactMap { $0 }
        case _ where seriesCode.contains("401"):
            return [catalog["ice_1"], catalog["ice_1_powerhead"], catalog["ice_1_restaurant"], catalog["ice_1_interior"]].compactMap { $0 }
        case _ where seriesCode.contains("402"):
            return [catalog["ice_2"], catalog["ice_2_cab"], catalog["ice_2_front"]].compactMap { $0 }
        case _ where seriesCode.contains("105"):
            return [catalog["ice_l"], catalog["ice_l_cab"], catalog["ice_l_side"], catalog["ice_l_interior"]].compactMap { $0 }
        case _ where seriesCode.contains("101"):
            return [catalog["br_101"], catalog["br_101_cab"]].compactMap { $0 }
        case _ where seriesCode.contains("146"):
            return [catalog["twindexx_vario"], catalog["ic2_twindexx_cab"]].compactMap { $0 }
        case _ where seriesCode.contains("147"):
            return [catalog["twindexx_vario"], catalog["ic2_twindexx_cab"]].compactMap { $0 }
        case _ where seriesCode.contains("4110"):
            return [catalog["ic2_kiss"], catalog["ic2_kiss_front"], catalog["ic2_kiss_wien"]].compactMap { $0 }
        case _ where seriesCode.contains("Nightjet"):
            return [catalog["nightjet_viaggio"], catalog["nightjet_cab"], catalog["nightjet_minicabin"]].compactMap { $0 }
        case _ where seriesCode.contains("462"):
            return [catalog["desiro_hc"], catalog["desiro_hc_hybrid"], catalog["desiro_hc_interior"]].compactMap { $0 }
        case _ where seriesCode.contains("442"):
            return [catalog["talent_2"], catalog["talent_2_front"], catalog["talent_2_interior"]].compactMap { $0 }
        case _ where seriesCode.contains("1428"):
            return [catalog["flirt_3"], catalog["flirt_3_front"], catalog["flirt_3_interior"]].compactMap { $0 }
        case _ where seriesCode.contains("1429"):
            return [catalog["flirt_3"], catalog["flirt_3_front"], catalog["flirt_3_interior"]].compactMap { $0 }
        case _ where seriesCode.contains("463"):
            return [catalog["mireo"], catalog["mireo_front"], catalog["mireo_interior"]].compactMap { $0 }
        case _ where seriesCode.contains("445"):
            return [catalog["twindexx_vario"], catalog["twindexx_regio_cab"]].compactMap { $0 }
        case _ where seriesCode.contains("446"):
            return [catalog["twindexx_vario"], catalog["twindexx_regio_cab"]].compactMap { $0 }
        case _ where seriesCode.contains("1440"):
            return [catalog["coradia_continental"], catalog["coradia_continental_front"]].compactMap { $0 }
        case _ where seriesCode.contains("622"):
            return [catalog["coradia_lint"], catalog["coradia_lint_front"], catalog["coradia_lint_interior"]].compactMap { $0 }
        case _ where seriesCode.contains("648"):
            return [catalog["coradia_lint"], catalog["coradia_lint_front"], catalog["coradia_lint_interior"]].compactMap { $0 }
        case _ where seriesCode.contains("423"):
            return [catalog["et_423"], catalog["et_423_front"], catalog["et_423_interior"]].compactMap { $0 }
        case _ where seriesCode.contains("430"):
            return [catalog["et_423"], catalog["et_423_front"], catalog["et_423_interior"]].compactMap { $0 }
        case _ where seriesCode.contains("425"):
            return [catalog["et_425"], catalog["et_425_front"], catalog["et_425_interior"]].compactMap { $0 }
        default:
            if let prim = catalog[assetName] {
                return [prim]
            }
            return [
                TrainPhotoDetail(
                    assetName: assetName,
                    label: "Hauptansicht",
                    characteristicDescription: commercialName,
                    photographer: "Deutsche Bahn / Wikimedia Commons",
                    license: "CC BY-SA 4.0"
                )
            ]
        }
    }
    
    /// Abwärtskompatibilität: Liste aller Bildasset-Namen
    public var galleryImageNames: [String] {
        galleryPhotos.map(\.assetName)
    }

    /// Spotter-Guide: Visuelle Erkennungsmerkmale zum Identifizieren am Bahnsteig
    public var spotterFeatures: [SpotterFeature] {
        switch seriesCode {
        // MARK: - ICE Flotte
        case _ where seriesCode.contains("401"):
            return [
                SpotterFeature(icon: "arrow.forward.to.line", title: "Kopfform & Lokomotiven", description: "Zwei separate, geschwungene Triebköpfe an den Zugenden mit mittigem DB-Keks."),
                SpotterFeature(icon: "building.2.crop.none", title: "Buckelspeisewagen", description: "Bordrestaurant in der Zugmitte besitzt das legendäre erhöhte Dach ('Buckel')."),
                SpotterFeature(icon: "number", title: "Baureihen-Code", description: "Triebköpfe sind mit '401' beschriftet. Züge haben feste 9- oder 12-Wagen-Länge.")
            ]
            
        case _ where seriesCode.contains("402"):
            return [
                SpotterFeature(icon: "arrow.triangle.pull", title: "Triebkopf & Steuerwagen", description: "Besteht aus nur EINEM Triebkopf (402) und einem Steuerwagen mit Fahrgastplätzen am anderen Ende."),
                SpotterFeature(icon: "link", title: "Flügelzug-Kupplung", description: "Wird häufig in Hamm (Westfalen) geteilt oder gekoppelt. Flachere Bugklappe als ICE 1.")
            ]
            
        case _ where seriesCode.contains("403") && !seriesCode.contains("Tz 304"):
            return [
                SpotterFeature(icon: "speedometer", title: "Aerodynamische Pfeilfront", description: "Triebzug ohne separate Lokomotive – die Motoren liegen unterflur über den ganzen Zug verteilt."),
                SpotterFeature(icon: "eye.fill", title: "Panoramalounge", description: "Sitzplätze mit Glaswand direkt hinter dem Führerstand mit freiem Blick auf die Gleise.")
            ]
            
        case _ where seriesCode.contains("406") && !seriesCode.contains("Tz 4601"):
            return [
                SpotterFeature(icon: "bolt.fill", title: "Viersystem-Stromabnehmer", description: "Trägt 4 verschiedene Stromabnehmer auf den Dächern für Fahrten nach Frankreich, Belgien und Niederlande."),
                SpotterFeature(icon: "flag.fill", title: "Grenzverkehr", description: "Verkehrt typischerweise auf internationalen Linien nach Paris, Brüssel oder Amsterdam.")
            ]
            
        case _ where seriesCode.contains("407"):
            return [
                SpotterFeature(icon: "shield.lefthalf.filled", title: "Erhöhter Dachaufbau", description: "Aerodynamisch verkleidete Dachhaube für besseren Lärmschutz bei 320 km/h."),
                SpotterFeature(icon: "door.left.hand.open", title: "Türanordnung", description: "Doppelflügelige Außentüren für schnelleren Fahrgastwechsel.")
            ]
            
        case _ where seriesCode.contains("408"):
            return [
                SpotterFeature(icon: "window.shade.closed", title: "Dunkles Scheibenband", description: "Charakteristisches durchgehend schwarz abgesetztes Fensterband entlang der Wagen."),
                SpotterFeature(icon: "bolt.badge.automatic", title: "Dachverkleidung", description: "Vollständig integrierte Stromabnehmer-Wannen auf dem Dach."),
                SpotterFeature(icon: "figure.roll", title: "Rollstuhllift-Tür", description: "Zusätzliche Einstiegstür mit integrierter Hebebühne an Wagen 2.")
            ]
            
        case _ where seriesCode.contains("412"):
            return [
                SpotterFeature(icon: "diamond.fill", title: "Haifisch-Kopfform", description: "Sehr markante, kantig gestaltete Front mit roter Begleitlinie oberhalb der Frontscheibe."),
                SpotterFeature(icon: "ruler.fill", title: "28-Meter-Großraumwagen", description: "Wagenkästen sind spürbar länger als bei allen früheren ICE-Generationen."),
                SpotterFeature(icon: "paintbrush.fill", title: "Gelber 1.-Klasse-Streifen", description: "Oberhalb der Fenster der 1. Klasse verläuft ein gut sichtbarer gelber Signalstreifen.")
            ]
            
        case _ where seriesCode.contains("411") || seriesCode.contains("415"):
            return [
                SpotterFeature(icon: "arrow.left.and.right", title: "Neigetechnik (GNT)", description: "Neigt sich in engen Kurven um bis zu 8 Grad. Etwas schmalerer Wagenkasten oben."),
                SpotterFeature(icon: "wind", title: "Kompakte Kopfform", description: "Ähnelt dem ICE 3, hat jedoch eine einteilige Frontscheibe ohne Mittelsteg.")
            ]
            
        case _ where seriesCode.contains("105"):
            return [
                SpotterFeature(icon: "figure.roll", title: "Ebenerdiger Einstieg", description: "Erster Fernverkehrszug mit 76 cm stufenlosem Einstieg an jedem Bahnsteig."),
                SpotterFeature(icon: "circle.grid.2x1.fill", title: "Kurze Talgo-Wagen", description: "Nur 13 Meter kurze Wagenkästen mit charakteristischen Einzelrad-Fahrwerken.")
            ]
            
        // MARK: - Sonderzüge
        case _ where seriesCode.contains("Tz 304"):
            return [
                SpotterFeature(icon: "paintpalette.fill", title: "Regenbogen-Streifen", description: "Trägt den berühmten Pride-Regenbogenstreifen über die gesamte Länge der beiden Endwagen."),
                SpotterFeature(icon: "tag.fill", title: "Taufname 'München'", description: "Seit Sommer 2021 als Botschafter für Vielfalt im gesamten ICE-Netz unterwegs.")
            ]
            
        case _ where seriesCode.contains("Tz 4601"):
            return [
                SpotterFeature(icon: "flag.fill", title: "Europa-Lackierung", description: "Blauer Zierstreifen mit goldenen Europa-Sternen anstelle des roten DB-Streifens."),
                SpotterFeature(icon: "network", title: "Mehrsystemzug", description: "ICE 3M der Baureihe 406, regelmäßig zwischen Deutschland, Brüssel und Amsterdam im Einsatz.")
            ]
            
        case _ where seriesCode.contains("9457"):
            return [
                SpotterFeature(icon: "flag.2.crossed", title: "Schwarz-Rot-Gold", description: "Beide Triebköpfe tragen die deutsche Bundesflagge als markanten Zierstreifen."),
                SpotterFeature(icon: "crown.fill", title: "13-Teiler XXL", description: "Längster Zug im ICE-Netz (374 Meter) mit Platz für 918 Fahrgäste.")
            ]
            
        case _ where seriesCode.contains("410"):
            return [
                SpotterFeature(icon: "gearshape.2.fill", title: "Mess- & Prüfzug", description: "Zahlreiche Kameras, Laser und Sensoraufbauten auf dem Dach und an den Drehgestellen."),
                SpotterFeature(icon: "speedometer", title: "Rekordzug", description: "Ehemaliger deutscher Rekordhalter mit 393 km/h.")
            ]
            
        case _ where seriesCode.contains("5505") || (seriesCode.contains("605") && commercialName.contains("TrainLab")):
            return [
                SpotterFeature(icon: "waveform.path.ecg", title: "Grau-Türkise Beklebung", description: "Spezielle 'advanced TrainLab'-Lackierung mit Antennen und Radarsensoren."),
                SpotterFeature(icon: "engine.combustion", title: "Diesel-Power", description: "Ehemaliger ICE-TD mit vier Dieselmotoren für fahrleitungsunabhängige Testfahrten.")
            ]
            
        // MARK: - Intercity & Nachtzug
        case _ where seriesCode.contains("101"):
            return [
                SpotterFeature(icon: "cube.fill", title: "Klassische Kantige Front", description: "Vierachsige Schnellzuglokomotive der 90er Jahre vor klassischen einstöckigen IC-Wagen."),
                SpotterFeature(icon: "antenna.radiowaves.left.and.right", title: "Puffer & Kupplung", description: "Klassische Schraubenkupplung mit runden Seitenpuffern an der Front.")
            ]
            
        case _ where seriesCode.contains("146") || seriesCode.contains("147") || (commercialName.contains("Twindexx") && category == .highSpeed):
            return [
                SpotterFeature(icon: "arrow.up.and.down", title: "Weißer Doppelstock-IC", description: "Weiß lackierte Bombardier-Doppelstockwagen mit rotem DB-Streifen, gezogen von BR 146.5 oder 147.5."),
                SpotterFeature(icon: "arrow.up.left.and.down.right.magnifyingglass", title: "Panoramablick", description: "Fenster im Oberdeck bieten hervorragende Aussicht über Lärmschutzwände hinweg.")
            ]
            
        case _ where seriesCode.contains("4110") || commercialName.contains("KISS"):
            return [
                SpotterFeature(icon: "bolt.fill", title: "Stadler KISS Triebzug", description: "Weißer Doppelstock-Triebzug mit auffallend spitz zulaufender, moderner Stadler-Frontpartie."),
                SpotterFeature(icon: "hare.fill", title: "Enorme Beschleunigung", description: "Spurtschneller 4- oder 6-teiliger Triebzug, ursprünglich für die österreichische WESTbahn gefertigt.")
            ]
            
        case _ where commercialName.contains("Nightjet"):
            return [
                SpotterFeature(icon: "moon.stars.fill", title: "Dunkelblaues Design", description: "Elegante dunkelblaue Lackierung der ÖBB mit Sternenhimmel-Muster."),
                SpotterFeature(icon: "bed.double.fill", title: "Mini-Cabins", description: "Erkennbar an den versetzten Fenstern der innovativen Schlafkapseln.")
            ]
            
        // MARK: - Regionalverkehr
        case _ where seriesCode.contains("462") || commercialName.contains("Desiro HC"):
            return [
                SpotterFeature(icon: "arrow.up.arrow.down.square", title: "Hybrid-Dosto-Bauweise", description: "Die beiden Endwagen sind EINSTÖCKIG, die Mittelwagen sind DOPPELSTÖCKIG!"),
                SpotterFeature(icon: "lightbulb.fill", title: "LED-Frontleuchten", description: "Markante, schräg angeordnete LED-Scheinwerfer im Siemens Desiro-Familiendesign.")
            ]
            
        case _ where seriesCode.contains("442") || commercialName.contains("Talent 2"):
            return [
                SpotterFeature(icon: "face.smiling", title: "'Hamsterbacken'-Front", description: "Kräftig nach außen gewölbte Frontschürze, die dem Zug seinen Spitznamen gab."),
                SpotterFeature(icon: "arrow.down.to.line", title: "Tiefer Einstieg", description: "Niedrige Fensterlinie und stufenloser Einstieg an regionalen Bahnsteigen.")
            ]
            
        case _ where seriesCode.contains("1428") || seriesCode.contains("1429") || commercialName.contains("FLIRT"):
            return [
                SpotterFeature(icon: "tram.fill", title: "Jakobs-Drehgestelle", description: "Die Wagenkästen teilen sich jeweils ein gemeinsames Drehgestell am Übergang."),
                SpotterFeature(icon: "windshield.front.and.heat.waves", title: "Steile Frontscheibe", description: "Sehr aufrechte, polygonale Frontscheibe im typischen Schweizer Stadler-Design.")
            ]
            
        case _ where seriesCode.contains("463") || commercialName.contains("Mireo"):
            return [
                SpotterFeature(icon: "leaf.fill", title: "Futuristische Leichtbau-Front", description: "Fließende, geschwungene Linienführung mit horizontalen LED-Tagfahrleuchten."),
                SpotterFeature(icon: "gauge.with.needle", title: "Extrem leise", description: "Modernste Schalldämmung und hohe Energieeffizienz dank Leichtbauweise.")
            ]
            
        case _ where seriesCode.contains("445") || seriesCode.contains("446") || commercialName.contains("Twindexx Vario"):
            return [
                SpotterFeature(icon: "arrow.up.and.down", title: "Roter Doppelstock-Triebkopf", description: "DB Regio Verkehrsrot mit angetriebenen Triebköpfen an beiden Enden der Wagengarnitur."),
                SpotterFeature(icon: "person.3.fill", title: "Hohe Kapazität", description: "Breite Treppenaufgänge im Einstiegsbereich führen ins Ober- und Unterdeck.")
            ]
            
        case _ where seriesCode.contains("423") || seriesCode.contains("430") || commercialName.contains("S-Bahn"):
            return [
                SpotterFeature(icon: "door.left.hand.open", title: "3 Türen pro Wagenseite", description: "Speziell für extrem schnellen Fahrgastwechsel in Großstadtnetzen entwickelt."),
                SpotterFeature(icon: "rectangle.compress.vertical", title: "Kompakte Höhe", description: "Exakt abgestimmt auf 96 cm Hochbahnsteige der S-Bahnen.")
            ]
            
        case _ where seriesCode.contains("425") || commercialName.contains("ET 425"):
            return [
                SpotterFeature(icon: "speaker.wave.3.fill", title: "Fahrgeräusch ('Quietschie')", description: "Unverwechselbares heulendes und quietschendes Anfahrgeräusch der Frequenzumrichter."),
                SpotterFeature(icon: "rectangle.portrait.split.2x1", title: "Durchgängiger Wagenkasten", description: "Kompakte rote Regionalbahn mit Jakobs-Drehgestellen und ungeteiltem Innenraum.")
            ]
            
        case _ where seriesCode.contains("622") || seriesCode.contains("648") || commercialName.contains("LINT"):
            return [
                SpotterFeature(icon: "engine.combustion", title: "Diesel-Sound", description: "Deutliches Dieseln beim Anfahren auf nicht elektrifizierten Nebenstrecken."),
                SpotterFeature(icon: "car.side.fill", title: "Kompakter 1- bis 2-Teiler", description: "Schlanker Triebwagen mit Dachkühlanlagen für gemütliche Regionalstrecken.")
            ]
            
        default:
            return [
                SpotterFeature(icon: "tag.fill", title: "Baureihe & Anschrift", description: "Die Baureihennummer (z. B. \(seriesCode)) findest du außen an den Türen und Triebköpfen."),
                SpotterFeature(icon: "speedometer", title: "Höchstgeschwindigkeit", description: "Ausgelegt für bis zu \(maxSpeedKmH ?? 160) km/h im regulären Streckendienst.")
            ]
        }
    }
}
