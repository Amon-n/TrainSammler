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
        ),
        "br_193_vectron": TrainPhotoDetail(
            assetName: "br_193_vectron",
            label: "Siemens Vectron (BR 193)",
            characteristicDescription: "Die markante Front der 500. gelieferten Siemens-Vectron-Lokomotive (193 331) mit den typischen seitlichen „Kiemen“.",
            photographer: "EM311",
            license: "CC BY-SA 4.0",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:Siemens_Vectron_DB_Cargo_193_331_Graben-Neudorf.jpg"
        ),
        "br_193_vectron_dresden": TrainPhotoDetail(
            assetName: "br_193_vectron_dresden",
            label: "Streckenfahrt (Dresden Hbf)",
            characteristicDescription: "Mehrsystemlokomotive 193 389 im grenzüberschreitenden Einsatz in Dresden Hauptbahnhof.",
            photographer: "Rainerhaufe",
            license: "CC BY-SA 4.0",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:DB_193_389_Dresden_Hauptbahnhof_Ensogeb%C3%A4ude.jpg"
        ),
        "oebb_railjet": TrainPhotoDetail(
            assetName: "oebb_railjet",
            label: "ÖBB Railjet auf Strecke",
            characteristicDescription: "Siebenteiliger Hochgeschwindigkeits-Wendezug der ÖBB mit passend lackierter Taurus-Lokomotive 1116 bei Rosenheim.",
            photographer: "Manfred Kopka",
            license: "CC BY-SA 4.0",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:%C3%96BB_1116_237_mit_Railjet_bei_Rosenheim.jpg"
        ),
        "oebb_railjet_taurus": TrainPhotoDetail(
            assetName: "oebb_railjet_taurus",
            label: "Taurus-Lokomotive (Rh 1116)",
            characteristicDescription: "Die berühmte „Tonleiter-Lok“ EuroSprinter ES64U2 (Rh 1116) im rubinroten Railjet-Design am Bahnsteig.",
            photographer: "Pedalito",
            license: "CC0 / Public Domain",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:%C3%96BB_railjet_Taurus_1116_218.jpg"
        ),
        "sbb_giruno_zurich": TrainPhotoDetail(
            assetName: "sbb_giruno_zurich",
            label: "SBB Giruno Kopfform (Zürich HB)",
            characteristicDescription: "Aerodynamische Frontpartie des Stadler SMILE (RABe 501) mit SBB-Signet im Zürcher Hauptbahnhof.",
            photographer: "JoachimKohler-HB",
            license: "CC BY-SA 4.0",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:SBB_RABe_501_030_%22Lambarda%22_in_Z%C3%BCrich_HB_(2026).jpg"
        ),
        "sbb_giruno": TrainPhotoDetail(
            assetName: "sbb_giruno",
            label: "Elfteiliger Gliederzug auf Strecke",
            characteristicDescription: "Der 202 Meter lange Niederflur-Hochgeschwindigkeitszug RABe 501 mit Jakobs-Drehgestellen bei Erlen.",
            photographer: "Plutowiki",
            license: "CC0 / Public Domain",
            commonsUrl: "https://commons.wikimedia.org/wiki/File:SBB_RABe_501_Erlen.jpg"
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
            return [catalog["ice_female_cab"], catalog["ice_female_restaurant"], catalog["ice_4"]].compactMap { $0 }
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
            return [catalog["ice_3m_multi"], catalog["ice_3_sfs"], catalog["ice_3_lounge"]].compactMap { $0 }
        case _ where seriesCode.contains("412 (XXL)"):
            return [catalog["ice_4_altengronau"], catalog["ice_4"], catalog["ice_4_front"], catalog["ice_4_interior"]].compactMap { $0 }
        case _ where seriesCode.contains("412 (K7)"):
            return [catalog["ice_4_front"], catalog["ice_4"], catalog["ice_4_interior"]].compactMap { $0 }
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
            return [catalog["ice_l_cab"], catalog["ice_l"], catalog["ice_l_side"], catalog["ice_l_interior"]].compactMap { $0 }
        case _ where seriesCode.contains("501"):
            return [catalog["sbb_giruno_zurich"], catalog["sbb_giruno"]].compactMap { $0 }
        case _ where seriesCode.contains("1116") || seriesCode.contains("RJ"):
            return [catalog["oebb_railjet"], catalog["oebb_railjet_taurus"]].compactMap { $0 }
        case _ where seriesCode.contains("193"):
            return [catalog["br_193_vectron"], catalog["br_193_vectron_dresden"]].compactMap { $0 }
        case _ where seriesCode.contains("101"):
            return [catalog["br_101"], catalog["br_101_cab"]].compactMap { $0 }
        case _ where seriesCode.contains("146"):
            return [catalog["ic2_twindexx_cab"]].compactMap { $0 }
        case _ where seriesCode.contains("147"):
            return [catalog["ic2_twindexx_cab"]].compactMap { $0 }
        case _ where seriesCode.contains("4110"):
            return [catalog["ic2_kiss"], catalog["ic2_kiss_front"], catalog["ic2_kiss_wien"]].compactMap { $0 }
        case _ where seriesCode.contains("Nightjet"):
            return [catalog["nightjet_cab"], catalog["nightjet_viaggio"], catalog["nightjet_minicabin"]].compactMap { $0 }
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
        // MARK: - 1. Sonderzüge (zuerst prüfen, damit sie nicht von allgemeinen Baureihen abgefangen werden)
        case _ where seriesCode.contains("Tz 304"):
            return [
                SpotterFeature(icon: "paintpalette.fill", title: "Regenbogen-Streifen", description: "Trägt den sechsfarbigen Pride-Regenbogenstreifen an beiden Endwagen anstelle des roten DB-Streifens."),
                SpotterFeature(icon: "tag.fill", title: "Taufname „München“", description: "Einzelstück (Tz 304) der Baureihe 403 als Botschafter für Vielfalt im gesamten ICE-Netz.")
            ]
            
        case _ where seriesCode.contains("Tz 4601"):
            return [
                SpotterFeature(icon: "flag.fill", title: "Blauer Europa-Zierstreifen", description: "Dunkelblauer Streifen mit gelben europäischen Sternen anstelle des verkehrsroten Bands."),
                SpotterFeature(icon: "network", title: "Mehrsystemzug Tz 4601", description: "Einer der bekanntesten Sonderbotschafter der Baureihe 406 im grenzüberschreitenden Verkehr.")
            ]
            
        case _ where seriesCode.contains("9457"):
            return [
                SpotterFeature(icon: "flag.2.crossed", title: "Schwarz-Rot-Gold", description: "Beide Endwagen tragen die deutsche Bundesflagge als langen Zierstreifen."),
                SpotterFeature(icon: "crown.fill", title: "13-Teiler XXL (Tz 9457)", description: "Auf den Namen „Bundesrepublik Deutschland“ getaufter 374-Meter-Langzug.")
            ]
            
        case _ where seriesCode.contains("9015"):
            return [
                SpotterFeature(icon: "person.2.fill", title: "Female-ICE-Signet", description: "Auffälliges „Female ICE“-Aktionslogo mit weiblicher Silhouette am Triebkopf und Bordrestaurant."),
                SpotterFeature(icon: "tag.fill", title: "Triebzug 9015 „Mainz“", description: "12-teiliger ICE 4 als rollender Botschafter für Frauen in eisenbahntechnischen Berufen.")
            ]
            
        case _ where seriesCode.contains("410"):
            return [
                SpotterFeature(icon: "gearshape.2.fill", title: "Mess- & Prüfzug", description: "Zahlreiche Kameras, Laser-Sensoren und Messstromabnehmer auf dem Dach und an den Drehgestellen."),
                SpotterFeature(icon: "speedometer", title: "393-km/h-Versuchsträger", description: "Kurzer Spezialzug der DB Systemtechnik mit gelbem „ICE S“-Schriftzug.")
            ]
            
        case _ where seriesCode.contains("605"):
            return [
                SpotterFeature(icon: "waveform.path.ecg", title: "Grau-Türkise Sensorbeklebung", description: "Auffällige „advanced TrainLab“-Lackierung mit Lidar-, Radar- und 5G-Antennen an der Nase."),
                SpotterFeature(icon: "engine.combustion", title: "Diesel-elektrischer Antrieb", description: "Ehemaliger ICE TD (BR 605), der auch ohne Oberleitung überall im Netz testen kann.")
            ]

        // MARK: - 2. ICE-Flotte & DACH-Fernverkehr
        case _ where seriesCode.contains("401"):
            return [
                SpotterFeature(icon: "arrow.forward.to.line", title: "Zwei Triebköpfe", description: "Klassische Lokomotiv-Triebköpfe ohne Fahrgastfenster an beiden Zugenden mit mittigem DB-Logo."),
                SpotterFeature(icon: "building.2.crop.none", title: "Buckelspeisewagen", description: "Das Bordrestaurant in der Zugmitte überragt mit seinem erhöhten Dach alle anderen Wagen.")
            ]
            
        case _ where seriesCode.contains("402"):
            return [
                SpotterFeature(icon: "arrow.triangle.pull", title: "Triebkopf + Steuerwagen", description: "Ein Ende besitzt einen Triebkopf (402), das andere einen Steuerwagen (808) mit Fahrgasttüren."),
                SpotterFeature(icon: "link", title: "Flügelzug-Bugklappe", description: "Glatte, zweiteilige Bugklappe für schnelles Kuppeln zweier Halbzüge.")
            ]
            
        case _ where seriesCode.contains("403"):
            return [
                SpotterFeature(icon: "speedometer", title: "Unterflur-Triebzug", description: "Keine Triebköpfe: Die Technik verteilt sich unter dem gesamten 8-teiligen Zug."),
                SpotterFeature(icon: "eye.fill", title: "Panorama-Lounge", description: "Sitzplätze direkt hinter dem Lokführer mit freier Sicht durch die Frontscheibe auf die Strecke.")
            ]
            
        case _ where seriesCode.contains("406"):
            return [
                SpotterFeature(icon: "bolt.fill", title: "Sechs Dachstromabnehmer", description: "Ausgerüstet für vier Stromsysteme (DE/AT/CH, FR, BE, NL) auf den Mittelwagen."),
                SpotterFeature(icon: "flag.fill", title: "Internationaler Pionier", description: "Äußerlich fast baugleich zum BR 403, aber an den zusätzlichen Stromabnehmern auf dem Dach erkennbar.")
            ]
            
        case _ where seriesCode.contains("407"):
            return [
                SpotterFeature(icon: "shield.lefthalf.filled", title: "Durchgehender Dachbuckel", description: "Markant erhöhte, aerodynamische Dachverkleidung über die gesamte Zuglänge."),
                SpotterFeature(icon: "window.ceiling", title: "Separate Führerstandstür", description: "Eigene Außentür zum Führerstand und steilere, bulligere Velaro-Kopfform als beim BR 403.")
            ]
            
        case _ where seriesCode.contains("408"):
            return [
                SpotterFeature(icon: "window.shade.closed", title: "Laser-Scheiben & schwarzes Band", description: "Feines Raster in den Fensterscheiben für perfekten Mobilfunkempfang und tiefschwarzes Fensterband."),
                SpotterFeature(icon: "figure.roll", title: "10 Einstiegstüren pro Seite", description: "Zwei zusätzliche Türen gegenüber dem BR 407 sowie integrierter Rollstuhllift.")
            ]
            
        case _ where seriesCode.contains("412 (XXL)"):
            return [
                SpotterFeature(icon: "ruler.fill", title: "374 Meter (13 Wagen)", description: "Füllt selbst längste Fernbahnsteige komplett aus – erkennbar an Wagen 11, 12 und 14."),
                SpotterFeature(icon: "number", title: "Triebzugnummern 94xx", description: "Außen am Bug mit einer vierstelligen Tz-Nummer ab 9401 (BR 412.4) gekennzeichnet.")
            ]
            
        case _ where seriesCode.contains("412 (K7)"):
            return [
                SpotterFeature(icon: "scissors", title: "Kompakter 7-Teiler (200 m)", description: "Deutlich kürzere Garnitur mit nur einem 1.-Klasse-Endwagen, oft in Doppeltraktion gekuppelt."),
                SpotterFeature(icon: "speedometer", title: "250 km/h (BR 412.2)", description: "Trägt außen Triebzugnummern im 92xx-Bereich und ist für 250 km/h zugelassen.")
            ]
            
        case _ where seriesCode.contains("412"):
            return [
                SpotterFeature(icon: "diamond.fill", title: "Kantige ICE-4-Kopfform", description: "Markante Front mit schmalem roten Zierstreifen oberhalb der Führerstandsscheibe."),
                SpotterFeature(icon: "ruler.fill", title: "28-Meter-Großraumwagen", description: "Ungewöhnlich lange Wagenkästen mit außenliegenden Trittstufen an den Türen.")
            ]
            
        case _ where seriesCode.contains("411") || seriesCode.contains("415"):
            return [
                SpotterFeature(icon: "arrow.left.and.right", title: "Neigetechnik-Wagenkasten", description: "Nach oben hin leicht verjüngter Querschnitt, der sich in Kurven um bis zu 8 Grad neigt."),
                SpotterFeature(icon: "wind", title: "Steile Frontpartie", description: "Kürzere, steilere Nase als beim ICE 3 mit einem einzigen zentralen Scheibenwischer.")
            ]
            
        case _ where seriesCode.contains("105"):
            return [
                SpotterFeature(icon: "figure.roll", title: "Stufenloser 76-cm-Einstieg", description: "Durchgehend ebenerdiger Einstieg ohne Treppenstufen an Standardbahnsteigen."),
                SpotterFeature(icon: "circle.grid.2x1.fill", title: "Kurze Talgo-Gliederwagen", description: "Charakteristisch kurze 13-Meter-Wagen mit Einzelrad-Fahrwerken und Talgo-Lok BR 105.")
            ]

        case _ where seriesCode.contains("501") || commercialName.contains("Giruno"):
            return [
                SpotterFeature(icon: "plus.square.fill", title: "Schweizer SBB-Design", description: "Rot-weiß-schwarze Kopfform mit Schweizer Kreuz an der Front und vier Stromabnehmern."),
                SpotterFeature(icon: "figure.walk", title: "Zwei Einstiegshöhen", description: "Besitzt separate Niederflurtüren für 55 cm (CH/IT) und 76 cm (DE) Bahnsteighöhe.")
            ]

        case _ where seriesCode.contains("1116") || commercialName.contains("Railjet"):
            return [
                SpotterFeature(icon: "music.note", title: "Taurus-Tonleiter beim Anfahren", description: "Die Lokomotive Rh 1116 erzeugt beim Anfahren eine weltberühmte akustische Tonleiter."),
                SpotterFeature(icon: "paintbrush.fill", title: "Rubinrot-Anthrazit", description: "Durchgängiges Design von der Taurus-Lok bis zum aerodynamischen Steuerwagen.")
            ]

        case _ where seriesCode.contains("193") || commercialName.contains("Vectron"):
            return [
                SpotterFeature(icon: "line.3.horizontal", title: "Charakteristische Front-Kiemen", description: "Drei horizontale Sicken („Kiemen“) links und rechts neben dem Frontlogo."),
                SpotterFeature(icon: "bolt.horizontal.fill", title: "Mehrsystem-Dachgarten", description: "Bis zu vier Stromabnehmer für den Einsatz von Skandinavien über DACH bis Italien und den Balkan.")
            ]
            
        // MARK: - 3. Intercity & Nachtzug
        case _ where seriesCode.contains("101"):
            return [
                SpotterFeature(icon: "cube.fill", title: "Abgeschrägte Drehstrom-Front", description: "Kräftige vierachsige Schnellzuglokomotive mit glatten Seitenwänden vor klassischen IC-Wagen."),
                SpotterFeature(icon: "antenna.radiowaves.left.and.right", title: "Schraubenkupplung & Puffer", description: "Klassische Zug- und Stoßeinrichtung an beiden Führerständen.")
            ]
            
        case _ where seriesCode.contains("146") || seriesCode.contains("147") || (commercialName.contains("Twindexx") && category == .highSpeed):
            return [
                SpotterFeature(icon: "arrow.up.and.down", title: "Weißer Doppelstock-Wendezug", description: "Fünfteilige Doppelstockgarnitur im weißen ICE-Farbschema, geschoben/gezogen von BR 146.5 oder 147.5."),
                SpotterFeature(icon: "arrow.up.left.and.down.right.magnifyingglass", title: "Panoramablick im Oberdeck", description: "Große Fenster im Obergeschoss bieten weite Sicht über Lärmschutzwände.")
            ]
            
        case _ where seriesCode.contains("4110") || commercialName.contains("KISS"):
            return [
                SpotterFeature(icon: "bolt.fill", title: "Stadler-KISS-Kopfform", description: "Doppelstock-Triebzug (ohne separate Lok) mit dynamisch geschwungener Schweizer Front."),
                SpotterFeature(icon: "hare.fill", title: "Spurtstarker 200-km/h-Dosto", description: "Angetriebene Drehgestelle unter den Endwagen sorgen für hohe Beschleunigung.")
            ]
            
        case _ where commercialName.contains("Nightjet"):
            return [
                SpotterFeature(icon: "moon.stars.fill", title: "Nachtblaues Sternendesign", description: "Dunkelblaue Lackierung mit feinem Sternenhimmel-Dekor und roter Kontrastlinie."),
                SpotterFeature(icon: "bed.double.fill", title: "Versetzte Mini-Cabin-Fenster", description: "Am Liegewagen sind die zweistöckig versetzten Fenster der Einzel-Schlafkapseln erkennbar.")
            ]
            
        // MARK: - 4. Regionalverkehr & S-Bahn
        case _ where seriesCode.contains("462") || commercialName.contains("Desiro HC"):
            return [
                SpotterFeature(icon: "arrow.up.arrow.down.square", title: "Einstöckig außen, Dosto innen", description: "Markantes Hybrid-Profil: Die beiden angetriebenen Endwagen sind einstöckig, die Mittelwagen doppelstöckig."),
                SpotterFeature(icon: "lightbulb.fill", title: "Schräge LED-Scheinwerfer", description: "Typisches Siemens-Desiro-Gesicht mit großer Zielanzeige hinter der Frontscheibe.")
            ]
            
        case _ where seriesCode.contains("442") || commercialName.contains("Talent 2"):
            return [
                SpotterFeature(icon: "face.smiling", title: "„Hamsterbacken“-Wölbung", description: "Kräftig nach außen gewölbte Seitenpartien an der Front gaben ihm seinen berühmten Spitznamen."),
                SpotterFeature(icon: "arrow.down.to.line", title: "Jakobs-Drehgestelle", description: "Wagenkästen liegen an den Übergängen gemeinsam auf einem Drehgestell auf.")
            ]
            
        case _ where seriesCode.contains("1428") || seriesCode.contains("1429") || commercialName.contains("FLIRT"):
            return [
                SpotterFeature(icon: "windshield.front.and.heat.waves", title: "Kantige Stadler-Front", description: "Steile, aerodynamische Frontscheibe mit tief sitzenden LED-Scheinwerfern."),
                SpotterFeature(icon: "tram.fill", title: "Große Panoramafenster", description: "Durchgehend helle Niederflur-Großräume mit stufenlosen Wagenübergängen.")
            ]
            
        case _ where seriesCode.contains("463") || commercialName.contains("Mireo"):
            return [
                SpotterFeature(icon: "leaf.fill", title: "Scharf geschnittene Leichtbau-Nase", description: "Markante horizontale Bügelfalte an der Front mit schmalen LED-Lichtleisten."),
                SpotterFeature(icon: "bolt.batteryblock.fill", title: "Auch als Plus B / Plus H", description: "Verkehrt vielerorts auch als Batterie-Hybrid (BR 563) auf teil-elektrifizierten Strecken.")
            ]
            
        case _ where seriesCode.contains("445") || seriesCode.contains("446") || commercialName.contains("Twindexx Vario"):
            return [
                SpotterFeature(icon: "arrow.up.and.down", title: "Angetriebene Dosto-Endwagen", description: "Doppelstockzug ohne Lokomotive: Die Endwagen (BR 445/446) besitzen eigene Dachstromabnehmer und Motoren."),
                SpotterFeature(icon: "person.3.fill", title: "Hohe Pendlerkapazität", description: "Durchgehend doppelstöckiger Zugverband im Verkehrsrot oder Landesdesign.")
            ]

        case _ where seriesCode.contains("1440") || commercialName.contains("Coradia Continental"):
            return [
                SpotterFeature(icon: "face.smiling.inverse", title: "„Grinsekatze“-Front", description: "Die geschwungene Scheinwerfer- und Kühlerpartie der neueren Bauserie erinnert an ein breites Lächeln."),
                SpotterFeature(icon: "arrow.up.to.line", title: "Dach-Technikcontainer", description: "fast die gesamte Antriebs- und Klimatechnik sitzt auf dem Dach für durchgehenden Niederflurboden.")
            ]
            
        case _ where seriesCode.contains("423") || seriesCode.contains("430") || commercialName.contains("S-Bahn"):
            return [
                SpotterFeature(icon: "door.left.hand.open", title: "12 Türen pro Zugseite", description: "Drei Doppelschwenkschiebetüren je Wagenkasten für sekundenschnellen Fahrgastwechsel."),
                SpotterFeature(icon: "rectangle.compress.vertical", title: "96-cm-Hochflur-Einstieg", description: "Speziell für die Hochbahnsteige der S-Bahn-Stammstrecken konstruiert.")
            ]
            
        case _ where seriesCode.contains("425") || commercialName.contains("ET 425"):
            return [
                SpotterFeature(icon: "speaker.wave.3.fill", title: "Unverwechselbares „Quietschie“-Heulen", description: "Charakteristisches elektronisches Anfahr- und Bremsgeräusch der Stromrichter."),
                SpotterFeature(icon: "rectangle.portrait.split.2x1", title: "Zwei Türen pro Wagenseite", description: "Optisch eng verwandt mit der BR 423, aber mit nur zwei Türen je Wagen und Trittstufen für Regionalbahnsteige.")
            ]
            
        case _ where seriesCode.contains("622") || seriesCode.contains("648") || commercialName.contains("LINT"):
            return [
                SpotterFeature(icon: "engine.combustion", title: "Unterflur-Dieselmotoren", description: "Markantes Dieselgeräusch beim Beschleunigen auf nicht elektrifizierten Strecken."),
                SpotterFeature(icon: "car.side.fill", title: "Kompakter 1- bis 3-Teiler", description: "Niederflur-Einstiegsbereich zwischen den Drehgestellen und große Seitenfenster.")
            ]
            
        default:
            return [
                SpotterFeature(icon: "tag.fill", title: "Baureihe & Anschrift", description: "Die Baureihennummer (\(seriesCode)) findest du seitlich an den Endwagen angeschrieben."),
                SpotterFeature(icon: "speedometer", title: "Höchstgeschwindigkeit", description: "Ausgelegt für bis zu \(maxSpeedKmH ?? 160) km/h im planmäßigen Streckendienst.")
            ]
        }
    }
}
