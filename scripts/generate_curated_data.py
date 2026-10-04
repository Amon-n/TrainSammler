import json
import os

# Complete photo dictionary
PHOTOS = {
    # Special & Test
    "ice_regenbogen": {
        "asset": "ice_regenbogen",
        "label": "Hauptansicht (Strecke)",
        "feature": "Der berühmte ICE 3 mit sechsfarbigem Regenbogen-Zierstreifen für Toleranz und Vielfalt.",
        "author": "Johannes Maximilian",
        "license": "CC BY-SA 4.0",
        "url": "https://commons.wikimedia.org/wiki/File:DB_403_026_2024-08-02_JM_5D413719.jpg"
    },
    "ice_regenbogen_detail": {
        "asset": "ice_regenbogen_detail",
        "label": "Regenbogen-Zierstreifen & Front",
        "feature": "Der charakteristische sechsfarbige Streifen und die Haifischnase des Triebzuges 304 München.",
        "author": "Jedesto",
        "license": "CC BY-SA 4.0",
        "url": "https://commons.wikimedia.org/wiki/File:Regenbogen-ICE_in_Stuttgart.jpg"
    },
    "ice_europa": {
        "asset": "ice_europa",
        "label": "Hauptansicht (Europa-Zierstreifen)",
        "feature": "ICE 3M Triebzug mit blauem Europa-Streifen und europäischen Sternen als Botschafter für ein vereintes Europa.",
        "author": "LWChris",
        "license": "CC BY 4.0",
        "url": "https://commons.wikimedia.org/wiki/File:DB_406_501_2024-08-02_JM_5D413712.jpg"
    },
    "ice_europa_detail": {
        "asset": "ice_europa_detail",
        "label": "Europa-Sterne & Flagge",
        "feature": "Die europäischen Sterne und der blaue Kontraststreifen am Triebkopf von Tz 4601.",
        "author": "universalamateur / LWChris",
        "license": "CC BY-SA 4.0",
        "url": "https://commons.wikimedia.org/wiki/File:ICE_%22Europa-Europe%22_End_2.jpg"
    },
    "ice_4_brd": {
        "asset": "ice_4_brd",
        "label": "Jubiläumsdesign (Schwarz-Rot-Gold)",
        "feature": "Feierlicher Jubiläums-ICE 4 mit schwarz-rot-goldener Flaggen-Linierung an beiden Endwagen.",
        "author": "Geogast",
        "license": "CC BY 4.0",
        "url": "https://commons.wikimedia.org/wiki/File:ICE_Bundesrepublik_Deutschland.jpg"
    },
    "ice_female_cab": {
        "asset": "ice_female_cab",
        "label": "Female ICE Triebkopf",
        "feature": "Triebkopf Tz 9015 Mainz mit der auffälligen Female-ICE-Symbolbeklebung.",
        "author": "Foobian",
        "license": "CC BY-SA 4.0",
        "url": "https://commons.wikimedia.org/wiki/File:Female_ICE_driving_end.jpg"
    },
    "ice_female_restaurant": {
        "asset": "ice_female_restaurant",
        "label": "Bordrestaurant Tz 9015",
        "feature": "Speisewagen mit besonderem Aktionsdesign zur Frauenförderung im Schienenverkehr.",
        "author": "Foobian",
        "license": "CC BY-SA 4.0",
        "url": "https://commons.wikimedia.org/wiki/File:Female_ICE_Bordrestaurant.jpg"
    },
    "ice_s": {
        "asset": "ice_s",
        "label": "Hochgeschwindigkeits-Messzug",
        "feature": "Erprobungszug der DB Systemtechnik für Geschwindigkeiten bis 393 km/h.",
        "author": "Bvcmz248.5 / DB Systemtechnik",
        "license": "CC0 / Public Domain",
        "url": "https://commons.wikimedia.org/wiki/File:ICE_S_410.jpg"
    },
    "ice_s_run": {
        "asset": "ice_s_run",
        "label": "Messfahrt bei 300+ km/h",
        "feature": "Erprobungszug der DB Systemtechnik bei einer Hochgeschwindigkeits-Testfahrt auf der Schnellfahrstrecke.",
        "author": "Sebastian Terfloth User:Sese_Ingolstadt",
        "license": "CC BY-SA 4.0",
        "url": "https://commons.wikimedia.org/wiki/File:ICE_S_Geisbergtunnel.jpg"
    },
    "ice_605_trainlab": {
        "asset": "ice_605_trainlab",
        "label": "Fahrendes Digitallabor",
        "feature": "Ehemaliger dieselgetriebener ICE-TD mit Kameras, Lidar und Sensoren am Triebkopf.",
        "author": "Anton B. Krüger",
        "license": "CC BY-SA 4.0",
        "url": "https://commons.wikimedia.org/wiki/File:Das_advanced_TrainLab_mit_Sensorik_am_Endwagen.jpg"
    },
    "ice_605_sensors": {
        "asset": "ice_605_sensors",
        "label": "Messfahrt & Sensorik",
        "feature": "Ehemaliger ICE-TD Triebzug bei der Sensor-Erprobung mit 5G-Antennen auf freier Strecke.",
        "author": "Bybbisch94, Christian Gebhardt",
        "license": "CC BY-SA 4.0",
        "url": "https://commons.wikimedia.org/wiki/File:20230916.Advanced_TrainLab.-011.jpg"
    },

    # ICE-Flotte
    "ice_1": {
        "asset": "ice_1",
        "label": "Hauptansicht (Berlin Hbf)",
        "feature": "Der Ur-ICE von 1991 im Jubiläumsdesign bei der Ausfahrt aus Berlin Hbf.",
        "author": "Matti Blume",
        "license": "CC BY-SA 4.0",
        "url": "https://commons.wikimedia.org/wiki/File:ICE_1_Berlin_Hbf.jpg"
    },
    "ice_1_powerhead": {
        "asset": "ice_1_powerhead",
        "label": "Klassischer Triebkopf",
        "feature": "Charakteristische, geschwungene Nase des Triebkopfes 401 mit DB-Keks ohne Fronttüren.",
        "author": "Yannick Bammert",
        "license": "CC BY 2.0",
        "url": "https://commons.wikimedia.org/wiki/File:Triebkopf_ICE_1_(4872423367).jpg"
    },
    "ice_1_restaurant": {
        "asset": "ice_1_restaurant",
        "label": "Buckelspeisewagen",
        "feature": "Das unverkennbare Bordrestaurant mit erhöhtem Dach – das absolute Wahrzeichen des ICE 1.",
        "author": "Ra Boe / Wikipedia",
        "license": "CC BY-SA 3.0 de",
        "url": "https://commons.wikimedia.org/wiki/File:Deutsche_Bahn_ICE_2020_-DBAG_Class_401_Speisewagen-_by_RaBoe00102.jpg"
    },
    "ice_1_interior": {
        "asset": "ice_1_interior",
        "label": "Fahrgastabteil Redesign",
        "feature": "Modernisierter Fahrgastraum im Lebensdauerverlängerungs-Programm (LDV).",
        "author": "MaxEmanuel",
        "license": "CC0 / Public Domain",
        "url": "https://commons.wikimedia.org/wiki/File:ICE_1-Abteil_zweiter_Klasse_nach_zweitem_Redesign.jpg"
    },
    "ice_2": {
        "asset": "ice_2",
        "label": "Hauptansicht (Berlin Hbf)",
        "feature": "Halbzug mit Triebkopf und Steuerwagen für das flexible Flügelungskonzept.",
        "author": "RAIL P / Matti Blume",
        "license": "CC0 / CC BY-SA 4.0",
        "url": "https://commons.wikimedia.org/wiki/File:ICE_2_Berlin_Hbf.jpg"
    },
    "ice_2_cab": {
        "asset": "ice_2_cab",
        "label": "Steuerwagen 808 Front",
        "feature": "Der Steuerwagen mit integriertem Führerstand und Fahrgastabteil am Zugende.",
        "author": "Falk2",
        "license": "CC BY-SA 4.0",
        "url": "https://commons.wikimedia.org/wiki/File:J33_160_Bf_Hannover_Hbf,_808_003.jpg"
    },
    "ice_2_front": {
        "asset": "ice_2_front",
        "label": "Fahrgastraum Steuerwagen",
        "feature": "Reiseabteil im Steuerwagen mit charakteristischer Deckenbeleuchtung und bequemen Sitzen.",
        "author": "L. Willms",
        "license": "CC BY 3.0",
        "url": "https://commons.wikimedia.org/wiki/File:Passenger_compartment_of_an_ICE-2_driving_van_trailer.jpg"
    },
    "ice_3_sfs": {
        "asset": "ice_3_sfs",
        "label": "Schnellfahrstrecke 300 km/h",
        "feature": "Der Hochgeschwindigkeits-Klassiker mit 300 km/h auf der KRM-Neubaustrecke bei Weilbach.",
        "author": "Mylius / Joachim Seyferth",
        "license": "CC BY-SA 3.0",
        "url": "https://commons.wikimedia.org/wiki/File:ICE_3_auf_der_Schnellfahrstrecke_K%C3%B6ln_-_Rhein-Main_bei_Weilbach.jpg"
    },
    "ice_3_lounge": {
        "asset": "ice_3_lounge",
        "label": "Lounge mit Lokführerblick",
        "feature": "Einzigartiger Lounge-Blick durch die Panoramascheibe direkt auf die Strecke.",
        "author": "Sebastian Terfloth User:Sese_Ingolstadt",
        "license": "CC BY-SA 3.0",
        "url": "https://commons.wikimedia.org/wiki/File:Lounge_ICE_3.jpg"
    },
    "ice_3m_multi": {
        "asset": "ice_3m_multi",
        "label": "Mehrsystem-Dachausrüstung",
        "feature": "Vier verschiedene Dachstromabnehmer für Bahnstrom in Deutschland, Frankreich, Belgien und den Niederlanden.",
        "author": "InterCityExpress / Felix O",
        "license": "CC BY-SA 2.0",
        "url": "https://commons.wikimedia.org/wiki/File:406_001_-_DB_Fernverkehr_--_Eschweiler_-_2._April_2014_(14304734175).jpg"
    },
    "ice_3_velaro": {
        "asset": "ice_3_velaro",
        "label": "Aerodynamische Front",
        "feature": "Fließende Velaro-Kopfform für minimalen Luftwiderstand und internationale Zulassung.",
        "author": "Stephan Preißler",
        "license": "CC BY-SA 3.0",
        "url": "https://commons.wikimedia.org/wiki/File:DBAG_Class_407.jpg"
    },
    "ice_407_interior": {
        "asset": "ice_407_interior",
        "label": "Velaro D Fahrgastraum",
        "feature": "Moderne 2. Klasse des Siemens Velaro D mit ergonomischen Sitzen und Deckenmonitoren.",
        "author": "Florian Bausch",
        "license": "CC BY-SA 3.0",
        "url": "https://commons.wikimedia.org/wiki/File:DBAG_Class_407_interior_2nd_2014-01.jpg"
    },
    "ice_3neo": {
        "asset": "ice_3neo",
        "label": "Hauptansicht (Köln Messe/Deutz)",
        "feature": "Modernste Weiterentwicklung der Siemens-Velaro-Plattform mit 320 km/h.",
        "author": "TheFrog001",
        "license": "CC0 / Public Domain",
        "url": "https://commons.wikimedia.org/wiki/File:ICE_3neo_DB_408.jpg"
    },
    "ice_3neo_interior": {
        "asset": "ice_3neo_interior",
        "label": "Neues DB-Innendesign",
        "feature": "Neues Designkonzept der Deutschen Bahn mit Holztönen, warmen Stoffen und Tablet-Haltern.",
        "author": "MaxEmanuel",
        "license": "CC0 / Public Domain",
        "url": "https://commons.wikimedia.org/wiki/File:DBAG_Class_408_Interior.jpg"
    },
    "ice_t": {
        "asset": "ice_t",
        "label": "Streckenfahrt (Maria Anzbach)",
        "feature": "Mit Neigetechnik ausgestatteter ICE für bogenreiche Strecken.",
        "author": "Linie29",
        "license": "CC BY-SA 4.0",
        "url": "https://commons.wikimedia.org/wiki/File:DB_Class_411_ICE-T.jpg"
    },
    "ice_4": {
        "asset": "ice_4",
        "label": "Hauptansicht (Berlin Hbf)",
        "feature": "Das moderne Arbeitspferd im DB-Fernverkehr mit hoher Energieeffizienz.",
        "author": "Peter Nath / Reinhold Möller",
        "license": "CC BY 4.0",
        "url": "https://commons.wikimedia.org/wiki/File:ICE_4_Berlin_Hbf.jpg"
    },
    "ice_4_front": {
        "asset": "ice_4_front",
        "label": "Kantige Frontpartie",
        "feature": "Die markante, kantig-aerodynamische Kopfform der Baureihe 412 mit LED-Lichtband.",
        "author": "Martin Lechler",
        "license": "CC BY-SA 4.0",
        "url": "https://commons.wikimedia.org/wiki/File:ICE4_Front.jpg"
    },
    "ice_4_altengronau": {
        "asset": "ice_4_altengronau",
        "label": "Streckenfahrt bei Altengronau",
        "feature": "Moderne Zugbildung im Hochgeschwindigkeits-Netz der DB in Hessen.",
        "author": "Joachim Seyferth",
        "license": "CC BY 4.0",
        "url": "https://commons.wikimedia.org/wiki/File:ICE_4_Altengronau.jpg"
    },
    "ice_4_interior": {
        "asset": "ice_4_interior",
        "label": "ICE 4 Fahrgastbereich",
        "feature": "Großzügiger Fahrgastraum mit flexibler Sitzplatzanordnung und modernem Raumklima.",
        "author": "Robot8A / Joachim Seyferth",
        "license": "CC BY-SA 4.0",
        "url": "https://commons.wikimedia.org/wiki/File:ICE_4_(29690076593).jpg"
    },
    "ice_l": {
        "asset": "ice_l",
        "label": "Lokomotive 105 019",
        "feature": "Lokomotive der neuesten Generation barrierefreier Fernverkehrszüge von Talgo.",
        "author": "Sven-IngCH",
        "license": "CC BY-SA 4.0",
        "url": "https://commons.wikimedia.org/wiki/File:ICE_L_105.jpg"
    },
    "ice_l_cab": {
        "asset": "ice_l_cab",
        "label": "ICE L Steuerwagen",
        "feature": "Modernster Steuerwagen von Talgo für den Wendezugbetrieb auf Urlaubsstrecken.",
        "author": "E235JREMU",
        "license": "CC BY-SA 4.0",
        "url": "https://commons.wikimedia.org/wiki/File:ICE_L_SteuerwagenLV_12.23.jpg"
    },
    "ice_l_side": {
        "asset": "ice_l_side",
        "label": "Talgo-Niederflurwagen",
        "feature": "Stufenloser Einstieg direkt auf Höhe der Standardbahnsteige.",
        "author": "Sven-IngCH",
        "license": "CC BY-SA 4.0",
        "url": "https://commons.wikimedia.org/wiki/File:ICE_L_Talgo.jpg"
    },
    "ice_l_interior": {
        "asset": "ice_l_interior",
        "label": "Stufenloser Niederflur-Einstieg",
        "feature": "Barrierefreier Fahrgastraum mit ebenem Boden ohne Stufen zwischen den Wagen.",
        "author": "Pablo Lopez Estape",
        "license": "CC BY-SA 4.0",
        "url": "https://commons.wikimedia.org/wiki/File:Talgo_230_DB_ICE-L_at_InnoTrans_2022_05.jpg"
    },

    # Intercity
    "br_101": {
        "asset": "br_101",
        "label": "Hauptansicht Streckenlok",
        "feature": "Die legendäre Schnellzuglokomotive der 90er Jahre vor traditionellen Intercity-Wagen.",
        "author": "Lars Steffens",
        "license": "CC BY-SA 2.0",
        "url": "https://commons.wikimedia.org/wiki/File:DB_Class_101.jpg"
    },
    "br_101_cab": {
        "asset": "br_101_cab",
        "label": "BR 101 Führerstand",
        "feature": "Echter Führertisch der Baureihe 101 mit Fahrschalter, Ebula-Display und MFA-Instrumenten.",
        "author": "Sebastian Terfloth User:Sese_Ingolstadt",
        "license": "CC BY 2.5",
        "url": "https://commons.wikimedia.org/wiki/File:DB_AG_101_F%C3%BChrerstand.jpg"
    },
    "twindexx_vario": {
        "asset": "twindexx_vario",
        "label": "Doppelstock-Wendezug",
        "feature": "Doppelstock-Garnitur mit Panoramablick aus dem oberen Stockwerk.",
        "author": "UMO1 / Foobian",
        "license": "CC BY-SA 4.0",
        "url": "https://commons.wikimedia.org/wiki/File:Twindexx_Vario.jpg"
    },
    "ic2_twindexx_cab": {
        "asset": "ic2_twindexx_cab",
        "label": "Weißer IC2 Steuerwagen",
        "feature": "Weiß lackierter Doppelstock-Steuerwagen im ICE-Farbkleid mit spitzer Nase.",
        "author": "Falk2",
        "license": "CC BY-SA 4.0",
        "url": "https://commons.wikimedia.org/wiki/File:J24_331_Sch%C3%B6nefelder_Gruppe,_DBpbzfa_668.2.jpg"
    },
    "ic2_kiss": {
        "asset": "ic2_kiss",
        "label": "Stadler KISS auf Strecke",
        "feature": "Spurtschneller Doppelstock-Triebzug aus der Schweiz im Intercity-Dienst.",
        "author": "Mirkone",
        "license": "CC BY-SA 4.0",
        "url": "https://commons.wikimedia.org/wiki/File:Stadler_KISS_DB_4110.jpg"
    },
    "ic2_kiss_front": {
        "asset": "ic2_kiss_front",
        "label": "Stadler KISS Front",
        "feature": "Kraftvoller Doppelstock-Triebkopf des Schweizer Herstellers Stadler im DB-Fernverkehr.",
        "author": "Zug Videos Bilder",
        "license": "CC BY-SA 4.0",
        "url": "https://commons.wikimedia.org/wiki/File:4110_110(2)_Kiss.jpg"
    },
    "ic2_kiss_wien": {
        "asset": "ic2_kiss_wien",
        "label": "BR 4110 Doppelstockzug",
        "feature": "Spurtschneller 6-teiliger Doppelstock-Triebzug am Bahnsteig.",
        "author": "Rosso Robot",
        "license": "CC BY-SA 4.0",
        "url": "https://commons.wikimedia.org/wiki/File:2021-06-18_Stadler_KISS_BR_4110_at_Wien_Hauptbahnhof.jpg"
    },
    "nightjet_viaggio": {
        "asset": "nightjet_viaggio",
        "label": "ÖBB Nightjet (Viaggio)",
        "feature": "Neuer Nachtzug der Zukunft im charakteristischen nachtblauen Siemens-Design.",
        "author": "TheFrog001",
        "license": "CC0 / Public Domain",
        "url": "https://commons.wikimedia.org/wiki/File:Siemens_Viaggio_Next_Level_%C3%96BB_nightjet_2023-12_-_05.jpg"
    },
    "nightjet_cab": {
        "asset": "nightjet_cab",
        "label": "Nightjet Steuerwagen",
        "feature": "Aerodynamischer Steuerwagen für den schnellen Wendezugbetrieb bei 230 km/h.",
        "author": "TheFrog001",
        "license": "CC0 / Public Domain",
        "url": "https://commons.wikimedia.org/wiki/File:Steuerwagen_Siemens_Viaggio_Next_Level_%C3%96BB_nightjet_2023-12_-_03.jpg"
    },
    "nightjet_minicabin": {
        "asset": "nightjet_minicabin",
        "label": "Mini-Cabin Schlafkapseln",
        "feature": "Die revolutionären Mini-Cabins für ungestörten Schlaf von Alleinreisenden im Nachtzug.",
        "author": "TheFrog001",
        "license": "CC0 / Public Domain",
        "url": "https://commons.wikimedia.org/wiki/File:Mini_cabin_coach_of_Siemens_Viaggio_Next_Level_%C3%96BB_nightjet_2023-12_-_06.jpg"
    },

    # Regional
    "desiro_hc": {
        "asset": "desiro_hc",
        "label": "Hauptansicht (Wuppertal Hbf)",
        "feature": "Rhein-Ruhr-Express Triebzug im modernen RRX-Farbdesign.",
        "author": "Gsadfaw1223",
        "license": "CC BY-SA 4.0",
        "url": "https://commons.wikimedia.org/wiki/File:Siemens_Desiro_HC_RRX.jpg"
    },
    "desiro_hc_hybrid": {
        "asset": "desiro_hc_hybrid",
        "label": "Hybrid-Wagenzug (Dosto & Flach)",
        "feature": "Übergang vom einstöckigen Endwagen zum doppelstöckigen Mittelwagen – die Besonderheit des Desiro HC.",
        "author": "Falk2",
        "license": "CC BY-SA 4.0",
        "url": "https://commons.wikimedia.org/wiki/File:J33_779_Desiro_HC_(462_083).jpg"
    },
    "desiro_hc_interior": {
        "asset": "desiro_hc_interior",
        "label": "RRX Fahrgastraum",
        "feature": "Moderner Rhein-Ruhr-Express Innenraum mit Steckdosen, Monitoren und Leselampen.",
        "author": "Sacrety",
        "license": "CC BY-SA 4.0",
        "url": "https://commons.wikimedia.org/wiki/File:RRX_2.Klasse.jpg"
    },
    "talent_2": {
        "asset": "talent_2",
        "label": "Hauptansicht (Hennigsdorf)",
        "feature": "Charakteristischer Regionaltriebzug von Bombardier im RE- und S-Bahn-Einsatz.",
        "author": "Sebastian Rittau",
        "license": "CC0 / Public Domain",
        "url": "https://commons.wikimedia.org/wiki/File:Bombardier_Talent_2.jpg"
    },
    "talent_2_front": {
        "asset": "talent_2_front",
        "label": "Charakteristische Hamsterbacke",
        "feature": "Die prägnante, tiefgezogene Kopfform, die dem Bombardier Talent 2 seinen Kult-Kosenamen gab.",
        "author": "Matti Blume",
        "license": "CC BY-SA 4.0",
        "url": "https://commons.wikimedia.org/wiki/File:Talent,_Stralsund_(LRM_20240104_140825).jpg"
    },
    "talent_2_interior": {
        "asset": "talent_2_interior",
        "label": "Fahrgastraum & Niederflur",
        "feature": "Niederfluriger Einstiegsbereich mit Jakobs-Drehgestellübergang und bequemen Sitzen.",
        "author": "Falk2",
        "license": "CC BY-SA 4.0",
        "url": "https://commons.wikimedia.org/wiki/File:I11_333_Bombardier_Talent_2,_Innenraum.jpg"
    },
    "flirt_3": {
        "asset": "flirt_3",
        "label": "Hauptansicht Streckenfahrt",
        "feature": "Spurtschneller Niederflurtriebzug mit hervorragender Beschleunigung.",
        "author": "Johannes Maximilian",
        "license": "CC BY-SA 4.0",
        "url": "https://commons.wikimedia.org/wiki/File:Stadler_FLIRT_3.jpg"
    },
    "flirt_3_front": {
        "asset": "flirt_3_front",
        "label": "FLIRT 3 Frontpartie",
        "feature": "Markante, kantige Stadler-FLIRT-Kopfform im schnittigen SÜWEX-Design mit LED-Leuchten.",
        "author": "Hoff1980",
        "license": "CC BY-SA 3.0",
        "url": "https://commons.wikimedia.org/wiki/File:S%C3%BCwex_Flirt_Mannheim_Hbf.JPG"
    },
    "flirt_3_interior": {
        "asset": "flirt_3_interior",
        "label": "Großraum-Fahrgastabteil",
        "feature": "Heller, stufenloser Innenraum mit Jakobs-Gelenken und Panoramaverglasung.",
        "author": "JoachimKohler-HB",
        "license": "CC BY-SA 4.0",
        "url": "https://commons.wikimedia.org/wiki/File:Fahrgastraum_eines_Stadler_FLIRT_3_XL_der_NWB_(2024).jpg"
    },
    "mireo": {
        "asset": "mireo",
        "label": "Hauptansicht Neufahrzeug",
        "feature": "Extrem energieeffizienter, leichter Nahverkehrszug.",
        "author": "Joachim Lutz",
        "license": "CC BY-SA 4.0",
        "url": "https://commons.wikimedia.org/wiki/File:Siemens_Mireo.jpg"
    },
    "mireo_front": {
        "asset": "mireo_front",
        "label": "Mireo Aerodynamik-Front",
        "feature": "Energieeffiziente, windschnittige Kopfform der Siemens-Mireo-Familie im bwegt-Design.",
        "author": "Kevin.B",
        "license": "CC BY-SA 4.0",
        "url": "https://commons.wikimedia.org/wiki/File:Mireo_Bwegt_-_Offenburg.jpg"
    },
    "mireo_interior": {
        "asset": "mireo_interior",
        "label": "Mireo Fahrgastraum",
        "feature": "Großzügiges Leichtbau-Fahrgastabteil mit moderner LED-Ambientebeleuchtung.",
        "author": "MireoDriver",
        "license": "CC BY-SA 4.0",
        "url": "https://commons.wikimedia.org/wiki/File:FahrgastraumMireoNetz4.jpg"
    },
    "twindexx_regio_cab": {
        "asset": "twindexx_regio_cab",
        "label": "Twindexx Vario Triebwagen",
        "feature": "Angetriebener Doppelstock-Endwagen (BR 445) mit vollwertigem Antrieb unter den Drehgestellen.",
        "author": "Malte Hübner",
        "license": "CC BY-SA 4.0",
        "url": "https://commons.wikimedia.org/wiki/File:Twindexx_445_013_Nortorf.jpg"
    },
    "coradia_continental": {
        "asset": "coradia_continental",
        "label": "Coradia Continental (BR 1440)",
        "feature": "Elektrischer Triebzug mit dem markanten, freundlichen Frontlächeln („Grinsekatze“).",
        "author": "Metrophil44",
        "license": "CC BY-SA 4.0",
        "url": "https://commons.wikimedia.org/wiki/File:DB-Baureihe_1440-Alstom_Coradia_Continental_in_Hagen_Hbf.jpg"
    },
    "coradia_continental_front": {
        "asset": "coradia_continental_front",
        "label": "Grinsekatze Frontpartie",
        "feature": "Geschwungene Scheinwerfermaske und aerodynamische Kopfform der Baureihe 1440.",
        "author": "Der Messer",
        "license": "CC BY-SA 4.0",
        "url": "https://commons.wikimedia.org/wiki/File:Alstom_Coradia_Continental_(1440)_am_Bw_Aachen.jpg"
    },
    "coradia_lint": {
        "asset": "coradia_lint",
        "label": "Streckenfahrt LINT 27",
        "feature": "Der unbestrittene König nicht elektrifizierter Nebenbahnen im ländlichen Raum.",
        "author": "Spudgun67",
        "license": "CC BY-SA 4.0",
        "url": "https://commons.wikimedia.org/wiki/File:Alstom_Coradia_LINT.jpg"
    },
    "coradia_lint_front": {
        "asset": "coradia_lint_front",
        "label": "LINT Triebwagen-Front",
        "feature": "Charakteristische Nahverkehrs-Diesel-Front mit hochgesetzter Scheibe und Scharfenbergkupplung.",
        "author": "EM311",
        "license": "CC BY-SA 4.0",
        "url": "https://commons.wikimedia.org/wiki/File:DB_Regio_623_505_Alstom_Coradia_LINT_Weinheim.jpg"
    },
    "coradia_lint_interior": {
        "asset": "coradia_lint_interior",
        "label": "LINT 41 Innenraum",
        "feature": "Moderner Regional-Fahrgastraum für Nebenstrecken mit großflächigen Fenstern.",
        "author": "Pentium1000~dewiki",
        "license": "CC BY-SA 4.0",
        "url": "https://commons.wikimedia.org/wiki/File:Innenraum_eines_modernisierten_LNVG_Lint_41.JPG"
    },
    "et_423": {
        "asset": "et_423",
        "label": "Streckenansicht S-Bahn",
        "feature": "Das unermüdliche Rückgrat der großen S-Bahn-Netze in Ballungsräumen.",
        "author": "Paul Smith",
        "license": "CC BY 2.0",
        "url": "https://commons.wikimedia.org/wiki/File:DBAG_Class_423.jpg"
    },
    "et_423_front": {
        "asset": "et_423_front",
        "label": "S-Bahn Frontpartie",
        "feature": "Kompakte, abgerundete Kopfform mit Zielanzeige für schnellen Fahrgastwechsel im S-Bahn-Netz.",
        "author": "Wikimedia-User Jivee Blau",
        "license": "CC BY-SA 4.0",
        "url": "https://commons.wikimedia.org/wiki/File:Mainz-Kastel-_Bahnhof-_auf_Br%C3%BCcke_der_Bundesstra%C3%9Fe_40-_Richtung_Frankfurt_am_Main-_DBAG-Baureihe_423_873-9_4.6.2010.jpg"
    },
    "et_423_interior": {
        "asset": "et_423_interior",
        "label": "S-Bahn Großraumwagen",
        "feature": "Durchgängiger Großraumtriebzug ohne Trenntüren mit Haltestangen für hohen Pendlerandrang.",
        "author": "User:Mattes",
        "license": "Public Domain",
        "url": "https://commons.wikimedia.org/wiki/File:S-Bahn_M%C3%BCnchen,_Klasse_423,_Waggon_2._Klasse,_innen_%E2%80%94_2005.jpg"
    },
    "et_425": {
        "asset": "et_425",
        "label": "Hauptansicht Weinheim",
        "feature": "Kult-Regionalbahn mit unverwechselbarem Frequenzumrichter-Quietschen beim Anfahren.",
        "author": "Photographs by Radosław Drożdżewski (User:Zwiadowca21)",
        "license": "CC BY-SA 4.0",
        "url": "https://commons.wikimedia.org/wiki/File:DB_Baureihe_425.jpg"
    },
    "et_425_front": {
        "asset": "et_425_front",
        "label": "ET 425 Front & Falttüren",
        "feature": "Flache, steile Frontpartie und zahlreiche Außenschwenktüren für schnelle Halte.",
        "author": "Photographs by Radosław Drożdżewski (User:Zwiadowca21)",
        "license": "CC BY-SA 4.0",
        "url": "https://commons.wikimedia.org/wiki/File:Bahnhof_Weinheim_-_DB-Baureihe_425_-_425-818_-_2019-02-13_14-46-41.jpg"
    },
    "et_425_interior": {
        "asset": "et_425_interior",
        "label": "ET 425 Innenraum",
        "feature": "Klassischer Regionalbahn-Innenraum mit Klappsitzen im Mehrzweckbereich.",
        "author": "Wikimedia-User Jivee Blau",
        "license": "CC BY-SA 3.0",
        "url": "https://commons.wikimedia.org/wiki/File:DBAG-Baureihe_425-_Interieur.JPG"
    }
}

# Mapping for each series code
SERIES_MAP = [
    ("403 (Tz 304)", ["ice_regenbogen", "ice_regenbogen_detail", "ice_3_lounge"]),
    ("406 (Tz 4601)", ["ice_europa", "ice_europa_detail", "ice_3m_multi"]),
    ("412 (Tz 9457)", ["ice_4_brd", "ice_4_altengronau", "ice_4_interior"]),
    ("412 (Tz 9015)", ["ice_4", "ice_female_cab", "ice_female_restaurant"]),
    ("410", ["ice_s", "ice_s_run"]),
    ("605", ["ice_605_trainlab", "ice_605_sensors"]),
    ("408", ["ice_3neo", "ice_3neo_interior"]),
    ("407", ["ice_3_velaro", "ice_407_interior"]),
    ("403", ["ice_3_sfs", "ice_3_lounge", "ice_3_velaro"]),
    ("406", ["ice_europa", "ice_3m_multi", "ice_3_lounge"]),
    ("412 (XXL)", ["ice_4", "ice_4_altengronau", "ice_4_front"]),
    ("412 (K7)", ["ice_4", "ice_4_front", "ice_4_interior"]),
    ("412", ["ice_4", "ice_4_front", "ice_4_altengronau", "ice_4_interior"]),
    ("411", ["ice_t", "ice_3_lounge"]),
    ("415", ["ice_t", "ice_3_lounge"]),
    ("401", ["ice_1", "ice_1_powerhead", "ice_1_restaurant", "ice_1_interior"]),
    ("402", ["ice_2", "ice_2_cab", "ice_2_front"]),
    ("105", ["ice_l", "ice_l_cab", "ice_l_side", "ice_l_interior"]),
    ("101", ["br_101", "br_101_cab"]),
    ("146", ["twindexx_vario", "ic2_twindexx_cab"]),
    ("147", ["twindexx_vario", "ic2_twindexx_cab"]),
    ("4110", ["ic2_kiss", "ic2_kiss_front", "ic2_kiss_wien"]),
    ("Nightjet", ["nightjet_viaggio", "nightjet_cab", "nightjet_minicabin"]),
    ("462", ["desiro_hc", "desiro_hc_hybrid", "desiro_hc_interior"]),
    ("442", ["talent_2", "talent_2_front", "talent_2_interior"]),
    ("1428", ["flirt_3", "flirt_3_front", "flirt_3_interior"]),
    ("1429", ["flirt_3", "flirt_3_front", "flirt_3_interior"]),
    ("463", ["mireo", "mireo_front", "mireo_interior"]),
    ("445", ["twindexx_vario", "twindexx_regio_cab"]),
    ("446", ["twindexx_vario", "twindexx_regio_cab"]),
    ("1440", ["coradia_continental", "coradia_continental_front"]),
    ("622", ["coradia_lint", "coradia_lint_front", "coradia_lint_interior"]),
    ("648", ["coradia_lint", "coradia_lint_front", "coradia_lint_interior"]),
    ("423", ["et_423", "et_423_front", "et_423_interior"]),
    ("430", ["et_423", "et_423_front", "et_423_interior"]),
    ("425", ["et_425", "et_425_front", "et_425_interior"])
]

print("Data structures configured.")
