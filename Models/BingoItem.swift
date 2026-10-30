import Foundation
import SwiftUI

public enum BingoRarity: String, Codable, CaseIterable, Sendable {
    case everyday // Sehr häufig / Alltag (~65–90% Wahrscheinlichkeit)
    case common   // Häufig / Typisch DB (~35–60% Wahrscheinlichkeit)
    case uncommon // Gelegentlich (~10–30% Wahrscheinlichkeit)
    case rare     // Selten / Kuriosität (<10% Wahrscheinlichkeit)

    public var displayName: String {
        switch self {
        case .everyday: return "Sehr häufig (Alltag)"
        case .common: return "Häufig (Typisch DB)"
        case .uncommon: return "Gelegentlich"
        case .rare: return "Selten (Rarität)"
        }
    }

    public var shortLabel: String {
        switch self {
        case .everyday: return "Alltag"
        case .common: return "Häufig"
        case .uncommon: return "Gelegentlich"
        case .rare: return "Selten"
        }
    }

    public var badgeColor: Color {
        switch self {
        case .everyday: return .green
        case .common: return .blue
        case .uncommon: return .orange
        case .rare: return .purple
        }
    }

    public var xpPoints: Int {
        switch self {
        case .everyday: return 15
        case .common: return 25
        case .uncommon: return 45
        case .rare: return 90
        }
    }

    public var defaultLikelihood: Int {
        switch self {
        case .everyday: return 75
        case .common: return 45
        case .uncommon: return 18
        case .rare: return 5
        }
    }
}

public struct BingoIncident: Identifiable, Sendable {
    public let id: String
    public let text: String
    public let iconName: String
    public let rarity: BingoRarity
    public let category: String
    /// Geschätzte Auftretenswahrscheinlichkeit pro Fahrt in Prozent (1–95)
    public let likelihoodPercent: Int
    /// Optionale Gruppe, damit sich sehr ähnliche Felder (z. B. mehrere reine Minuten-Verspätungen) nicht auf kleinen Brettern doppeln
    public let exclusivityGroup: String?

    public init(
        id: String,
        text: String,
        iconName: String,
        rarity: BingoRarity,
        category: String,
        likelihoodPercent: Int? = nil,
        exclusivityGroup: String? = nil
    ) {
        self.id = id
        self.text = text
        self.iconName = iconName
        self.rarity = rarity
        self.category = category
        self.likelihoodPercent = likelihoodPercent ?? rarity.defaultLikelihood
        self.exclusivityGroup = exclusivityGroup
    }
}

public struct BingoCatalog {
    public static let incidents: [BingoIncident] = [
        // =========================================================================
        // MARK: - 1. SEHR HÄUFIG / ALLTAG (Everyday, 65–92% Wahrscheinlichkeit)
        // Normale Ereignisse, die auf fast jeder Zugfahrt zu beobachten sind
        // =========================================================================

        // --- Verspätung & Fahrplan (Alltag) ---
        BingoIncident(
            id: "delay_3_min",
            text: "Mindestens 3 Min. Verspätung",
            iconName: "clock",
            rarity: .everyday,
            category: "Verspätung",
            likelihoodPercent: 85,
            exclusivityGroup: "delay_minutes"
        ),
        BingoIncident(
            id: "delay_5_min",
            text: "Mindestens 5 Min. Verspätung",
            iconName: "clock.badge.exclamationmark",
            rarity: .everyday,
            category: "Verspätung",
            likelihoodPercent: 78,
            exclusivityGroup: "delay_minutes"
        ),
        BingoIncident(
            id: "delay_10_min",
            text: "Mindestens 10 Min. Verspätung",
            iconName: "clock.arrow.circlepath",
            rarity: .everyday,
            category: "Verspätung",
            likelihoodPercent: 65,
            exclusivityGroup: "delay_minutes"
        ),
        BingoIncident(
            id: "punctual_start",
            text: "Pünktliche Abfahrt am Einstiegsbahnhof",
            iconName: "checkmark.circle",
            rarity: .everyday,
            category: "Fahrplan",
            likelihoodPercent: 72
        ),
        BingoIncident(
            id: "longer_station_dwell",
            text: "Haltezeit am Bahnhof dauert länger als geplant",
            iconName: "timer",
            rarity: .everyday,
            category: "Verspätung",
            likelihoodPercent: 80
        ),
        BingoIncident(
            id: "db_nav_refresh",
            text: "Blick in den DB Navigator zur Verbindungsprüfung",
            iconName: "iphone.gen3",
            rarity: .everyday,
            category: "Fahrplan",
            likelihoodPercent: 92
        ),
        BingoIncident(
            id: "red_time_in_app",
            text: "Rote Minutenanzeige im DB Navigator",
            iconName: "exclamationmark.circle",
            rarity: .everyday,
            category: "Verspätung",
            likelihoodPercent: 82
        ),
        BingoIncident(
            id: "stop_before_station",
            text: "Zug rollt langsam in den Bahnhof ein",
            iconName: "tortoise",
            rarity: .everyday,
            category: "Betrieb",
            likelihoodPercent: 88
        ),

        // --- Durchsagen & Service (Alltag) ---
        BingoIncident(
            id: "next_stop_announcement",
            text: "Durchsage: „Nächster Halt …“",
            iconName: "speaker.wave.2.fill",
            rarity: .everyday,
            category: "Ansage",
            likelihoodPercent: 95
        ),
        BingoIncident(
            id: "exit_direction_left_right",
            text: "Ansage: „Ausstieg in Fahrtrichtung links/rechts“",
            iconName: "arrow.left.and.right.square",
            rarity: .everyday,
            category: "Ansage",
            likelihoodPercent: 92
        ),
        BingoIncident(
            id: "welcome_announcement",
            text: "Zugbegleiter begrüßt neu zugestiegene Fahrgäste",
            iconName: "hand.wave.fill",
            rarity: .everyday,
            category: "Ansage",
            likelihoodPercent: 82
        ),
        BingoIncident(
            id: "english_announcement",
            text: "Durchsage wird auf Englisch wiederholt",
            iconName: "globe.europe.africa.fill",
            rarity: .everyday,
            category: "Ansage",
            likelihoodPercent: 78
        ),
        BingoIncident(
            id: "ticket_check_normal",
            text: "Fahrkartenkontrolle im Abteil / Wagen",
            iconName: "qrcode.viewfinder",
            rarity: .everyday,
            category: "Service",
            likelihoodPercent: 75
        ),
        BingoIncident(
            id: "connection_announcement",
            text: "Ansage der Anschlusszüge vor dem Bahnhof",
            iconName: "arrow.triangle.branch",
            rarity: .everyday,
            category: "Ansage",
            likelihoodPercent: 80
        ),
        BingoIncident(
            id: "farewell_announcement",
            text: "„Wir verabschieden uns von allen Fahrgästen, die aussteigen“",
            iconName: "megaphone",
            rarity: .everyday,
            category: "Ansage",
            likelihoodPercent: 76
        ),

        // --- Alltag im Wagen & Mitreisende ---
        BingoIncident(
            id: "seat_free_question",
            text: "Jemand fragt: „Ist hier noch frei?“",
            iconName: "bubble.left.and.bubble.right.fill",
            rarity: .everyday,
            category: "Fahrgäste",
            likelihoodPercent: 85
        ),
        BingoIncident(
            id: "backpack_on_seat",
            text: "Rucksack oder Tasche besetzt einen Nebensitz",
            iconName: "bag.fill",
            rarity: .everyday,
            category: "Fahrgäste",
            likelihoodPercent: 90
        ),
        BingoIncident(
            id: "laptop_worker",
            text: "Fahrgast arbeitet konzentriert am Laptop",
            iconName: "laptopcomputer",
            rarity: .everyday,
            category: "Fahrgäste",
            likelihoodPercent: 88
        ),
        BingoIncident(
            id: "sleeping_passenger",
            text: "Mitreisender schläft mit Kopf an der Scheibe",
            iconName: "zzz",
            rarity: .everyday,
            category: "Fahrgäste",
            likelihoodPercent: 78
        ),
        BingoIncident(
            id: "bakery_bag_snack",
            text: "Jemand packt Bäcker-Tüte oder belegtes Brötchen aus",
            iconName: "takeoutbag.and.cup.and.straw.fill",
            rarity: .everyday,
            category: "Verpflegung",
            likelihoodPercent: 86
        ),
        BingoIncident(
            id: "coffee_to_go_cup",
            text: "Coffee-to-go-Becher steht auf dem Klapptisch",
            iconName: "cup.and.saucer.fill",
            rarity: .everyday,
            category: "Verpflegung",
            likelihoodPercent: 88
        ),
        BingoIncident(
            id: "searching_seat_number",
            text: "Fahrgast läuft suchend durch den Gang & schaut auf Sitznummern",
            iconName: "magnifyingglass",
            rarity: .everyday,
            category: "Fahrgäste",
            likelihoodPercent: 85
        ),
        BingoIncident(
            id: "luggage_rack_lift",
            text: "Schwerer Koffer wird in die Gepäckablage gewuchtet",
            iconName: "suitcase.rolling.fill",
            rarity: .everyday,
            category: "Fahrgäste",
            likelihoodPercent: 80
        ),
        BingoIncident(
            id: "reading_book_newspaper",
            text: "Jemand liest ein gedrucktes Buch oder eine Zeitung",
            iconName: "book.fill",
            rarity: .everyday,
            category: "Fahrgäste",
            likelihoodPercent: 75
        ),
        BingoIncident(
            id: "headphones_everyone",
            text: "Mindestens 3 Personen im Umfeld tragen Kopfhörer",
            iconName: "headphones",
            rarity: .everyday,
            category: "Fahrgäste",
            likelihoodPercent: 92
        ),
        BingoIncident(
            id: "scrolling_ticket_qr",
            text: "Fahrgast sucht hektisch den Ticket-QR-Code am Handy",
            iconName: "qrcode",
            rarity: .everyday,
            category: "Fahrgäste",
            likelihoodPercent: 72
        ),
        BingoIncident(
            id: "standing_up_too_early",
            text: "Fahrgäste stehen schon 5 Min. vor dem Halt an der Tür",
            iconName: "figure.stand",
            rarity: .everyday,
            category: "Fahrgäste",
            likelihoodPercent: 86
        ),
        BingoIncident(
            id: "sunblind_pulled",
            text: "Sonnenrollo am Fenster wird heruntergezogen",
            iconName: "sun.max.fill",
            rarity: .everyday,
            category: "Komfort",
            likelihoodPercent: 68
        ),
        BingoIncident(
            id: "jacket_on_hook",
            text: "Jacke hängt am Kleiderhaken neben dem Fenster",
            iconName: "tshirt.fill",
            rarity: .everyday,
            category: "Komfort",
            likelihoodPercent: 84
        ),
        BingoIncident(
            id: "table_folded_down",
            text: "Klapptisch am Vordersitz wird heruntergeklappt",
            iconName: "rectangle.split.3x1",
            rarity: .everyday,
            category: "Komfort",
            likelihoodPercent: 90
        ),
        BingoIncident(
            id: "water_bottle_on_table",
            text: "Wasserflasche oder Thermoskanne steht auf dem Tisch",
            iconName: "waterbottle.fill",
            rarity: .everyday,
            category: "Verpflegung",
            likelihoodPercent: 88
        ),
        BingoIncident(
            id: "window_gazing",
            text: "Fahrgast schaut verträumt aus dem Fenster",
            iconName: "eye",
            rarity: .everyday,
            category: "Fahrgäste",
            likelihoodPercent: 90
        ),
        BingoIncident(
            id: "backpack_in_footwell",
            text: "Rucksack klemmt zwischen den Beinen im Fußraum",
            iconName: "backpack.fill",
            rarity: .everyday,
            category: "Komfort",
            likelihoodPercent: 86
        ),
        BingoIncident(
            id: "powerbank_charging",
            text: "Handy hängt an einer Powerbank",
            iconName: "battery.100percent.bolt",
            rarity: .everyday,
            category: "Technik",
            likelihoodPercent: 75
        ),
        BingoIncident(
            id: "crossword_or_sudoku",
            text: "Jemand löst Kreuzworträtsel oder Sudoku",
            iconName: "square.grid.3x3",
            rarity: .everyday,
            category: "Fahrgäste",
            likelihoodPercent: 65
        ),
        BingoIncident(
            id: "Bahncard_shown",
            text: "BahnCard oder Deutschlandticket wird vorgezeigt",
            iconName: "creditcard.fill",
            rarity: .everyday,
            category: "Service",
            likelihoodPercent: 85
        ),
        BingoIncident(
            id: "train_passes_bridge",
            text: "Zug überquert eine große Flussbrücke",
            iconName: "water.waves",
            rarity: .everyday,
            category: "Strecke",
            likelihoodPercent: 80
        ),
        BingoIncident(
            id: "solar_panels_field",
            text: "Großer Solarpark neben der Bahnstrecke sichtbar",
            iconName: "sun.max.trianglebadge.exclamationmark",
            rarity: .everyday,
            category: "Strecke",
            likelihoodPercent: 82
        ),
        BingoIncident(
            id: "church_tower_village",
            text: "Kirchturm eines Dorfes zieht am Fenster vorbei",
            iconName: "building.columns.fill",
            rarity: .everyday,
            category: "Strecke",
            likelihoodPercent: 88
        ),
        BingoIncident(
            id: "graffiti_noise_wall",
            text: "Bunt besprühte Lärmschutzwand entlang der Gleise",
            iconName: "paintbrush.pointed.fill",
            rarity: .everyday,
            category: "Strecke",
            likelihoodPercent: 90
        ),
        BingoIncident(
            id: "yellow_bauzug_parked",
            text: "Gelbes Baufahrzeug steht auf einem Nebengleis",
            iconName: "wrench.and.screwdriver.fill",
            rarity: .everyday,
            category: "Strecke",
            likelihoodPercent: 74
        ),
        BingoIncident(
            id: "s_bahn_parallel_drive",
            text: "S-Bahn oder Regionalbahn fährt kurz parallel nebenher",
            iconName: "tram",
            rarity: .everyday,
            category: "Strecke",
            likelihoodPercent: 72
        ),
        BingoIncident(
            id: "station_clock_check",
            text: "Blick auf die klassische Bahnhofsuhr am Bahnsteig",
            iconName: "clock.fill",
            rarity: .everyday,
            category: "Bahnhof",
            likelihoodPercent: 85
        ),
        BingoIncident(
            id: "door_button_pressed_early",
            text: "Türknopf wird gedrückt, bevor er grün leuchtet",
            iconName: "hand.point.up.left.fill",
            rarity: .everyday,
            category: "Fahrgäste",
            likelihoodPercent: 84
        ),
        BingoIncident(
            id: "step_gap_announcement",
            text: "„Bitte achten Sie auf den Spalt zwischen Zug und Bahnsteigkante“",
            iconName: "figure.step.training",
            rarity: .everyday,
            category: "Ansage",
            likelihoodPercent: 75
        ),
        BingoIncident(
            id: "apple_or_banana_snack",
            text: "Jemand isst einen Apfel oder eine Banane im Abteil",
            iconName: "leaf.fill",
            rarity: .everyday,
            category: "Verpflegung",
            likelihoodPercent: 76
        ),
        BingoIncident(
            id: "earbuds_one_ear",
            text: "Fahrgast trägt nur einen einzelnen AirPod / Kopfhörer",
            iconName: "airpod.right",
            rarity: .everyday,
            category: "Fahrgäste",
            likelihoodPercent: 78
        ),
        BingoIncident(
            id: "seat_backrest_adjusted",
            text: "Sitzlehne wird mit einem Ruck nach hinten verstellt",
            iconName: "chair.fill",
            rarity: .everyday,
            category: "Komfort",
            likelihoodPercent: 74
        ),
        BingoIncident(
            id: "conductor_walks_past",
            text: "Zugbegleiter läuft eilig durch den Mittelgang",
            iconName: "figure.walk",
            rarity: .everyday,
            category: "Service",
            likelihoodPercent: 90
        ),
        BingoIncident(
            id: "window_reflection_dark",
            text: "Im Tunnel spiegelt sich das Abteil im Zugfenster",
            iconName: "rectangle.portrait.on.rectangle.portrait.angled",
            rarity: .everyday,
            category: "Strecke",
            likelihoodPercent: 78
        ),

        // --- Technik, Bahnhof & Strecke (Alltag) ---
        BingoIncident(
            id: "mobile_dead_zone",
            text: "Funkloch: Handy hat kurzzeitig keinen Empfang",
            iconName: "antenna.radiowaves.left.and.right.slash",
            rarity: .everyday,
            category: "Technik",
            likelihoodPercent: 85
        ),
        BingoIncident(
            id: "oncoming_train_whoosh",
            text: "Gegenzug rauscht mit lautem Druckschlag vorbei",
            iconName: "wind",
            rarity: .everyday,
            category: "Strecke",
            likelihoodPercent: 88
        ),
        BingoIncident(
            id: "freight_train_seen",
            text: "Güterzug auf dem Nachbargleis gesichtet",
            iconName: "shippingbox.fill",
            rarity: .everyday,
            category: "Strecke",
            likelihoodPercent: 82
        ),
        BingoIncident(
            id: "wind_turbines_outside",
            text: "Windräder ziehen am Zugfenster vorbei",
            iconName: "fanblades.fill",
            rarity: .everyday,
            category: "Strecke",
            likelihoodPercent: 86
        ),
        BingoIncident(
            id: "tunnel_ear_pressure",
            text: "Druck auf den Ohren bei einer Tunneleinfahrt",
            iconName: "ear.fill",
            rarity: .everyday,
            category: "Strecke",
            likelihoodPercent: 74
        ),
        BingoIncident(
            id: "platform_crowd_one_door",
            text: "Alle drängen sich an einer Tür, die nächste ist frei",
            iconName: "person.3.sequence.fill",
            rarity: .everyday,
            category: "Bahnhof",
            likelihoodPercent: 80
        ),
        BingoIncident(
            id: "pigeon_on_platform",
            text: "Taube spaziert seelenruhig über den Bahnsteig",
            iconName: "bird.fill",
            rarity: .everyday,
            category: "Bahnhof",
            likelihoodPercent: 75
        ),
        BingoIncident(
            id: "commuter_door_sprint",
            text: "Fahrgast sprintet am Bahnsteig noch schnell zur Tür",
            iconName: "figure.run",
            rarity: .everyday,
            category: "Bahnhof",
            likelihoodPercent: 76
        ),
        BingoIncident(
            id: "screen_shows_speed",
            text: "Innenanzeige zeigt Route oder Geschwindigkeit an",
            iconName: "tv",
            rarity: .everyday,
            category: "Technik",
            likelihoodPercent: 84
        ),
        BingoIncident(
            id: "charger_plugged_in",
            text: "Handy-Ladekabel steckt in der Bordsteckdose",
            iconName: "powerplug.fill",
            rarity: .everyday,
            category: "Technik",
            likelihoodPercent: 82
        ),
        BingoIncident(
            id: "trash_collector_walk",
            text: "Reinigungskraft sammelt Müll im Wagen ein",
            iconName: "trash",
            rarity: .everyday,
            category: "Service",
            likelihoodPercent: 66
        ),
        BingoIncident(
            id: "bike_or_stroller_boarded",
            text: "Fahrrad oder Kinderwagen wird eingeladen",
            iconName: "bicycle",
            rarity: .everyday,
            category: "Wagen",
            likelihoodPercent: 74
        ),

        // =========================================================================
        // MARK: - 2. HÄUFIG / TYPISCH DB (Common, 35–60% Wahrscheinlichkeit)
        // Klassische Bahn-Erlebnisse, die regelmäßig vorkommen
        // =========================================================================

        // --- Verspätung & Betrieb (Häufig) ---
        BingoIncident(
            id: "delay_15_min",
            text: "Mindestens 15 Min. Verspätung",
            iconName: "clock.badge.exclamationmark.fill",
            rarity: .common,
            category: "Verspätung",
            likelihoodPercent: 52,
            exclusivityGroup: "delay_minutes"
        ),
        BingoIncident(
            id: "delay_20_min",
            text: "Mindestens 20 Min. Verspätung",
            iconName: "hourglass.bottomhalf.filled",
            rarity: .common,
            category: "Verspätung",
            likelihoodPercent: 42,
            exclusivityGroup: "delay_minutes"
        ),
        BingoIncident(
            id: "prev_delay",
            text: "„Verspätung aus vorheriger Fahrt“",
            iconName: "clock.badge.exclamationmark",
            rarity: .common,
            category: "Betrieb",
            likelihoodPercent: 55
        ),
        BingoIncident(
            id: "delay_creeping_up",
            text: "Verspätung klettert schrittweise um +5 Min. höher",
            iconName: "hourglass",
            rarity: .common,
            category: "Verspätung",
            likelihoodPercent: 58
        ),
        BingoIncident(
            id: "delay_made_up",
            text: "Zug holt unterwegs ein paar Minuten Verspätung auf",
            iconName: "gauge.with.dots.needle.67percent",
            rarity: .common,
            category: "Verspätung",
            likelihoodPercent: 50
        ),
        BingoIncident(
            id: "stop_open_track",
            text: "Ungeplanter Halt auf freier Strecke",
            iconName: "pause.circle",
            rarity: .common,
            category: "Betrieb",
            likelihoodPercent: 54
        ),
        BingoIncident(
            id: "track_occupied_wait",
            text: "Warten vor dem Bahnhof, weil das Gleis noch belegt ist",
            iconName: "octagon",
            rarity: .common,
            category: "Betrieb",
            likelihoodPercent: 56
        ),
        BingoIncident(
            id: "waiting_for_other_train",
            text: "„Verzögerung im Betriebsablauf“",
            iconName: "gearshape.2",
            rarity: .common,
            category: "Betrieb",
            likelihoodPercent: 60
        ),
        BingoIncident(
            id: "passed_by_ice",
            text: "Warten wegen Überholung durch einen anderen Zug",
            iconName: "hare.fill",
            rarity: .common,
            category: "Betrieb",
            likelihoodPercent: 42
        ),
        BingoIncident(
            id: "waiting_single_track",
            text: "Warten auf entgegenkommenden Zug",
            iconName: "arrow.left.arrow.right.circle",
            rarity: .common,
            category: "Betrieb",
            likelihoodPercent: 44
        ),
        BingoIncident(
            id: "waiting_for_passengers",
            text: "Zug wartet kurz auf Anschlussreisende",
            iconName: "person.2.badge.gearshape.fill",
            rarity: .common,
            category: "Betrieb",
            likelihoodPercent: 45
        ),
        BingoIncident(
            id: "tight_transfer_run",
            text: "Umsteigezeit schmilzt auf unter 5 Minuten",
            iconName: "figure.run.circle",
            rarity: .common,
            category: "Fahrplan",
            likelihoodPercent: 48
        ),
        BingoIncident(
            id: "polite_apology",
            text: "„Wir bitten um Entschuldigung für die Verspätung“",
            iconName: "hand.raised.fill",
            rarity: .common,
            category: "Ansage",
            likelihoodPercent: 60
        ),
        BingoIncident(
            id: "abrupt_braking",
            text: "Ruckartiges Bremsen vor einer Weiche oder einem Signal",
            iconName: "brakesignal",
            rarity: .common,
            category: "Betrieb",
            likelihoodPercent: 52
        ),

        // --- Bahnhof, Wagen & Infrastruktur (Häufig) ---
        BingoIncident(
            id: "track_change",
            text: "Gleiswechsel („Heute von Gleis …“)",
            iconName: "arrow.triangle.swap",
            rarity: .common,
            category: "Bahnhof",
            likelihoodPercent: 48
        ),
        BingoIncident(
            id: "reverse_order",
            text: "Abweichende oder umgekehrte Wagenreihung",
            iconName: "arrow.left.arrow.right",
            rarity: .common,
            category: "Wagen",
            likelihoodPercent: 45
        ),
        BingoIncident(
            id: "wrong_sector_stop",
            text: "Wagen hält in einem anderen Bahnsteigabschnitt als gedacht",
            iconName: "signpost.right.fill",
            rarity: .common,
            category: "Bahnhof",
            likelihoodPercent: 55
        ),
        BingoIncident(
            id: "smoker_pause_platform",
            text: "Raucher-Pause am Bahnsteig bei kurzem Zwischenhalt",
            iconName: "smoke",
            rarity: .common,
            category: "Bahnhof",
            likelihoodPercent: 58
        ),
        BingoIncident(
            id: "escalator_broken",
            text: "Rolltreppe oder Aufzug am Bahnhof außer Betrieb",
            iconName: "stairs",
            rarity: .common,
            category: "Bahnhof",
            likelihoodPercent: 50
        ),
        BingoIncident(
            id: "slow_down_construction",
            text: "Langsamfahrstelle wegen Baustelle an der Strecke",
            iconName: "cone.fill",
            rarity: .common,
            category: "Infrastruktur",
            likelihoodPercent: 56
        ),
        BingoIncident(
            id: "signal_fault",
            text: "Verzögerung wegen Signal- oder Weichenstörung",
            iconName: "trafficlight.fill",
            rarity: .common,
            category: "Infrastruktur",
            likelihoodPercent: 40
        ),
        BingoIncident(
            id: "app_vs_platform_mismatch",
            text: "DB Navigator & Bahnsteiganzeige zeigen unterschiedliche Zeiten",
            iconName: "arrow.up.and.down.and.sparkles",
            rarity: .common,
            category: "Technik",
            likelihoodPercent: 48
        ),

        // --- Technik & Komfort (Häufig) ---
        BingoIncident(
            id: "wifi_portal_only",
            text: "WLAN im Zug ist langsam oder lädt kurz nicht",
            iconName: "wifi.exclamationmark",
            rarity: .common,
            category: "Technik",
            likelihoodPercent: 60
        ),
        BingoIncident(
            id: "no_reservation_system",
            text: "Reservierungsanzeige zeigt „ggf. reserviert“ oder ist aus",
            iconName: "tag.slash.fill",
            rarity: .common,
            category: "Technik",
            likelihoodPercent: 46
        ),
        BingoIncident(
            id: "wc_occupied_wait",
            text: "Nächste Toilette ist besetzt – Schlange vor der Tür",
            iconName: "person.line.dotted.person.fill",
            rarity: .common,
            category: "Komfort",
            likelihoodPercent: 58,
            exclusivityGroup: "wc_status"
        ),
        BingoIncident(
            id: "one_wc_locked",
            text: "Eine Toilette im Wagen ist wegen Störung abgeschlossen",
            iconName: "lock.fill",
            rarity: .common,
            category: "Komfort",
            likelihoodPercent: 48,
            exclusivityGroup: "wc_status"
        ),
        BingoIncident(
            id: "door_between_coaches_stuck",
            text: "Zwischentür zum nächsten Wagen schließt ständig auf und zu",
            iconName: "door.sliding.left.hand.closed",
            rarity: .common,
            category: "Technik",
            likelihoodPercent: 52
        ),
        BingoIncident(
            id: "speaker_crackling",
            text: "Lautsprecherdurchsage sehr leise oder rauscht",
            iconName: "waveform.badge.exclamationmark",
            rarity: .common,
            category: "Ansage",
            likelihoodPercent: 50
        ),
        BingoIncident(
            id: "no_power_plug",
            text: "Steckdose am Platz ist ausgeleiert oder ohne Strom",
            iconName: "bolt.slash.fill",
            rarity: .common,
            category: "Technik",
            likelihoodPercent: 38
        ),
        BingoIncident(
            id: "ac_drafty",
            text: "Klimaanlage oder Lüftung zieht spürbar kalt",
            iconName: "snowflake",
            rarity: .common,
            category: "Komfort",
            likelihoodPercent: 46
        ),
        BingoIncident(
            id: "aisle_blocked_suitcases",
            text: "Große Koffer stehen mitten im Gang",
            iconName: "suitcase.fill",
            rarity: .common,
            category: "Komfort",
            likelihoodPercent: 58
        ),
        BingoIncident(
            id: "overhead_rack_full",
            text: "Gepäckablage über den Sitzen ist komplett voll",
            iconName: "tray.full.fill",
            rarity: .common,
            category: "Komfort",
            likelihoodPercent: 56
        ),
        BingoIncident(
            id: "trash_overflow",
            text: "Kleiner Platz-Mülleimer ist randvoll",
            iconName: "trash.fill",
            rarity: .common,
            category: "Komfort",
            likelihoodPercent: 50
        ),

        // --- Mitreisende & Atmosphäre (Häufig) ---
        BingoIncident(
            id: "loud_phone_call",
            text: "Lautes Telefonat im Wagen („Ja, ich sitze gerade im Zug!“)",
            iconName: "phone.arrow.up.right.fill",
            rarity: .common,
            category: "Fahrgäste",
            likelihoodPercent: 60
        ),
        BingoIncident(
            id: "phone_call_drops_tunnel",
            text: "Telefonat des Sitznachbarn bricht im Tunnel ab („Hallo? Hörst du mich?“)",
            iconName: "phone.down.fill",
            rarity: .common,
            category: "Fahrgäste",
            likelihoodPercent: 54
        ),
        BingoIncident(
            id: "seat_taken",
            text: "Diskussion um einen reservierten Sitzplatz",
            iconName: "chair.lounge.fill",
            rarity: .common,
            category: "Fahrgäste",
            likelihoodPercent: 48
        ),
        BingoIncident(
            id: "tiktok_speaker",
            text: "Jemand schaut Videos oder Sprachnachrichten ohne Kopfhörer",
            iconName: "speaker.wave.3.fill",
            rarity: .common,
            category: "Fahrgäste",
            likelihoodPercent: 45
        ),
        BingoIncident(
            id: "quiet_zone_talking",
            text: "Laute Unterhaltung mitten im Ruhebereich",
            iconName: "speaker.slash.fill",
            rarity: .common,
            category: "Fahrgäste",
            likelihoodPercent: 52
        ),
        BingoIncident(
            id: "loud_typing",
            text: "Schnelles, lautes Tippen auf einer Laptop-Tastatur",
            iconName: "keyboard.fill",
            rarity: .common,
            category: "Fahrgäste",
            likelihoodPercent: 50
        ),
        BingoIncident(
            id: "smell_of_food",
            text: "Herzhafter Essensduft (Ei, Döner, Frikadelle oder Fast Food) im Wagen",
            iconName: "fork.knife",
            rarity: .common,
            category: "Verpflegung",
            likelihoodPercent: 48
        ),
        BingoIncident(
            id: "crying_or_laughing_kid",
            text: "Kleinkind quengelt oder lacht laut durch den Wagen",
            iconName: "figure.and.child.holdinghands",
            rarity: .common,
            category: "Fahrgäste",
            likelihoodPercent: 52
        ),
        BingoIncident(
            id: "school_or_travel_group",
            text: "Schulklasse, Verein oder Reisegruppe steigt ein",
            iconName: "person.3.fill",
            rarity: .common,
            category: "Fahrgäste",
            likelihoodPercent: 44
        ),
        BingoIncident(
            id: "dog_on_train",
            text: "Hund fährt brav im Wagen mit",
            iconName: "pawprint.fill",
            rarity: .common,
            category: "Fahrgäste",
            likelihoodPercent: 45
        ),
        BingoIncident(
            id: "beer_opened_sound",
            text: "Feierabend-Bier oder Getränkeflasche ploppt / zischt",
            iconName: "mug.fill",
            rarity: .common,
            category: "Verpflegung",
            likelihoodPercent: 46
        ),
        BingoIncident(
            id: "wrong_coach_walkthrough",
            text: "Fahrgäste ziehen mit Rollkoffern durch mehrere Wagen",
            iconName: "figure.walk.motion",
            rarity: .common,
            category: "Fahrgäste",
            likelihoodPercent: 58
        ),
        BingoIncident(
            id: "delay_8_min",
            text: "Verspätung zwischen 5 und 10 Minuten",
            iconName: "clock.badge",
            rarity: .common,
            category: "Verspätung",
            likelihoodPercent: 58,
            exclusivityGroup: "delay_minutes"
        ),
        BingoIncident(
            id: "delay_25_min",
            text: "Mindestens 25 Min. Verspätung",
            iconName: "clock.badge.exclamationmark",
            rarity: .common,
            category: "Verspätung",
            likelihoodPercent: 35,
            exclusivityGroup: "delay_minutes"
        ),
        BingoIncident(
            id: "table_neighbor_laptop_elbow",
            text: "Ellenbogen-Duell um die Mittelarmlehne",
            iconName: "person.2.fill",
            rarity: .common,
            category: "Komfort",
            likelihoodPercent: 52
        ),
        BingoIncident(
            id: "shoes_taken_off",
            text: "Mitreisender zieht im Abteil die Schuhe aus",
            iconName: "shoe.2.fill",
            rarity: .common,
            category: "Fahrgäste",
            likelihoodPercent: 40
        ),
        BingoIncident(
            id: "tupperware_meal",
            text: "Tupperdose mit mitgebrachtem Essen wird geöffnet",
            iconName: "takeoutbag.and.cup.and.straw",
            rarity: .common,
            category: "Verpflegung",
            likelihoodPercent: 54
        ),
        BingoIncident(
            id: "bistro_coffee_carried",
            text: "Jemand balanciert einen Bordbistro-Kaffee durch den wackelnden Wagen",
            iconName: "cup.and.saucer",
            rarity: .common,
            category: "Verpflegung",
            likelihoodPercent: 55
        ),
        BingoIncident(
            id: "headphone_bleed",
            text: "Musik oder Podcast aus den Kopfhörern des Nachbarn deutlich hörbar",
            iconName: "ear.badge.waveform",
            rarity: .common,
            category: "Fahrgäste",
            likelihoodPercent: 50
        ),
        BingoIncident(
            id: "video_call_on_train",
            text: "Jemand hält einen Video-Call / Teams-Meeting im Zug",
            iconName: "video.fill",
            rarity: .common,
            category: "Fahrgäste",
            likelihoodPercent: 46
        ),
        BingoIncident(
            id: "card_game_table",
            text: "Am Vierertisch wird Karten oder ein Reisespiel gespielt",
            iconName: "suit.spade.fill",
            rarity: .common,
            category: "Fahrgäste",
            likelihoodPercent: 38
        ),
        BingoIncident(
            id: "curve_squeal",
            text: "Lautes Quietschen der Räder in einer engen Bahnhofskurve",
            iconName: "waveform.path.ecg",
            rarity: .common,
            category: "Betrieb",
            likelihoodPercent: 60
        ),
        BingoIncident(
            id: "horn_honk_track",
            text: "Lokführer gibt ein lautes Makrofon-Signal (Zug-Hupe) ab",
            iconName: "speaker.wave.3",
            rarity: .common,
            category: "Betrieb",
            likelihoodPercent: 44
        ),
        BingoIncident(
            id: "neutral_section_power_dip",
            text: "Kurzes Klacken / Lüftungspause an einer Schutzstrecke",
            iconName: "bolt.circle",
            rarity: .common,
            category: "Technik",
            likelihoodPercent: 48
        ),
        BingoIncident(
            id: "wrong_direction_seat",
            text: "Sitzplatz ist entgegen der Fahrtrichtung (Rückwärtsfahren)",
            iconName: "arrow.uturn.left.circle",
            rarity: .common,
            category: "Komfort",
            likelihoodPercent: 55
        ),
        BingoIncident(
            id: "pillar_window_seat",
            text: "„Wandfensterplatz“: Ausblick wird von der Seitenwand verdeckt",
            iconName: "rectangle.split.2x1.slash",
            rarity: .common,
            category: "Komfort",
            likelihoodPercent: 42
        ),
        BingoIncident(
            id: "rain_streaks_window",
            text: "Regentropfen ziehen waagerecht über die Zugscheibe",
            iconName: "cloud.rain.fill",
            rarity: .common,
            category: "Strecke",
            likelihoodPercent: 45
        ),
        BingoIncident(
            id: "sunset_from_train",
            text: "Schöner Sonnenauf- oder Sonnenuntergang aus dem Zugfenster",
            iconName: "sunset.fill",
            rarity: .common,
            category: "Strecke",
            likelihoodPercent: 42
        ),
        BingoIncident(
            id: "castle_on_hill",
            text: "Burg oder Schloss auf einem Hügel neben der Strecke",
            iconName: "building.2.crop.circle",
            rarity: .common,
            category: "Strecke",
            likelihoodPercent: 46
        ),
        BingoIncident(
            id: "deer_in_field",
            text: "Rehe, Kühe oder Pferde auf einer Wiese neben den Gleisen",
            iconName: "leaf.arrow.circlepath",
            rarity: .common,
            category: "Strecke",
            likelihoodPercent: 56
        ),
        BingoIncident(
            id: "station_bakery_sprint",
            text: "Knapper Sprint zum Bahnhofsbäcker vor der Abfahrt",
            iconName: "bag.badge.plus",
            rarity: .common,
            category: "Bahnhof",
            likelihoodPercent: 50
        ),
        BingoIncident(
            id: "display_scroll_reasons",
            text: "Laufschrift an der Anzeige nennt Verspätungsgrund",
            iconName: "text.line.first.and.arrowtriangle.forward",
            rarity: .common,
            category: "Bahnhof",
            likelihoodPercent: 58
        ),
        BingoIncident(
            id: "security_walkthrough",
            text: "DB-Sicherheit oder Bundespolizei läuft auf Streife durch den Zug",
            iconName: "shield.fill",
            rarity: .common,
            category: "Service",
            likelihoodPercent: 40
        ),
        BingoIncident(
            id: "backpack_hit_aisle",
            text: "Vorbeigehender Fahrgast streift mit dem Rucksack eine Sitzlehne",
            iconName: "figure.walk.arrival",
            rarity: .common,
            category: "Fahrgäste",
            likelihoodPercent: 56
        ),
        BingoIncident(
            id: "seat_reservation_last_minute",
            text: "Anzeige springt auf „ggf. freigeben“ (Last-Minute-Reservierung)",
            iconName: "tag",
            rarity: .common,
            category: "Technik",
            likelihoodPercent: 48
        ),
        BingoIncident(
            id: "conductor_helps_connection",
            text: "Zugbegleiter gibt Tipps für den besten Umsteigeweg",
            iconName: "person.wave.2.fill",
            rarity: .common,
            category: "Service",
            likelihoodPercent: 45
        ),

        // =========================================================================
        // MARK: - 3. GELEGENTLICH / UNGEWÖHNLICH (Uncommon, 12–32% Wahrscheinlichkeit)
        // Einprägsame Vorfälle, Pannen & Klassiker, die ab und zu passieren
        // =========================================================================

        // --- Verspätung & Betrieb (Gelegentlich) ---
        BingoIncident(
            id: "delay_30_min",
            text: "Mindestens 30 Min. Verspätung",
            iconName: "clock.badge.xmark",
            rarity: .uncommon,
            category: "Verspätung",
            likelihoodPercent: 26,
            exclusivityGroup: "delay_minutes"
        ),
        BingoIncident(
            id: "delay_45_min",
            text: "Mindestens 45 Min. Verspätung",
            iconName: "exclamationmark.triangle.fill",
            rarity: .uncommon,
            category: "Verspätung",
            likelihoodPercent: 18,
            exclusivityGroup: "delay_minutes"
        ),
        BingoIncident(
            id: "connection_missed",
            text: "Geplanter Anschlusszug wird verpasst",
            iconName: "figure.run",
            rarity: .uncommon,
            category: "Betrieb",
            likelihoodPercent: 25
        ),
        BingoIncident(
            id: "zugbindung_lifted",
            text: "Ansage oder App-Hinweis: „Zugbindung aufgehoben“",
            iconName: "ticket",
            rarity: .uncommon,
            category: "Service",
            likelihoodPercent: 26
        ),
        BingoIncident(
            id: "waiting_at_signal",
            text: "Kurz vor dem Zielbahnhof noch am Haltesignal stehen",
            iconName: "pause.circle.fill",
            rarity: .uncommon,
            category: "Betrieb",
            likelihoodPercent: 32
        ),
        BingoIncident(
            id: "people_on_track",
            text: "Verzögerung wegen „Personen im Gleis“",
            iconName: "figure.walk.diamond.fill",
            rarity: .uncommon,
            category: "Betrieb",
            likelihoodPercent: 20
        ),
        BingoIncident(
            id: "police_operation_delay",
            text: "Verzögerung wegen „Polizeieinsatz“ oder „Notarzteinsatz“",
            iconName: "light.beacon.max.fill",
            rarity: .uncommon,
            category: "Betrieb",
            likelihoodPercent: 18
        ),
        BingoIncident(
            id: "delay_recovery_speed",
            text: "Zug holt durch freie Strecke mindestens 10 Min. Verspätung auf",
            iconName: "arrow.right.to.line.compact",
            rarity: .uncommon,
            category: "Betrieb",
            likelihoodPercent: 22
        ),
        BingoIncident(
            id: "train_coupling_station",
            text: "Zug wird am Bahnhof gekuppelt oder geflügelt (Zugteilung)",
            iconName: "link",
            rarity: .uncommon,
            category: "Betrieb",
            likelihoodPercent: 24
        ),
        BingoIncident(
            id: "waiting_for_crew",
            text: "Warten auf verspätetes Zugpersonal aus einem anderen Zug",
            iconName: "person.badge.clock.fill",
            rarity: .uncommon,
            category: "Personal",
            likelihoodPercent: 20
        ),
        BingoIncident(
            id: "skip_intermediate_stop",
            text: "Ein geplanter Zwischenhalt entfällt zur Verspätungsreduzierung",
            iconName: "forward.end.fill",
            rarity: .uncommon,
            category: "Betrieb",
            likelihoodPercent: 14
        ),
        BingoIncident(
            id: "bus_sev",
            text: "Schienenersatzverkehr (SEV) auf einem Streckenabschnitt",
            iconName: "bus.fill",
            rarity: .uncommon,
            category: "Betrieb",
            likelihoodPercent: 18
        ),

        // --- Wagen, Technik & Bistro (Gelegentlich) ---
        BingoIncident(
            id: "door_defect",
            text: "Türstörung: Eine Einstiegstür ist mit gelbem Zettel gesperrt",
            iconName: "door.left.hand.closed",
            rarity: .uncommon,
            category: "Technik",
            likelihoodPercent: 28
        ),
        BingoIncident(
            id: "coach_missing",
            text: "Ein Wagen oder Zugteil fehlt („Heute ohne Wagen …“)",
            iconName: "train.side.rear.car",
            rarity: .uncommon,
            category: "Wagen",
            likelihoodPercent: 22
        ),
        BingoIncident(
            id: "short_train",
            text: "Kurzzug / Einfachtraktion statt Doppeltraktion",
            iconName: "scissors",
            rarity: .uncommon,
            category: "Wagen",
            likelihoodPercent: 24
        ),
        BingoIncident(
            id: "replacement_train_ic_ice",
            text: "Ersatzzug (andere Baureihe als ursprünglich geplant)",
            iconName: "arrow.triangle.2.circlepath",
            rarity: .uncommon,
            category: "Wagen",
            likelihoodPercent: 20
        ),
        BingoIncident(
            id: "no_coffee",
            text: "Kaffeemaschine oder Zapfanlage im Bordbistro defekt",
            iconName: "cup.and.saucer.fill",
            rarity: .uncommon,
            category: "Gastronomie",
            likelihoodPercent: 22
        ),
        BingoIncident(
            id: "bistro_cash_only",
            text: "Bordbistro: Kartenzahlung ausgefallen – nur Barzahlung",
            iconName: "banknote.fill",
            rarity: .uncommon,
            category: "Gastronomie",
            likelihoodPercent: 20
        ),
        BingoIncident(
            id: "bistro_food_out",
            text: "Bordbistro: Beliebtes Gericht oder Snack bereits ausverkauft",
            iconName: "tray.and.arrow.down.fill",
            rarity: .uncommon,
            category: "Gastronomie",
            likelihoodPercent: 26
        ),
        BingoIncident(
            id: "toilet_defects",
            text: "Mindestens 2 Toiletten in der Nähe gleichzeitig defekt",
            iconName: "nosign",
            rarity: .uncommon,
            category: "Komfort",
            likelihoodPercent: 24,
            exclusivityGroup: "wc_status"
        ),
        BingoIncident(
            id: "display_broken",
            text: "Zugzielanzeiger am Bahnsteig oder Wagen fällt aus",
            iconName: "display.trianglebadge.exclamationmark",
            rarity: .uncommon,
            category: "Bahnhof",
            likelihoodPercent: 25
        ),
        BingoIncident(
            id: "ticket_machine_broken",
            text: "Fahrkartenautomat am Bahnhof ist außer Betrieb",
            iconName: "creditcard.trianglebadge.exclamationmark",
            rarity: .uncommon,
            category: "Bahnhof",
            likelihoodPercent: 22
        ),
        BingoIncident(
            id: "freezing_ac",
            text: "Klimaanlage im Wagen ist komplett ausgefallen oder eiskalt",
            iconName: "thermometer.snowflake",
            rarity: .uncommon,
            category: "Komfort",
            likelihoodPercent: 20
        ),
        BingoIncident(
            id: "switch_defect",
            text: "Weichen- oder Stellwerksstörung wird durchgesagt",
            iconName: "point.bottomleft.forward.to.point.topright.filled.scurvepath",
            rarity: .uncommon,
            category: "Infrastruktur",
            likelihoodPercent: 25
        ),
        BingoIncident(
            id: "catenary_damage",
            text: "Störung an der Oberleitung oder Stromversorgung",
            iconName: "bolt.horizontal.fill",
            rarity: .uncommon,
            category: "Infrastruktur",
            likelihoodPercent: 14
        ),

        // --- Durchsagen, Service & Mitreisende (Gelegentlich) ---
        BingoIncident(
            id: "senk_ju",
            text: "Klassiker-Akzent: „Senk ju vor träwelling…“",
            iconName: "megaphone.fill",
            rarity: .uncommon,
            category: "Ansage",
            likelihoodPercent: 25
        ),
        BingoIncident(
            id: "honest_conductor",
            text: "Herrlich ehrliche oder humorvolle Durchsage des Zugchefs",
            iconName: "quote.bubble.fill",
            rarity: .uncommon,
            category: "Ansage",
            likelihoodPercent: 28
        ),
        BingoIncident(
            id: "ticket_inspector_cheer",
            text: "Besonders gut gelaunter & witziger Zugbegleiter",
            iconName: "face.smiling.fill",
            rarity: .uncommon,
            category: "Service",
            likelihoodPercent: 32
        ),
        BingoIncident(
            id: "no_ticket_check_whole_ride",
            text: "Ticket wird während der gesamten Fahrt nicht kontrolliert",
            iconName: "person.badge.shield.checkmark.fill",
            rarity: .uncommon,
            category: "Service",
            likelihoodPercent: 30
        ),
        BingoIncident(
            id: "ticket_invalid_complaint",
            text: "Diskussion bei Kontrolle: Falsches Ticket / Nahverkehrsticket im ICE",
            iconName: "ticket.fill",
            rarity: .uncommon,
            category: "Service",
            likelihoodPercent: 24
        ),
        BingoIncident(
            id: "wrong_train_boarded",
            text: "Fahrgast merkt nach Abfahrt: Er sitzt im falschen Zug!",
            iconName: "exclamationmark.questionmark",
            rarity: .uncommon,
            category: "Fahrgäste",
            likelihoodPercent: 20
        ),
        BingoIncident(
            id: "wrong_wagon_reservation",
            text: "Reservierungsstreit: Einer hat den falschen Tag oder Zug gebucht",
            iconName: "calendar.badge.exclamationmark",
            rarity: .uncommon,
            category: "Fahrgäste",
            likelihoodPercent: 22
        ),
        BingoIncident(
            id: "sitting_on_floor_stairs",
            text: "Zug so voll, dass Leute im Türbereich oder auf dem Boden sitzen",
            iconName: "person.crop.rectangle.stack.fill",
            rarity: .uncommon,
            category: "Betrieb",
            likelihoodPercent: 26
        ),
        BingoIncident(
            id: "advent_calendar_doors",
            text: "Durchsage bittet, alle Türen zum Einsteigen zu nutzen",
            iconName: "door.left.hand.open",
            rarity: .uncommon,
            category: "Ansage",
            likelihoodPercent: 28
        ),
        BingoIncident(
            id: "spilled_coffee_curve",
            text: "Getränk schwappt bei Weichenfahrt auf den Tisch",
            iconName: "drop.triangle.fill",
            rarity: .uncommon,
            category: "Komfort",
            likelihoodPercent: 22
        ),
        BingoIncident(
            id: "forgotten_bag",
            text: "Durchsage oder Hektik wegen eines vergessenen Gepäckstücks",
            iconName: "bag.badge.questionmark",
            rarity: .uncommon,
            category: "Fahrgäste",
            likelihoodPercent: 18
        ),
        BingoIncident(
            id: "family_area_business",
            text: "Geschäftsleute mit Laptop sitzen mitten im Familienbereich",
            iconName: "briefcase.fill",
            rarity: .uncommon,
            category: "Fahrgäste",
            likelihoodPercent: 26
        ),
        BingoIncident(
            id: "bike_area_overfilled",
            text: "Mehrzweck-/Fahrradabteil komplett mit Koffern zugestellt",
            iconName: "suitcase.cart.fill",
            rarity: .uncommon,
            category: "Wagen",
            likelihoodPercent: 30
        ),
        BingoIncident(
            id: "spotter_at_platform",
            text: "Trainspotter fotografiert Züge am Bahnsteigende",
            iconName: "camera.fill",
            rarity: .uncommon,
            category: "Sichtung",
            likelihoodPercent: 24
        ),
        BingoIncident(
            id: "conductor_asks_patience",
            text: "Zugchef bedankt sich für Geduld und Verständnis",
            iconName: "heart.fill",
            rarity: .uncommon,
            category: "Ansage",
            likelihoodPercent: 32
        ),

        // =========================================================================
        // MARK: - 4. SELTEN / KURIOSITÄTEN & LEGENDEN (Rare, 2–10% Wahrscheinlichkeit)
        // Seltene Highlights, von denen man noch nach der Reise erzählt
        // =========================================================================

        BingoIncident(
            id: "delay_60_min",
            text: "Über 60 Min. Verspätung (Fahrgastrechte-Jackpot!)",
            iconName: "eurosign.circle.fill",
            rarity: .rare,
            category: "Verspätung",
            likelihoodPercent: 10,
            exclusivityGroup: "delay_minutes"
        ),
        BingoIncident(
            id: "free_chocolate",
            text: "Zugbegleiter verteilt DB-Schokolade oder Gummibärchen",
            iconName: "gift.fill",
            rarity: .rare,
            category: "Service",
            likelihoodPercent: 8
        ),
        BingoIncident(
            id: "free_water",
            text: "Kostenloses Wasser oder Heißgetränk wegen großer Verspätung",
            iconName: "drop.fill",
            rarity: .rare,
            category: "Service",
            likelihoodPercent: 6
        ),
        BingoIncident(
            id: "on_time_miracle",
            text: "Ankunft am Zielbahnhof mindestens 2 Min. VOR Fahrplan!",
            iconName: "star.fill",
            rarity: .rare,
            category: "Wunder",
            likelihoodPercent: 9
        ),
        BingoIncident(
            id: "special_rainbow_view",
            text: "Sonder-ICE (Regenbogen-, Europa- oder BRD-ICE) gesehen",
            iconName: "rainbow",
            rarity: .rare,
            category: "Sichtung",
            likelihoodPercent: 8
        ),
        BingoIncident(
            id: "doctor_call",
            text: "Durchsage: „Befindet sich ein Arzt oder Sanitäter im Zug?“",
            iconName: "cross.case.fill",
            rarity: .rare,
            category: "Vorfälle",
            likelihoodPercent: 6
        ),
        BingoIncident(
            id: "train_reboot",
            text: "Zug-Neustart im Stand: Licht & Lüftung gehen kurz komplett aus",
            iconName: "arrow.clockwise.circle.fill",
            rarity: .rare,
            category: "Technik",
            likelihoodPercent: 7
        ),
        BingoIncident(
            id: "double_booked_seat",
            text: "Sitzplatz doppelt reserviert – beide haben denselben Beleg",
            iconName: "tag.fill",
            rarity: .rare,
            category: "Technik",
            likelihoodPercent: 7
        ),
        BingoIncident(
            id: "lost_driver",
            text: "Warten auf Ablöse-Lokführer, der selbst im Stau/Zug steckt",
            iconName: "person.crop.circle.badge.questionmark",
            rarity: .rare,
            category: "Personal",
            likelihoodPercent: 7
        ),
        BingoIncident(
            id: "driver_rhyme_farewell",
            text: "Lokführer oder Zugchef verabschiedet sich mit Reim oder Stand-up-Witz",
            iconName: "theatermasks.fill",
            rarity: .rare,
            category: "Ansage",
            likelihoodPercent: 8
        ),
        BingoIncident(
            id: "bundesliga_announcement",
            text: "Zugpersonal gibt Fußball-Zwischenstand über Lautsprecher durch",
            iconName: "sportscourt.fill",
            rarity: .rare,
            category: "Ansage",
            likelihoodPercent: 6
        ),
        BingoIncident(
            id: "first_class_upgrade",
            text: "1. Klasse wird wegen Überfüllung für alle freigegeben",
            iconName: "crown.fill",
            rarity: .rare,
            category: "Service",
            likelihoodPercent: 5
        ),
        BingoIncident(
            id: "stranded_nowhere",
            text: "Zug endet vorzeitig an einem Unterwegsbahnhof („Alle aussteigen!“)",
            iconName: "signpost.right.and.left.fill",
            rarity: .rare,
            category: "Betrieb",
            likelihoodPercent: 6
        ),
        BingoIncident(
            id: "wrong_turn",
            text: "Zug wird spontan über eine andere Strecke umgeleitet",
            iconName: "arrow.uturn.backward",
            rarity: .rare,
            category: "Betrieb",
            likelihoodPercent: 8
        ),
        BingoIncident(
            id: "animals_on_track",
            text: "Streckensperrung wegen Tieren (Schafe, Kühe, Schwan) im Gleis",
            iconName: "hare",
            rarity: .rare,
            category: "Natur",
            likelihoodPercent: 4
        ),
        BingoIncident(
            id: "tree_on_track",
            text: "Ast oder Baum im Gleisbett / in der Oberleitung",
            iconName: "tree.fill",
            rarity: .rare,
            category: "Infrastruktur",
            likelihoodPercent: 5
        ),
        BingoIncident(
            id: "fire_alarm_smoke",
            text: "Heimlicher Raucher löst Rauchmelder auf der Zugtoilette aus",
            iconName: "smoke.fill",
            rarity: .rare,
            category: "Vorfälle",
            likelihoodPercent: 5
        ),
        BingoIncident(
            id: "beer_crate_party",
            text: "Junggesellenabschied oder Fußballfans feiern mit Musikbox im Gang",
            iconName: "party.popper.fill",
            rarity: .rare,
            category: "Fahrgäste",
            likelihoodPercent: 9
        ),
        BingoIncident(
            id: "steam_locomotive_view",
            text: "Historische Dampflok, Messzug (ICE S) oder Sonderzug gesichtet",
            iconName: "sparkles",
            rarity: .rare,
            category: "Sichtung",
            likelihoodPercent: 5
        ),
        BingoIncident(
            id: "emergency_braking",
            text: "Spürbare Zwangsbremsung auf offener Strecke",
            iconName: "exclamationmark.octagon.fill",
            rarity: .rare,
            category: "Betrieb",
            likelihoodPercent: 5
        ),
        BingoIncident(
            id: "applause_on_arrival",
            text: "Ironischer oder echter Applaus im Wagen bei der Ankunft",
            iconName: "hands.clap.fill",
            rarity: .rare,
            category: "Fahrgäste",
            likelihoodPercent: 4
        ),
        BingoIncident(
            id: "child_shout_announcement",
            text: "Kind darf eine Durchsage ins Bordmikrofon sprechen",
            iconName: "mic.fill",
            rarity: .rare,
            category: "Ansage",
            likelihoodPercent: 3
        ),
        BingoIncident(
            id: "taxi_hotel_voucher",
            text: "Taxi- oder Hotelgutschein wegen gestrandeter Spätverbindung",
            iconName: "bed.double.fill",
            rarity: .rare,
            category: "Service",
            likelihoodPercent: 4
        ),
        BingoIncident(
            id: "announcement_loop_bug",
            text: "Automatische Ansage oder Anzeige hängt in einer Endlosschleife",
            iconName: "repeat",
            rarity: .rare,
            category: "Technik",
            likelihoodPercent: 6
        )
    ]
}
