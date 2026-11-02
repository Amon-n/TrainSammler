import Foundation
import SwiftUI

public enum BingoRarity: String, Codable, CaseIterable, Sendable {
    case everyday // Sehr häufig / Alltag (~65–90% Wahrscheinlichkeit)
    case common   // Häufig / Typisch DB (~35–60% Wahrscheinlichkeit)
    case uncommon // Gelegentlich (~10–30% Wahrscheinlichkeit)
    case rare     // Selten / Kuriosität (<10% Wahrscheinlichkeit)

    public var displayName: String {
        switch self {
        case .everyday: return "Alltag"
        case .common: return "Häufig"
        case .uncommon: return "Gelegentlich"
        case .rare: return "Selten"
        }
    }

    public var shortLabel: String {
        displayName
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
    /// Optionale Gruppe, damit sich sehr ähnliche Felder nicht auf kleinen Brettern doppeln
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
        // MARK: - 1. SEHR HÄUFIG / ALLTAG (Everyday, 65–95% Wahrscheinlichkeit)
        // =========================================================================

        // --- Verspätung & Fahrplan (Alltag) ---
        BingoIncident(
            id: "delay_3_min",
            text: "Mind. 3 Min. Verspätung",
            iconName: "clock",
            rarity: .everyday,
            category: "Verspätung",
            likelihoodPercent: 85,
            exclusivityGroup: "delay_minutes"
        ),
        BingoIncident(
            id: "delay_5_min",
            text: "Mind. 5 Min. Verspätung",
            iconName: "clock.badge.exclamationmark",
            rarity: .everyday,
            category: "Verspätung",
            likelihoodPercent: 78,
            exclusivityGroup: "delay_minutes"
        ),
        BingoIncident(
            id: "delay_10_min",
            text: "Mind. 10 Min. Verspätung",
            iconName: "clock.arrow.circlepath",
            rarity: .everyday,
            category: "Verspätung",
            likelihoodPercent: 65,
            exclusivityGroup: "delay_minutes"
        ),
        BingoIncident(
            id: "punctual_start",
            text: "Pünktliche Abfahrt",
            iconName: "checkmark.circle",
            rarity: .everyday,
            category: "Fahrplan",
            likelihoodPercent: 72
        ),
        BingoIncident(
            id: "longer_station_dwell",
            text: "Längerer Halt am Bahnhof",
            iconName: "timer",
            rarity: .everyday,
            category: "Verspätung",
            likelihoodPercent: 80
        ),
        BingoIncident(
            id: "db_nav_refresh",
            text: "Blick in den DB Navigator",
            iconName: "iphone.gen3",
            rarity: .everyday,
            category: "Fahrplan",
            likelihoodPercent: 92
        ),
        BingoIncident(
            id: "red_time_in_app",
            text: "Rote Zeit im DB Navigator",
            iconName: "exclamationmark.circle",
            rarity: .everyday,
            category: "Verspätung",
            likelihoodPercent: 82
        ),
        BingoIncident(
            id: "stop_before_station",
            text: "Langsame Bahnhofseinfahrt",
            iconName: "tortoise",
            rarity: .everyday,
            category: "Betrieb",
            likelihoodPercent: 88
        ),

        // --- Durchsagen & Service (Alltag) ---
        BingoIncident(
            id: "next_stop_announcement",
            text: "Ansage: „Nächster Halt …“",
            iconName: "speaker.wave.2.fill",
            rarity: .everyday,
            category: "Ansage",
            likelihoodPercent: 95
        ),
        BingoIncident(
            id: "exit_direction_left_right",
            text: "„Ausstieg links / rechts“",
            iconName: "arrow.left.and.right.square",
            rarity: .everyday,
            category: "Ansage",
            likelihoodPercent: 92
        ),
        BingoIncident(
            id: "welcome_announcement",
            text: "Begrüßung per Durchsage",
            iconName: "hand.wave.fill",
            rarity: .everyday,
            category: "Ansage",
            likelihoodPercent: 82
        ),
        BingoIncident(
            id: "english_announcement",
            text: "Durchsage auf Englisch",
            iconName: "globe.europe.africa.fill",
            rarity: .everyday,
            category: "Ansage",
            likelihoodPercent: 78
        ),
        BingoIncident(
            id: "ticket_check_normal",
            text: "Fahrkartenkontrolle",
            iconName: "qrcode.viewfinder",
            rarity: .everyday,
            category: "Service",
            likelihoodPercent: 75
        ),
        BingoIncident(
            id: "connection_announcement",
            text: "Ansage der Anschlüsse",
            iconName: "arrow.triangle.branch",
            rarity: .everyday,
            category: "Ansage",
            likelihoodPercent: 80
        ),
        BingoIncident(
            id: "farewell_announcement",
            text: "Verabschiedung am Halt",
            iconName: "megaphone",
            rarity: .everyday,
            category: "Ansage",
            likelihoodPercent: 76
        ),

        // --- Alltag im Wagen & Mitreisende ---
        BingoIncident(
            id: "seat_free_question",
            text: "„Ist hier noch frei?“",
            iconName: "bubble.left.and.bubble.right.fill",
            rarity: .everyday,
            category: "Fahrgäste",
            likelihoodPercent: 85
        ),
        BingoIncident(
            id: "backpack_on_seat",
            text: "Tasche auf dem Nebensitz",
            iconName: "bag.fill",
            rarity: .everyday,
            category: "Fahrgäste",
            likelihoodPercent: 90
        ),
        BingoIncident(
            id: "laptop_worker",
            text: "Arbeiten am Laptop",
            iconName: "laptopcomputer",
            rarity: .everyday,
            category: "Fahrgäste",
            likelihoodPercent: 88
        ),
        BingoIncident(
            id: "sleeping_passenger",
            text: "Schlafender Mitreisender",
            iconName: "zzz",
            rarity: .everyday,
            category: "Fahrgäste",
            likelihoodPercent: 78
        ),
        BingoIncident(
            id: "bakery_bag_snack",
            text: "Bäcker-Tüte ausgepackt",
            iconName: "takeoutbag.and.cup.and.straw.fill",
            rarity: .everyday,
            category: "Verpflegung",
            likelihoodPercent: 86
        ),
        BingoIncident(
            id: "coffee_to_go_cup",
            text: "Coffee-to-go am Platz",
            iconName: "cup.and.saucer.fill",
            rarity: .everyday,
            category: "Verpflegung",
            likelihoodPercent: 88
        ),
        BingoIncident(
            id: "searching_seat_number",
            text: "Suche nach Sitzplatznummer",
            iconName: "magnifyingglass",
            rarity: .everyday,
            category: "Fahrgäste",
            likelihoodPercent: 85
        ),
        BingoIncident(
            id: "luggage_rack_lift",
            text: "Koffer ins Gepäckfach",
            iconName: "suitcase.rolling.fill",
            rarity: .everyday,
            category: "Fahrgäste",
            likelihoodPercent: 80
        ),
        BingoIncident(
            id: "reading_book_newspaper",
            text: "Buch oder Zeitung lesen",
            iconName: "book.fill",
            rarity: .everyday,
            category: "Fahrgäste",
            likelihoodPercent: 75
        ),
        BingoIncident(
            id: "headphones_everyone",
            text: "Mind. 3× Kopfhörer sichtbar",
            iconName: "headphones",
            rarity: .everyday,
            category: "Fahrgäste",
            likelihoodPercent: 92
        ),
        BingoIncident(
            id: "scrolling_ticket_qr",
            text: "Hektische Ticket-Suche",
            iconName: "qrcode",
            rarity: .everyday,
            category: "Fahrgäste",
            likelihoodPercent: 72
        ),
        BingoIncident(
            id: "standing_up_too_early",
            text: "Viel zu früh an der Tür",
            iconName: "figure.stand",
            rarity: .everyday,
            category: "Fahrgäste",
            likelihoodPercent: 86
        ),
        BingoIncident(
            id: "sunblind_pulled",
            text: "Sonnenrollo genutzt",
            iconName: "sun.max.fill",
            rarity: .everyday,
            category: "Komfort",
            likelihoodPercent: 68
        ),
        BingoIncident(
            id: "jacket_on_hook",
            text: "Jacke am Fensterhaken",
            iconName: "tshirt.fill",
            rarity: .everyday,
            category: "Komfort",
            likelihoodPercent: 84
        ),
        BingoIncident(
            id: "table_folded_down",
            text: "Klapptisch ausgeklappt",
            iconName: "rectangle.split.3x1",
            rarity: .everyday,
            category: "Komfort",
            likelihoodPercent: 90
        ),
        BingoIncident(
            id: "water_bottle_on_table",
            text: "Trinkflasche auf dem Tisch",
            iconName: "waterbottle.fill",
            rarity: .everyday,
            category: "Verpflegung",
            likelihoodPercent: 88
        ),
        BingoIncident(
            id: "window_gazing",
            text: "Blick aus dem Zugfenster",
            iconName: "eye",
            rarity: .everyday,
            category: "Fahrgäste",
            likelihoodPercent: 90
        ),
        BingoIncident(
            id: "backpack_in_footwell",
            text: "Rucksack im Fußraum",
            iconName: "backpack.fill",
            rarity: .everyday,
            category: "Komfort",
            likelihoodPercent: 86
        ),
        BingoIncident(
            id: "powerbank_charging",
            text: "Handy an der Powerbank",
            iconName: "battery.100percent.bolt",
            rarity: .everyday,
            category: "Technik",
            likelihoodPercent: 75
        ),
        BingoIncident(
            id: "crossword_or_sudoku",
            text: "Kreuzworträtsel / Sudoku",
            iconName: "square.grid.3x3",
            rarity: .everyday,
            category: "Fahrgäste",
            likelihoodPercent: 65
        ),
        BingoIncident(
            id: "Bahncard_shown",
            text: "BahnCard / D-Ticket gezeigt",
            iconName: "creditcard.fill",
            rarity: .everyday,
            category: "Service",
            likelihoodPercent: 85
        ),
        BingoIncident(
            id: "train_passes_bridge",
            text: "Fahrt über Flussbrücke",
            iconName: "water.waves",
            rarity: .everyday,
            category: "Strecke",
            likelihoodPercent: 80
        ),
        BingoIncident(
            id: "solar_panels_field",
            text: "Solarpark an der Strecke",
            iconName: "sun.max.trianglebadge.exclamationmark",
            rarity: .everyday,
            category: "Strecke",
            likelihoodPercent: 82
        ),
        BingoIncident(
            id: "church_tower_village",
            text: "Kirchturm am Horizont",
            iconName: "building.columns.fill",
            rarity: .everyday,
            category: "Strecke",
            likelihoodPercent: 88
        ),
        BingoIncident(
            id: "graffiti_noise_wall",
            text: "Bunte Lärmschutzwand",
            iconName: "paintbrush.pointed.fill",
            rarity: .everyday,
            category: "Strecke",
            likelihoodPercent: 90
        ),
        BingoIncident(
            id: "yellow_bauzug_parked",
            text: "Gelber Bauzug am Gleis",
            iconName: "wrench.and.screwdriver.fill",
            rarity: .everyday,
            category: "Strecke",
            likelihoodPercent: 74
        ),
        BingoIncident(
            id: "s_bahn_parallel_drive",
            text: "Parallelfahrt mit S-Bahn/RB",
            iconName: "tram",
            rarity: .everyday,
            category: "Strecke",
            likelihoodPercent: 72
        ),
        BingoIncident(
            id: "station_clock_check",
            text: "Blick zur Bahnhofsuhr",
            iconName: "clock.fill",
            rarity: .everyday,
            category: "Bahnhof",
            likelihoodPercent: 85
        ),
        BingoIncident(
            id: "door_button_pressed_early",
            text: "Türknopf zu früh gedrückt",
            iconName: "hand.point.up.left.fill",
            rarity: .everyday,
            category: "Fahrgäste",
            likelihoodPercent: 84
        ),
        BingoIncident(
            id: "step_gap_announcement",
            text: "Ansage: „Bahnsteigkante“",
            iconName: "figure.step.training",
            rarity: .everyday,
            category: "Ansage",
            likelihoodPercent: 75
        ),
        BingoIncident(
            id: "apple_or_banana_snack",
            text: "Apfel oder Banane als Snack",
            iconName: "leaf.fill",
            rarity: .everyday,
            category: "Verpflegung",
            likelihoodPercent: 76
        ),
        BingoIncident(
            id: "earbuds_one_ear",
            text: "Nur ein Kopfhörer im Ohr",
            iconName: "airpod.right",
            rarity: .everyday,
            category: "Fahrgäste",
            likelihoodPercent: 78
        ),
        BingoIncident(
            id: "seat_backrest_adjusted",
            text: "Sitzlehne zurückgestellt",
            iconName: "chair.fill",
            rarity: .everyday,
            category: "Komfort",
            likelihoodPercent: 74
        ),
        BingoIncident(
            id: "conductor_walks_past",
            text: "Zugbegleiter läuft vorbei",
            iconName: "figure.walk",
            rarity: .everyday,
            category: "Service",
            likelihoodPercent: 90
        ),
        BingoIncident(
            id: "window_reflection_dark",
            text: "Fensterspiegelung im Tunnel",
            iconName: "rectangle.portrait.on.rectangle.portrait.angled",
            rarity: .everyday,
            category: "Strecke",
            likelihoodPercent: 78
        ),

        // --- Technik, Bahnhof & Strecke (Alltag) ---
        BingoIncident(
            id: "mobile_dead_zone",
            text: "Funkloch unterwegs",
            iconName: "antenna.radiowaves.left.and.right.slash",
            rarity: .everyday,
            category: "Technik",
            likelihoodPercent: 85
        ),
        BingoIncident(
            id: "oncoming_train_whoosh",
            text: "Gegenzug rauscht vorbei",
            iconName: "wind",
            rarity: .everyday,
            category: "Strecke",
            likelihoodPercent: 88
        ),
        BingoIncident(
            id: "freight_train_seen",
            text: "Güterzug gesichtet",
            iconName: "shippingbox.fill",
            rarity: .everyday,
            category: "Strecke",
            likelihoodPercent: 82
        ),
        BingoIncident(
            id: "wind_turbines_outside",
            text: "Windräder an der Strecke",
            iconName: "fanblades.fill",
            rarity: .everyday,
            category: "Strecke",
            likelihoodPercent: 86
        ),
        BingoIncident(
            id: "tunnel_ear_pressure",
            text: "Ohrendruck im Tunnel",
            iconName: "ear.fill",
            rarity: .everyday,
            category: "Strecke",
            likelihoodPercent: 74
        ),
        BingoIncident(
            id: "platform_crowd_one_door",
            text: "Stau vor einer Einstiegstür",
            iconName: "person.3.sequence.fill",
            rarity: .everyday,
            category: "Bahnhof",
            likelihoodPercent: 80
        ),
        BingoIncident(
            id: "pigeon_on_platform",
            text: "Taube auf dem Bahnsteig",
            iconName: "bird.fill",
            rarity: .everyday,
            category: "Bahnhof",
            likelihoodPercent: 75
        ),
        BingoIncident(
            id: "commuter_door_sprint",
            text: "Sprint zur offenen Zugtür",
            iconName: "figure.run",
            rarity: .everyday,
            category: "Bahnhof",
            likelihoodPercent: 76
        ),
        BingoIncident(
            id: "screen_shows_speed",
            text: "Anzeige zeigt Tempo / Route",
            iconName: "tv",
            rarity: .everyday,
            category: "Technik",
            likelihoodPercent: 84
        ),
        BingoIncident(
            id: "charger_plugged_in",
            text: "Steckdose am Platz genutzt",
            iconName: "powerplug.fill",
            rarity: .everyday,
            category: "Technik",
            likelihoodPercent: 82
        ),
        BingoIncident(
            id: "trash_collector_walk",
            text: "Müllsammlung im Wagen",
            iconName: "trash",
            rarity: .everyday,
            category: "Service",
            likelihoodPercent: 66
        ),
        BingoIncident(
            id: "bike_or_stroller_boarded",
            text: "Fahrrad / Kinderwagen an Bord",
            iconName: "bicycle",
            rarity: .everyday,
            category: "Wagen",
            likelihoodPercent: 74
        ),

        // =========================================================================
        // MARK: - 2. HÄUFIG / TYPISCH DB (Common, 35–60% Wahrscheinlichkeit)
        // =========================================================================

        // --- Verspätung & Betrieb (Häufig) ---
        BingoIncident(
            id: "delay_15_min",
            text: "Mind. 15 Min. Verspätung",
            iconName: "clock.badge.exclamationmark.fill",
            rarity: .common,
            category: "Verspätung",
            likelihoodPercent: 52,
            exclusivityGroup: "delay_minutes"
        ),
        BingoIncident(
            id: "delay_20_min",
            text: "Mind. 20 Min. Verspätung",
            iconName: "hourglass.bottomhalf.filled",
            rarity: .common,
            category: "Verspätung",
            likelihoodPercent: 42,
            exclusivityGroup: "delay_minutes"
        ),
        BingoIncident(
            id: "prev_delay",
            text: "„Aus vorheriger Fahrt“",
            iconName: "clock.badge.exclamationmark",
            rarity: .common,
            category: "Betrieb",
            likelihoodPercent: 55
        ),
        BingoIncident(
            id: "delay_creeping_up",
            text: "Verspätung steigt um +5 Min.",
            iconName: "hourglass",
            rarity: .common,
            category: "Verspätung",
            likelihoodPercent: 58
        ),
        BingoIncident(
            id: "delay_made_up",
            text: "Einige Minuten aufgeholt",
            iconName: "gauge.with.dots.needle.67percent",
            rarity: .common,
            category: "Verspätung",
            likelihoodPercent: 50
        ),
        BingoIncident(
            id: "stop_open_track",
            text: "Halt auf freier Strecke",
            iconName: "pause.circle",
            rarity: .common,
            category: "Betrieb",
            likelihoodPercent: 54
        ),
        BingoIncident(
            id: "track_occupied_wait",
            text: "Einfahrtgleis noch belegt",
            iconName: "octagon",
            rarity: .common,
            category: "Betrieb",
            likelihoodPercent: 56
        ),
        BingoIncident(
            id: "waiting_for_other_train",
            text: "„Verzögerung im Betrieb“",
            iconName: "gearshape.2",
            rarity: .common,
            category: "Betrieb",
            likelihoodPercent: 60
        ),
        BingoIncident(
            id: "passed_by_ice",
            text: "Überholung durch anderen Zug",
            iconName: "hare.fill",
            rarity: .common,
            category: "Betrieb",
            likelihoodPercent: 42
        ),
        BingoIncident(
            id: "waiting_single_track",
            text: "Warten auf Gegenzug",
            iconName: "arrow.left.arrow.right.circle",
            rarity: .common,
            category: "Betrieb",
            likelihoodPercent: 44
        ),
        BingoIncident(
            id: "waiting_for_passengers",
            text: "Warten auf Anschlussgäste",
            iconName: "person.2.badge.gearshape.fill",
            rarity: .common,
            category: "Betrieb",
            likelihoodPercent: 45
        ),
        BingoIncident(
            id: "tight_transfer_run",
            text: "Umsteigezeit unter 5 Min.",
            iconName: "figure.run.circle",
            rarity: .common,
            category: "Fahrplan",
            likelihoodPercent: 48
        ),
        BingoIncident(
            id: "polite_apology",
            text: "Entschuldigungs-Durchsage",
            iconName: "hand.raised.fill",
            rarity: .common,
            category: "Ansage",
            likelihoodPercent: 60
        ),
        BingoIncident(
            id: "abrupt_braking",
            text: "Ruckartiges Abbremsen",
            iconName: "brakesignal",
            rarity: .common,
            category: "Betrieb",
            likelihoodPercent: 52
        ),

        // --- Bahnhof, Wagen & Infrastruktur (Häufig) ---
        BingoIncident(
            id: "track_change",
            text: "Gleiswechsel am Bahnhof",
            iconName: "arrow.triangle.swap",
            rarity: .common,
            category: "Bahnhof",
            likelihoodPercent: 48
        ),
        BingoIncident(
            id: "reverse_order",
            text: "Geänderte Wagenreihung",
            iconName: "arrow.left.arrow.right",
            rarity: .common,
            category: "Wagen",
            likelihoodPercent: 45
        ),
        BingoIncident(
            id: "wrong_sector_stop",
            text: "Wagen hält in anderem Sektor",
            iconName: "signpost.right.fill",
            rarity: .common,
            category: "Bahnhof",
            likelihoodPercent: 55
        ),
        BingoIncident(
            id: "smoker_pause_platform",
            text: "Kurze Raucherpause am Gleis",
            iconName: "smoke",
            rarity: .common,
            category: "Bahnhof",
            likelihoodPercent: 58
        ),
        BingoIncident(
            id: "escalator_broken",
            text: "Rolltreppe / Aufzug defekt",
            iconName: "stairs",
            rarity: .common,
            category: "Bahnhof",
            likelihoodPercent: 50
        ),
        BingoIncident(
            id: "slow_down_construction",
            text: "Langsamfahrt an Baustelle",
            iconName: "cone.fill",
            rarity: .common,
            category: "Infrastruktur",
            likelihoodPercent: 56
        ),
        BingoIncident(
            id: "signal_fault",
            text: "Signal- oder Weichenstörung",
            iconName: "trafficlight.fill",
            rarity: .common,
            category: "Infrastruktur",
            likelihoodPercent: 40
        ),
        BingoIncident(
            id: "app_vs_platform_mismatch",
            text: "App & Anzeige widersprechen",
            iconName: "arrow.up.and.down.and.sparkles",
            rarity: .common,
            category: "Technik",
            likelihoodPercent: 48
        ),

        // --- Technik & Komfort (Häufig) ---
        BingoIncident(
            id: "wifi_portal_only",
            text: "Zug-WLAN lahmt oder hakt",
            iconName: "wifi.exclamationmark",
            rarity: .common,
            category: "Technik",
            likelihoodPercent: 60
        ),
        BingoIncident(
            id: "no_reservation_system",
            text: "Anzeige: „ggf. reserviert“",
            iconName: "tag.slash.fill",
            rarity: .common,
            category: "Technik",
            likelihoodPercent: 46
        ),
        BingoIncident(
            id: "wc_occupied_wait",
            text: "Schlange vor dem Zug-WC",
            iconName: "person.line.dotted.person.fill",
            rarity: .common,
            category: "Komfort",
            likelihoodPercent: 58,
            exclusivityGroup: "wc_status"
        ),
        BingoIncident(
            id: "one_wc_locked",
            text: "Ein WC im Wagen gesperrt",
            iconName: "lock.fill",
            rarity: .common,
            category: "Komfort",
            likelihoodPercent: 48,
            exclusivityGroup: "wc_status"
        ),
        BingoIncident(
            id: "door_between_coaches_stuck",
            text: "Zwischentür öffnet ständig",
            iconName: "door.sliding.left.hand.closed",
            rarity: .common,
            category: "Technik",
            likelihoodPercent: 52
        ),
        BingoIncident(
            id: "speaker_crackling",
            text: "Lautsprecher rauscht / leise",
            iconName: "waveform.badge.exclamationmark",
            rarity: .common,
            category: "Ansage",
            likelihoodPercent: 50
        ),
        BingoIncident(
            id: "no_power_plug",
            text: "Steckdose ohne Strom",
            iconName: "bolt.slash.fill",
            rarity: .common,
            category: "Technik",
            likelihoodPercent: 38
        ),
        BingoIncident(
            id: "ac_drafty",
            text: "Klimaanlage zieht spürbar",
            iconName: "snowflake",
            rarity: .common,
            category: "Komfort",
            likelihoodPercent: 46
        ),
        BingoIncident(
            id: "aisle_blocked_suitcases",
            text: "Koffer blockiert den Gang",
            iconName: "suitcase.fill",
            rarity: .common,
            category: "Komfort",
            likelihoodPercent: 58
        ),
        BingoIncident(
            id: "overhead_rack_full",
            text: "Gepäckablage komplett voll",
            iconName: "tray.full.fill",
            rarity: .common,
            category: "Komfort",
            likelihoodPercent: 56
        ),
        BingoIncident(
            id: "trash_overflow",
            text: "Platz-Mülleimer randvoll",
            iconName: "trash.fill",
            rarity: .common,
            category: "Komfort",
            likelihoodPercent: 50
        ),

        // --- Mitreisende & Atmosphäre (Häufig) ---
        BingoIncident(
            id: "loud_phone_call",
            text: "Lautes Telefonat im Wagen",
            iconName: "phone.arrow.up.right.fill",
            rarity: .common,
            category: "Fahrgäste",
            likelihoodPercent: 60
        ),
        BingoIncident(
            id: "phone_call_drops_tunnel",
            text: "Telefonat bricht im Tunnel ab",
            iconName: "phone.down.fill",
            rarity: .common,
            category: "Fahrgäste",
            likelihoodPercent: 54
        ),
        BingoIncident(
            id: "seat_taken",
            text: "Diskussion um Sitzplatz",
            iconName: "chair.lounge.fill",
            rarity: .common,
            category: "Fahrgäste",
            likelihoodPercent: 48
        ),
        BingoIncident(
            id: "tiktok_speaker",
            text: "Videos ohne Kopfhörer",
            iconName: "speaker.wave.3.fill",
            rarity: .common,
            category: "Fahrgäste",
            likelihoodPercent: 45
        ),
        BingoIncident(
            id: "quiet_zone_talking",
            text: "Gespräche im Ruhebereich",
            iconName: "speaker.slash.fill",
            rarity: .common,
            category: "Fahrgäste",
            likelihoodPercent: 52
        ),
        BingoIncident(
            id: "loud_typing",
            text: "Lautes Laptop-Tippen",
            iconName: "keyboard.fill",
            rarity: .common,
            category: "Fahrgäste",
            likelihoodPercent: 50
        ),
        BingoIncident(
            id: "smell_of_food",
            text: "Kräftiger Essensduft im Zug",
            iconName: "fork.knife",
            rarity: .common,
            category: "Verpflegung",
            likelihoodPercent: 48
        ),
        BingoIncident(
            id: "crying_or_laughing_kid",
            text: "Kind weint oder lacht laut",
            iconName: "figure.and.child.holdinghands",
            rarity: .common,
            category: "Fahrgäste",
            likelihoodPercent: 52
        ),
        BingoIncident(
            id: "school_or_travel_group",
            text: "Reisegruppe / Schulklasse",
            iconName: "person.3.fill",
            rarity: .common,
            category: "Fahrgäste",
            likelihoodPercent: 44
        ),
        BingoIncident(
            id: "dog_on_train",
            text: "Hund fährt im Wagen mit",
            iconName: "pawprint.fill",
            rarity: .common,
            category: "Fahrgäste",
            likelihoodPercent: 45
        ),
        BingoIncident(
            id: "beer_opened_sound",
            text: "Feierabend-Getränk zischt",
            iconName: "mug.fill",
            rarity: .common,
            category: "Verpflegung",
            likelihoodPercent: 46
        ),
        BingoIncident(
            id: "wrong_coach_walkthrough",
            text: "Rollkoffer-Zug durchs Abteil",
            iconName: "figure.walk.motion",
            rarity: .common,
            category: "Fahrgäste",
            likelihoodPercent: 58
        ),
        BingoIncident(
            id: "delay_8_min",
            text: "5 bis 10 Min. Verspätung",
            iconName: "clock.badge",
            rarity: .common,
            category: "Verspätung",
            likelihoodPercent: 58,
            exclusivityGroup: "delay_minutes"
        ),
        BingoIncident(
            id: "delay_25_min",
            text: "Mind. 25 Min. Verspätung",
            iconName: "clock.badge.exclamationmark",
            rarity: .common,
            category: "Verspätung",
            likelihoodPercent: 35,
            exclusivityGroup: "delay_minutes"
        ),
        BingoIncident(
            id: "table_neighbor_laptop_elbow",
            text: "Kampf um die Armlehne",
            iconName: "person.2.fill",
            rarity: .common,
            category: "Komfort",
            likelihoodPercent: 52
        ),
        BingoIncident(
            id: "shoes_taken_off",
            text: "Schuhe im Abteil ausgezogen",
            iconName: "shoe.2.fill",
            rarity: .common,
            category: "Fahrgäste",
            likelihoodPercent: 40
        ),
        BingoIncident(
            id: "tupperware_meal",
            text: "Tupperdose wird geöffnet",
            iconName: "takeoutbag.and.cup.and.straw",
            rarity: .common,
            category: "Verpflegung",
            likelihoodPercent: 54
        ),
        BingoIncident(
            id: "bistro_coffee_carried",
            text: "Bordbistro-Kaffee balanciert",
            iconName: "cup.and.saucer",
            rarity: .common,
            category: "Verpflegung",
            likelihoodPercent: 55
        ),
        BingoIncident(
            id: "headphone_bleed",
            text: "laute Kopfhörer-Musik hörbar",
            iconName: "ear.badge.waveform",
            rarity: .common,
            category: "Fahrgäste",
            likelihoodPercent: 50
        ),
        BingoIncident(
            id: "video_call_on_train",
            text: "Video-Call / Meeting im Zug",
            iconName: "video.fill",
            rarity: .common,
            category: "Fahrgäste",
            likelihoodPercent: 46
        ),
        BingoIncident(
            id: "card_game_table",
            text: "Kartenspiel am Vierertisch",
            iconName: "suit.spade.fill",
            rarity: .common,
            category: "Fahrgäste",
            likelihoodPercent: 38
        ),
        BingoIncident(
            id: "curve_squeal",
            text: "Kurvenquietschen der Räder",
            iconName: "waveform.path.ecg",
            rarity: .common,
            category: "Betrieb",
            likelihoodPercent: 60
        ),
        BingoIncident(
            id: "horn_honk_track",
            text: "Lokführer hupt (Makrofon)",
            iconName: "speaker.wave.3",
            rarity: .common,
            category: "Betrieb",
            likelihoodPercent: 44
        ),
        BingoIncident(
            id: "neutral_section_power_dip",
            text: "Kurzer Lüftungs-Aussetzer",
            iconName: "bolt.circle",
            rarity: .common,
            category: "Technik",
            likelihoodPercent: 48
        ),
        BingoIncident(
            id: "wrong_direction_seat",
            text: "Sitzplatz rückwärts",
            iconName: "arrow.uturn.left.circle",
            rarity: .common,
            category: "Komfort",
            likelihoodPercent: 55
        ),
        BingoIncident(
            id: "pillar_window_seat",
            text: "Wandfensterplatz erwischt",
            iconName: "rectangle.split.2x1.slash",
            rarity: .common,
            category: "Komfort",
            likelihoodPercent: 42
        ),
        BingoIncident(
            id: "rain_streaks_window",
            text: "Regentropfen am Fenster",
            iconName: "cloud.rain.fill",
            rarity: .common,
            category: "Strecke",
            likelihoodPercent: 45
        ),
        BingoIncident(
            id: "sunset_from_train",
            text: "Abendrot aus dem Zugfenster",
            iconName: "sunset.fill",
            rarity: .common,
            category: "Strecke",
            likelihoodPercent: 42
        ),
        BingoIncident(
            id: "castle_on_hill",
            text: "Burg oder Schloss am Hügel",
            iconName: "building.2.crop.circle",
            rarity: .common,
            category: "Strecke",
            likelihoodPercent: 46
        ),
        BingoIncident(
            id: "deer_in_field",
            text: "Tiere auf der Wiese",
            iconName: "leaf.arrow.circlepath",
            rarity: .common,
            category: "Strecke",
            likelihoodPercent: 56
        ),
        BingoIncident(
            id: "station_bakery_sprint",
            text: "Schneller Kauf beim Bäcker",
            iconName: "bag.badge.plus",
            rarity: .common,
            category: "Bahnhof",
            likelihoodPercent: 50
        ),
        BingoIncident(
            id: "display_scroll_reasons",
            text: "Laufschrift am Bahnsteig",
            iconName: "text.line.first.and.arrowtriangle.forward",
            rarity: .common,
            category: "Bahnhof",
            likelihoodPercent: 58
        ),
        BingoIncident(
            id: "security_walkthrough",
            text: "DB-Sicherheit läuft vorbei",
            iconName: "shield.fill",
            rarity: .common,
            category: "Service",
            likelihoodPercent: 40
        ),
        BingoIncident(
            id: "backpack_hit_aisle",
            text: "Rucksack streift Sitzlehne",
            iconName: "figure.walk.arrival",
            rarity: .common,
            category: "Fahrgäste",
            likelihoodPercent: 56
        ),
        BingoIncident(
            id: "seat_reservation_last_minute",
            text: "Anzeige: „ggf. freigeben“",
            iconName: "tag",
            rarity: .common,
            category: "Technik",
            likelihoodPercent: 48
        ),
        BingoIncident(
            id: "conductor_helps_connection",
            text: "Umsteigetipp vom Personal",
            iconName: "person.wave.2.fill",
            rarity: .common,
            category: "Service",
            likelihoodPercent: 45
        ),

        // =========================================================================
        // MARK: - 3. GELEGENTLICH / UNGEWÖHNLICH (Uncommon, 12–32% Wahrscheinlichkeit)
        // =========================================================================

        // --- Verspätung & Betrieb (Gelegentlich) ---
        BingoIncident(
            id: "delay_30_min",
            text: "Mind. 30 Min. Verspätung",
            iconName: "clock.badge.xmark",
            rarity: .uncommon,
            category: "Verspätung",
            likelihoodPercent: 26,
            exclusivityGroup: "delay_minutes"
        ),
        BingoIncident(
            id: "delay_45_min",
            text: "Mind. 45 Min. Verspätung",
            iconName: "exclamationmark.triangle.fill",
            rarity: .uncommon,
            category: "Verspätung",
            likelihoodPercent: 18,
            exclusivityGroup: "delay_minutes"
        ),
        BingoIncident(
            id: "connection_missed",
            text: "Anschlusszug verpasst",
            iconName: "figure.run",
            rarity: .uncommon,
            category: "Betrieb",
            likelihoodPercent: 25
        ),
        BingoIncident(
            id: "zugbindung_lifted",
            text: "Zugbindung aufgehoben",
            iconName: "ticket",
            rarity: .uncommon,
            category: "Service",
            likelihoodPercent: 26
        ),
        BingoIncident(
            id: "waiting_at_signal",
            text: "Halt vorm Zielbahnhof",
            iconName: "pause.circle.fill",
            rarity: .uncommon,
            category: "Betrieb",
            likelihoodPercent: 32
        ),
        BingoIncident(
            id: "people_on_track",
            text: "„Personen im Gleis“",
            iconName: "figure.walk.diamond.fill",
            rarity: .uncommon,
            category: "Betrieb",
            likelihoodPercent: 20
        ),
        BingoIncident(
            id: "police_operation_delay",
            text: "Polizei- / Notarzteinsatz",
            iconName: "light.beacon.max.fill",
            rarity: .uncommon,
            category: "Betrieb",
            likelihoodPercent: 18
        ),
        BingoIncident(
            id: "delay_recovery_speed",
            text: "Über 10 Min. aufgeholt",
            iconName: "arrow.right.to.line.compact",
            rarity: .uncommon,
            category: "Betrieb",
            likelihoodPercent: 22
        ),
        BingoIncident(
            id: "train_coupling_station",
            text: "Zug wird geteilt / gekuppelt",
            iconName: "link",
            rarity: .uncommon,
            category: "Betrieb",
            likelihoodPercent: 24
        ),
        BingoIncident(
            id: "waiting_for_crew",
            text: "Warten auf Zugpersonal",
            iconName: "person.badge.clock.fill",
            rarity: .uncommon,
            category: "Personal",
            likelihoodPercent: 20
        ),
        BingoIncident(
            id: "skip_intermediate_stop",
            text: "Zwischenhalt entfällt",
            iconName: "forward.end.fill",
            rarity: .uncommon,
            category: "Betrieb",
            likelihoodPercent: 14
        ),
        BingoIncident(
            id: "bus_sev",
            text: "Schienenersatzverkehr (SEV)",
            iconName: "bus.fill",
            rarity: .uncommon,
            category: "Betrieb",
            likelihoodPercent: 18
        ),

        // --- Wagen, Technik & Bistro (Gelegentlich) ---
        BingoIncident(
            id: "door_defect",
            text: "Einstiegstür defekt",
            iconName: "door.left.hand.closed",
            rarity: .uncommon,
            category: "Technik",
            likelihoodPercent: 28
        ),
        BingoIncident(
            id: "coach_missing",
            text: "Wagen oder Zugteil fehlt",
            iconName: "train.side.rear.car",
            rarity: .uncommon,
            category: "Wagen",
            likelihoodPercent: 22
        ),
        BingoIncident(
            id: "short_train",
            text: "Kurzzug statt Vollzug",
            iconName: "scissors",
            rarity: .uncommon,
            category: "Wagen",
            likelihoodPercent: 24
        ),
        BingoIncident(
            id: "replacement_train_ic_ice",
            text: "Ersatzzug im Einsatz",
            iconName: "arrow.triangle.2.circlepath",
            rarity: .uncommon,
            category: "Wagen",
            likelihoodPercent: 20
        ),
        BingoIncident(
            id: "no_coffee",
            text: "Bistro-Kaffeemaschine defekt",
            iconName: "cup.and.saucer.fill",
            rarity: .uncommon,
            category: "Gastronomie",
            likelihoodPercent: 22
        ),
        BingoIncident(
            id: "bistro_cash_only",
            text: "Bistro: Nur Barzahlung",
            iconName: "banknote.fill",
            rarity: .uncommon,
            category: "Gastronomie",
            likelihoodPercent: 20
        ),
        BingoIncident(
            id: "bistro_food_out",
            text: "Lieblingssnack ausverkauft",
            iconName: "tray.and.arrow.down.fill",
            rarity: .uncommon,
            category: "Gastronomie",
            likelihoodPercent: 26
        ),
        BingoIncident(
            id: "toilet_defects",
            text: "Mehrere WCs gleichzeitig zu",
            iconName: "nosign",
            rarity: .uncommon,
            category: "Komfort",
            likelihoodPercent: 24,
            exclusivityGroup: "wc_status"
        ),
        BingoIncident(
            id: "display_broken",
            text: "Zugzielanzeiger ausgefallen",
            iconName: "display.trianglebadge.exclamationmark",
            rarity: .uncommon,
            category: "Bahnhof",
            likelihoodPercent: 25
        ),
        BingoIncident(
            id: "ticket_machine_broken",
            text: "Ticketautomat außer Betrieb",
            iconName: "creditcard.trianglebadge.exclamationmark",
            rarity: .uncommon,
            category: "Bahnhof",
            likelihoodPercent: 22
        ),
        BingoIncident(
            id: "freezing_ac",
            text: "Klimaanlage fällt aus",
            iconName: "thermometer.snowflake",
            rarity: .uncommon,
            category: "Komfort",
            likelihoodPercent: 20
        ),
        BingoIncident(
            id: "switch_defect",
            text: "Stellwerksstörung gemeldet",
            iconName: "point.bottomleft.forward.to.point.topright.filled.scurvepath",
            rarity: .uncommon,
            category: "Infrastruktur",
            likelihoodPercent: 25
        ),
        BingoIncident(
            id: "catenary_damage",
            text: "Oberleitungsstörung",
            iconName: "bolt.horizontal.fill",
            rarity: .uncommon,
            category: "Infrastruktur",
            likelihoodPercent: 14
        ),

        // --- Durchsagen, Service & Mitreisende (Gelegentlich) ---
        BingoIncident(
            id: "senk_ju",
            text: "„Senk ju vor träwelling…“",
            iconName: "megaphone.fill",
            rarity: .uncommon,
            category: "Ansage",
            likelihoodPercent: 25
        ),
        BingoIncident(
            id: "honest_conductor",
            text: "Humorvolle Zugchef-Ansage",
            iconName: "quote.bubble.fill",
            rarity: .uncommon,
            category: "Ansage",
            likelihoodPercent: 28
        ),
        BingoIncident(
            id: "ticket_inspector_cheer",
            text: "Gut gelaunter Zugbegleiter",
            iconName: "face.smiling.fill",
            rarity: .uncommon,
            category: "Service",
            likelihoodPercent: 32
        ),
        BingoIncident(
            id: "no_ticket_check_whole_ride",
            text: "Ganze Fahrt ohne Kontrolle",
            iconName: "person.badge.shield.checkmark.fill",
            rarity: .uncommon,
            category: "Service",
            likelihoodPercent: 30
        ),
        BingoIncident(
            id: "ticket_invalid_complaint",
            text: "Diskussion über Ticket-Geltung",
            iconName: "ticket.fill",
            rarity: .uncommon,
            category: "Service",
            likelihoodPercent: 24
        ),
        BingoIncident(
            id: "wrong_train_boarded",
            text: "Fahrgast im falschen Zug",
            iconName: "exclamationmark.questionmark",
            rarity: .uncommon,
            category: "Fahrgäste",
            likelihoodPercent: 20
        ),
        BingoIncident(
            id: "wrong_wagon_reservation",
            text: "Falscher Tag / Zug reserviert",
            iconName: "calendar.badge.exclamationmark",
            rarity: .uncommon,
            category: "Fahrgäste",
            likelihoodPercent: 22
        ),
        BingoIncident(
            id: "sitting_on_floor_stairs",
            text: "Sitzen im Gang / Türbereich",
            iconName: "person.crop.rectangle.stack.fill",
            rarity: .uncommon,
            category: "Betrieb",
            likelihoodPercent: 26
        ),
        BingoIncident(
            id: "advent_calendar_doors",
            text: "„Bitte alle Türen nutzen“",
            iconName: "door.left.hand.open",
            rarity: .uncommon,
            category: "Ansage",
            likelihoodPercent: 28
        ),
        BingoIncident(
            id: "spilled_coffee_curve",
            text: "Getränk schwappt über",
            iconName: "drop.triangle.fill",
            rarity: .uncommon,
            category: "Komfort",
            likelihoodPercent: 22
        ),
        BingoIncident(
            id: "forgotten_bag",
            text: "Herrenloses Gepäckstück",
            iconName: "bag.badge.questionmark",
            rarity: .uncommon,
            category: "Fahrgäste",
            likelihoodPercent: 18
        ),
        BingoIncident(
            id: "family_area_business",
            text: "Laptop-Arbeit im Familienabteil",
            iconName: "briefcase.fill",
            rarity: .uncommon,
            category: "Fahrgäste",
            likelihoodPercent: 26
        ),
        BingoIncident(
            id: "bike_area_overfilled",
            text: "Radabteil voller Koffer",
            iconName: "suitcase.cart.fill",
            rarity: .uncommon,
            category: "Wagen",
            likelihoodPercent: 30
        ),
        BingoIncident(
            id: "spotter_at_platform",
            text: "Trainspotter am Bahnsteig",
            iconName: "camera.fill",
            rarity: .uncommon,
            category: "Sichtung",
            likelihoodPercent: 24
        ),
        BingoIncident(
            id: "conductor_asks_patience",
            text: "Dank für Geduld & Verständnis",
            iconName: "heart.fill",
            rarity: .uncommon,
            category: "Ansage",
            likelihoodPercent: 32
        ),

        // =========================================================================
        // MARK: - 4. SELTEN / KURIOSITÄTEN & LEGENDEN (Rare, 2–10% Wahrscheinlichkeit)
        // =========================================================================

        BingoIncident(
            id: "delay_60_min",
            text: "Über 60 Min. Verspätung",
            iconName: "eurosign.circle.fill",
            rarity: .rare,
            category: "Verspätung",
            likelihoodPercent: 10,
            exclusivityGroup: "delay_minutes"
        ),
        BingoIncident(
            id: "free_chocolate",
            text: "Gratis DB-Schokolade",
            iconName: "gift.fill",
            rarity: .rare,
            category: "Service",
            likelihoodPercent: 8
        ),
        BingoIncident(
            id: "free_water",
            text: "Gratis Wasser / Heißgetränk",
            iconName: "drop.fill",
            rarity: .rare,
            category: "Service",
            likelihoodPercent: 6
        ),
        BingoIncident(
            id: "on_time_miracle",
            text: "Ankunft mind. 2 Min. zu früh",
            iconName: "star.fill",
            rarity: .rare,
            category: "Wunder",
            likelihoodPercent: 9
        ),
        BingoIncident(
            id: "special_rainbow_view",
            text: "Sonder-ICE gesichtet",
            iconName: "rainbow",
            rarity: .rare,
            category: "Sichtung",
            likelihoodPercent: 8
        ),
        BingoIncident(
            id: "doctor_call",
            text: "„Arzt im Zug gesucht“",
            iconName: "cross.case.fill",
            rarity: .rare,
            category: "Vorfälle",
            likelihoodPercent: 6
        ),
        BingoIncident(
            id: "train_reboot",
            text: "Zug-Neustart im Stand",
            iconName: "arrow.clockwise.circle.fill",
            rarity: .rare,
            category: "Technik",
            likelihoodPercent: 7
        ),
        BingoIncident(
            id: "double_booked_seat",
            text: "Sitzplatz doppelt vergeben",
            iconName: "tag.fill",
            rarity: .rare,
            category: "Technik",
            likelihoodPercent: 7
        ),
        BingoIncident(
            id: "lost_driver",
            text: "Ablöse-Lokführer verspätet",
            iconName: "person.crop.circle.badge.questionmark",
            rarity: .rare,
            category: "Personal",
            likelihoodPercent: 7
        ),
        BingoIncident(
            id: "driver_rhyme_farewell",
            text: "Durchsage mit Reim / Witz",
            iconName: "theatermasks.fill",
            rarity: .rare,
            category: "Ansage",
            likelihoodPercent: 8
        ),
        BingoIncident(
            id: "bundesliga_announcement",
            text: "Fußball-Ergebnis angesagt",
            iconName: "sportscourt.fill",
            rarity: .rare,
            category: "Ansage",
            likelihoodPercent: 6
        ),
        BingoIncident(
            id: "first_class_upgrade",
            text: "1. Klasse freigegeben",
            iconName: "crown.fill",
            rarity: .rare,
            category: "Service",
            likelihoodPercent: 5
        ),
        BingoIncident(
            id: "stranded_nowhere",
            text: "Zug endet vorzeitig",
            iconName: "signpost.right.and.left.fill",
            rarity: .rare,
            category: "Betrieb",
            likelihoodPercent: 6
        ),
        BingoIncident(
            id: "wrong_turn",
            text: "Spontane Streckenumleitung",
            iconName: "arrow.uturn.backward",
            rarity: .rare,
            category: "Betrieb",
            likelihoodPercent: 8
        ),
        BingoIncident(
            id: "animals_on_track",
            text: "Tiere im Gleisbereich",
            iconName: "hare",
            rarity: .rare,
            category: "Natur",
            likelihoodPercent: 4
        ),
        BingoIncident(
            id: "tree_on_track",
            text: "Ast / Baum im Gleis",
            iconName: "tree.fill",
            rarity: .rare,
            category: "Infrastruktur",
            likelihoodPercent: 5
        ),
        BingoIncident(
            id: "fire_alarm_smoke",
            text: "Rauchmelder im WC ausgelöst",
            iconName: "smoke.fill",
            rarity: .rare,
            category: "Vorfälle",
            likelihoodPercent: 5
        ),
        BingoIncident(
            id: "beer_crate_party",
            text: "Partytruppe mit Musikbox",
            iconName: "party.popper.fill",
            rarity: .rare,
            category: "Fahrgäste",
            likelihoodPercent: 9
        ),
        BingoIncident(
            id: "steam_locomotive_view",
            text: "Dampflok / Messzug gesehen",
            iconName: "sparkles",
            rarity: .rare,
            category: "Sichtung",
            likelihoodPercent: 5
        ),
        BingoIncident(
            id: "emergency_braking",
            text: "Zwangsbremsung auf Strecke",
            iconName: "exclamationmark.octagon.fill",
            rarity: .rare,
            category: "Betrieb",
            likelihoodPercent: 5
        ),
        BingoIncident(
            id: "applause_on_arrival",
            text: "Applaus bei der Ankunft",
            iconName: "hands.clap.fill",
            rarity: .rare,
            category: "Fahrgäste",
            likelihoodPercent: 4
        ),
        BingoIncident(
            id: "child_shout_announcement",
            text: "Kind spricht ins Bordmikro",
            iconName: "mic.fill",
            rarity: .rare,
            category: "Ansage",
            likelihoodPercent: 3
        ),
        BingoIncident(
            id: "taxi_hotel_voucher",
            text: "Taxi- oder Hotelgutschein",
            iconName: "bed.double.fill",
            rarity: .rare,
            category: "Service",
            likelihoodPercent: 4
        ),
        BingoIncident(
            id: "announcement_loop_bug",
            text: "Anzeige / Ansage in Schleife",
            iconName: "repeat",
            rarity: .rare,
            category: "Technik",
            likelihoodPercent: 6
        )
    ]
}
