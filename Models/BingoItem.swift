import Foundation
import SwiftUI

public enum BingoRarity: String, Codable, Sendable {
    case common
    case uncommon
    case rare
    
    public var badgeColor: Color {
        switch self {
        case .common: return .blue
        case .uncommon: return .orange
        case .rare: return .purple
        }
    }
}

public struct BingoIncident: Identifiable, Sendable {
    public let id: String
    public let text: String
    public let iconName: String
    public let rarity: BingoRarity
    public let category: String
    
    public init(id: String, text: String, iconName: String, rarity: BingoRarity, category: String) {
        self.id = id
        self.text = text
        self.iconName = iconName
        self.rarity = rarity
        self.category = category
    }
}

public struct BingoCatalog {
    public static let incidents: [BingoIncident] = [
        // MARK: - 1. Häufig / Alltägliche Klassiker (40 Einträge)
        BingoIncident(
            id: "prev_delay",
            text: "Verspätung aus vorheriger Fahrt",
            iconName: "clock.badge.exclamationmark",
            rarity: .common,
            category: "Betrieb"
        ),
        BingoIncident(
            id: "no_coffee",
            text: "Kaffeemaschine im Bordbistro defekt",
            iconName: "cup.and.saucer.fill",
            rarity: .common,
            category: "Gastronomie"
        ),
        BingoIncident(
            id: "reverse_order",
            text: "Umgekehrte Wagenreihung",
            iconName: "arrow.left.arrow.right",
            rarity: .common,
            category: "Wagen"
        ),
        BingoIncident(
            id: "track_change",
            text: "Gleiswechsel kurz vor Einfahrt",
            iconName: "arrow.triangle.swap",
            rarity: .common,
            category: "Bahnhof"
        ),
        BingoIncident(
            id: "wifi_portal_only",
            text: "WLAN lädt nur Zugportal-Startseite",
            iconName: "wifi.slash",
            rarity: .common,
            category: "Technik"
        ),
        BingoIncident(
            id: "door_defect",
            text: "Türstörung / Einstieg abgesperrt",
            iconName: "door.left.hand.closed",
            rarity: .common,
            category: "Technik"
        ),
        BingoIncident(
            id: "signal_fault",
            text: "Signal- oder Stellwerksstörung",
            iconName: "trafficlight.fill",
            rarity: .common,
            category: "Infrastruktur"
        ),
        BingoIncident(
            id: "passed_by_ice",
            text: "Überholung durch verspäteten ICE",
            iconName: "hare.fill",
            rarity: .common,
            category: "Betrieb"
        ),
        BingoIncident(
            id: "people_on_track",
            text: "Personen / Gegenstände im Gleis",
            iconName: "figure.walk.alert",
            rarity: .common,
            category: "Betrieb"
        ),
        BingoIncident(
            id: "display_broken",
            text: "Wagenanzeiger am Bahnsteig defekt",
            iconName: "display.trianglebadge.exclamationmark",
            rarity: .common,
            category: "Bahnhof"
        ),
        BingoIncident(
            id: "freezing_ac",
            text: "Klimaanlage kühlt auf Arktis-Niveau",
            iconName: "snowflake",
            rarity: .common,
            category: "Komfort"
        ),
        BingoIncident(
            id: "heating_summer",
            text: "Heizung läuft im Hochsommer",
            iconName: "flame.fill",
            rarity: .common,
            category: "Komfort"
        ),
        BingoIncident(
            id: "toilet_defects",
            text: "Mindestens 2 Toiletten abgeschlossen",
            iconName: "nosign",
            rarity: .common,
            category: "Komfort"
        ),
        BingoIncident(
            id: "connection_missed",
            text: "Anschlusszug fährt vor der Nase weg",
            iconName: "figure.run",
            rarity: .common,
            category: "Betrieb"
        ),
        BingoIncident(
            id: "waiting_for_passengers",
            text: "Warten auf verspätete Fahrgäste",
            iconName: "person.2.badge.gearshape.fill",
            rarity: .common,
            category: "Betrieb"
        ),
        BingoIncident(
            id: "seat_taken",
            text: "Reservierter Platz belegt & Streit",
            iconName: "chair.lounge.fill",
            rarity: .common,
            category: "Fahrgäste"
        ),
        BingoIncident(
            id: "loud_phone_call",
            text: "Lautes Business-Telefonat im Ruhebereich",
            iconName: "phone.down.waves.left.and.right",
            rarity: .common,
            category: "Fahrgäste"
        ),
        BingoIncident(
            id: "no_power_plug",
            text: "Steckdose am Sitzplatz ohne Strom",
            iconName: "bolt.slash.fill",
            rarity: .common,
            category: "Technik"
        ),
        BingoIncident(
            id: "tiktok_speaker",
            text: "Fahrgast schaut Videos ohne Kopfhörer",
            iconName: "speaker.wave.3.fill",
            rarity: .common,
            category: "Fahrgäste"
        ),
        BingoIncident(
            id: "slow_down_construction",
            text: "Langsamfahrstelle wegen Baustelle",
            iconName: "cone.fill",
            rarity: .common,
            category: "Infrastruktur"
        ),
        BingoIncident(
            id: "catenary_damage",
            text: "Schaden an der Oberleitung",
            iconName: "bolt.horizontal.fill",
            rarity: .common,
            category: "Infrastruktur"
        ),
        BingoIncident(
            id: "waiting_single_track",
            text: "Warten auf Gegenzug auf eingleisiger Strecke",
            iconName: "arrow.triangle.branch",
            rarity: .common,
            category: "Betrieb"
        ),
        BingoIncident(
            id: "coach_missing",
            text: "Ein Wagen fehlt im Zugverband",
            iconName: "train.side.rear.car",
            rarity: .common,
            category: "Wagen"
        ),
        BingoIncident(
            id: "ticket_invalid_complaint",
            text: "„Ihr Ticket ist in diesem Zug nicht gültig!“",
            iconName: "ticket.fill",
            rarity: .common,
            category: "Service"
        ),
        BingoIncident(
            id: "aisle_blocked_suitcases",
            text: "Koffer blockieren den kompletten Gang",
            iconName: "suitcase.fill",
            rarity: .common,
            category: "Komfort"
        ),
        BingoIncident(
            id: "bike_area_overfilled",
            text: "Fahrradabteil vollgestellt mit Koffern",
            iconName: "bicycle",
            rarity: .common,
            category: "Wagen"
        ),
        BingoIncident(
            id: "ticket_machine_broken",
            text: "Fahrkartenautomat am Bahnhof außer Betrieb",
            iconName: "creditcard.trianglebadge.exclamationmark",
            rarity: .common,
            category: "Bahnhof"
        ),
        BingoIncident(
            id: "speaker_crackling",
            text: "Lautsprecherdurchsage unverständlich / krächzt",
            iconName: "waveform.badge.exclamationmark",
            rarity: .common,
            category: "Ansage"
        ),
        BingoIncident(
            id: "bus_sev",
            text: "Schienenersatzverkehr (SEV) mit Bus",
            iconName: "bus.fill",
            rarity: .common,
            category: "Betrieb"
        ),
        BingoIncident(
            id: "app_vs_platform_mismatch",
            text: "DB Navigator & Bahnsteiganzeige widersprüchlich",
            iconName: "arrow.up.and.down.and.sparkles",
            rarity: .common,
            category: "Technik"
        ),
        BingoIncident(
            id: "delay_creeping_up",
            text: "Verspätung klettert schrittweise um +5 Min",
            iconName: "hourglass",
            rarity: .common,
            category: "Betrieb"
        ),
        BingoIncident(
            id: "polite_apology",
            text: "„Wir bitten um Entschuldigung für die Verspätung“",
            iconName: "hand.raised.fill",
            rarity: .common,
            category: "Ansage"
        ),
        BingoIncident(
            id: "loud_typing",
            text: "Ruhebereich: Extrem lautes Tippen auf Tastatur",
            iconName: "keyboard.fill",
            rarity: .common,
            category: "Fahrgäste"
        ),
        BingoIncident(
            id: "smell_of_food",
            text: "Geruch von Döner, Mettbrötchen oder Ei",
            iconName: "fork.knife",
            rarity: .common,
            category: "Fahrgäste"
        ),
        BingoIncident(
            id: "morning_beer",
            text: "Bierdose zischt vor 10:00 Uhr morgens",
            iconName: "mug.fill",
            rarity: .common,
            category: "Fahrgäste"
        ),
        BingoIncident(
            id: "abrupt_braking",
            text: "Zug fährt an und bremst nach 5 Metern ruckartig",
            iconName: "brakesignal",
            rarity: .common,
            category: "Betrieb"
        ),
        BingoIncident(
            id: "passenger_rights_form",
            text: "Fahrgastrechte-Formular wird verteilt",
            iconName: "doc.text.fill",
            rarity: .common,
            category: "Service"
        ),
        BingoIncident(
            id: "trash_overflow",
            text: "Mülleimer am Platz quillt komplett über",
            iconName: "trash.fill",
            rarity: .common,
            category: "Komfort"
        ),
        BingoIncident(
            id: "overhead_rack_full",
            text: "Gepäckablage überfüllt – Koffer fallen fast raus",
            iconName: "tray.full.fill",
            rarity: .common,
            category: "Komfort"
        ),
        BingoIncident(
            id: "speed_restricted_heat",
            text: "Verminderte Geschwindigkeit wegen Hitze/Kälte",
            iconName: "thermometer.sun.fill",
            rarity: .common,
            category: "Infrastruktur"
        ),

        // MARK: - 2. Ungewöhnlich / Kuriose & typische Erlebnisse (35 Einträge)
        BingoIncident(
            id: "senk_ju",
            text: "„Senk ju vor träwelling wis Deutsche Bahn“",
            iconName: "megaphone.fill",
            rarity: .uncommon,
            category: "Ansage"
        ),
        BingoIncident(
            id: "honest_conductor",
            text: "Herrlich ehrliche Ansage des Zugchefs",
            iconName: "quote.bubble.fill",
            rarity: .uncommon,
            category: "Ansage"
        ),
        BingoIncident(
            id: "waiting_at_signal",
            text: "5 Min vor dem Ziel am Haltesignal stehen",
            iconName: "pause.circle.fill",
            rarity: .uncommon,
            category: "Betrieb"
        ),
        BingoIncident(
            id: "no_reservation_system",
            text: "Reservierungsanzeige: „Ggf. reserviert“",
            iconName: "tag.slash.fill",
            rarity: .uncommon,
            category: "Technik"
        ),
        BingoIncident(
            id: "short_train",
            text: "Zugteil fehlt – Kurzzug statt Vollzug",
            iconName: "scissors",
            rarity: .uncommon,
            category: "Wagen"
        ),
        BingoIncident(
            id: "free_chocolate",
            text: "Zugbegleiter verteilt DB-Schokolade",
            iconName: "gift.fill",
            rarity: .uncommon,
            category: "Service"
        ),
        BingoIncident(
            id: "free_water",
            text: "Kostenloses Wasser wegen Verspätung/Hitze",
            iconName: "drop.fill",
            rarity: .uncommon,
            category: "Service"
        ),
        BingoIncident(
            id: "police_ticketless",
            text: "Bundespolizei holt Schwarzfahrer ab",
            iconName: "shield.lefthalf.filled",
            rarity: .uncommon,
            category: "Vorfälle"
        ),
        BingoIncident(
            id: "bistro_cash_only",
            text: "Bordbistro: Nur Barzahlung möglich",
            iconName: "banknote.fill",
            rarity: .uncommon,
            category: "Gastronomie"
        ),
        BingoIncident(
            id: "beer_crate_party",
            text: "Junggesellenabschied mit Bierkiste im Gang",
            iconName: "party.popper.fill",
            rarity: .uncommon,
            category: "Fahrgäste"
        ),
        BingoIncident(
            id: "dog_cuteness",
            text: "Sehr brav schlafender Hund unter dem Sitz",
            iconName: "pawprint.fill",
            rarity: .uncommon,
            category: "Fahrgäste"
        ),
        BingoIncident(
            id: "child_shout_announcement",
            text: "Kind darf Durchsage ins Mikrofon sprechen",
            iconName: "sparkles",
            rarity: .uncommon,
            category: "Ansage"
        ),
        BingoIncident(
            id: "fire_alarm_smoke",
            text: "Raucher löst WC-Feueralarm aus",
            iconName: "smoke.fill",
            rarity: .uncommon,
            category: "Vorfälle"
        ),
        BingoIncident(
            id: "switch_defect",
            text: "Weichenstörung mitten auf freier Strecke",
            iconName: "point.bottomleft.forward.to.point.topright.filled.scurvepath",
            rarity: .uncommon,
            category: "Infrastruktur"
        ),
        BingoIncident(
            id: "wrong_train_boarded",
            text: "Fahrgast bemerkt zu spät: falscher Zug!",
            iconName: "exclamationmark.questionmark",
            rarity: .uncommon,
            category: "Fahrgäste"
        ),
        BingoIncident(
            id: "train_reboot",
            text: "Zug-Neustart: Licht geht komplett aus",
            iconName: "arrow.clockwise.circle.fill",
            rarity: .uncommon,
            category: "Technik"
        ),
        BingoIncident(
            id: "advent_calendar_doors",
            text: "„Dieser Zug ist kein Adventskalender – alle Türen nutzen!“",
            iconName: "door.left.hand.open",
            rarity: .uncommon,
            category: "Ansage"
        ),
        BingoIncident(
            id: "bistro_food_out",
            text: "Bordbistro: Alle warmen Speisen ausverkauft",
            iconName: "tray.and.arrow.down.fill",
            rarity: .uncommon,
            category: "Gastronomie"
        ),
        BingoIncident(
            id: "overcrowded_evacuation_plea",
            text: "Zug überfüllt – Bitte um freiwilliges Aussteigen",
            iconName: "person.3.fill",
            rarity: .uncommon,
            category: "Betrieb"
        ),
        BingoIncident(
            id: "driver_rhyme_farewell",
            text: "Lokführer verabschiedet sich mit Reim oder Witz",
            iconName: "theatermasks.fill",
            rarity: .uncommon,
            category: "Ansage"
        ),
        BingoIncident(
            id: "no_ticket_check_whole_ride",
            text: "Fahrkarte wird während ganzer Fahrt nicht kontrolliert",
            iconName: "person.badge.shield.checkmark.fill",
            rarity: .uncommon,
            category: "Service"
        ),
        BingoIncident(
            id: "taxi_hotel_voucher",
            text: "Hotel- oder Taxigutschein wegen Anschlussausfall",
            iconName: "bed.double.fill",
            rarity: .uncommon,
            category: "Service"
        ),
        BingoIncident(
            id: "family_area_business",
            text: "Kleinkindabteil komplett von Geschäftsleuten belegt",
            iconName: "figure.and.child.holdinghands",
            rarity: .uncommon,
            category: "Fahrgäste"
        ),
        BingoIncident(
            id: "abandoned_luggage_police",
            text: "Herrenloser Koffer sorgt für Polizeieinsatz",
            iconName: "briefcase.fill",
            rarity: .uncommon,
            category: "Vorfälle"
        ),
        BingoIncident(
            id: "missed_station_stop",
            text: "Zug hält aus Versehen nicht am geplanten Bahnhof",
            iconName: "forward.frame.fill",
            rarity: .uncommon,
            category: "Betrieb"
        ),
        BingoIncident(
            id: "delay_recovery_speed",
            text: "Verspätung schrumpft durch Vollgas um 10 Minuten",
            iconName: "arrow.right.to.line.compact",
            rarity: .uncommon,
            category: "Betrieb"
        ),
        BingoIncident(
            id: "tree_on_track",
            text: "Streckensperrung wegen Baum im Gleisbett",
            iconName: "tree.fill",
            rarity: .uncommon,
            category: "Infrastruktur"
        ),
        BingoIncident(
            id: "waiting_for_our_own_crew",
            text: "Warten auf Personal, das im selben Zug mitfährt",
            iconName: "person.badge.clock.fill",
            rarity: .uncommon,
            category: "Personal"
        ),
        BingoIncident(
            id: "medical_incident_nearby",
            text: "Notarzteinsatz am Nachbargleis verzögert Abfahrt",
            iconName: "heart.text.square.fill",
            rarity: .uncommon,
            category: "Vorfälle"
        ),
        BingoIncident(
            id: "double_booked_seat",
            text: "Doppelt reservierter Sitzplatz (beide mit Beleg)",
            iconName: "tag.fill",
            rarity: .uncommon,
            category: "Technik"
        ),
        BingoIncident(
            id: "forgotten_bag",
            text: "Fahrgast rennt zurück wegen vergessener Tasche",
            iconName: "bag.badge.questionmark",
            rarity: .uncommon,
            category: "Fahrgäste"
        ),
        BingoIncident(
            id: "spilled_coffee_curve",
            text: "Kaffee schwappt in scharfer Weichenkurve über",
            iconName: "cup.and.saucer",
            rarity: .uncommon,
            category: "Komfort"
        ),
        BingoIncident(
            id: "announcement_loop_bug",
            text: "Automatische Ansage hängt in Dauerschleife",
            iconName: "repeat",
            rarity: .uncommon,
            category: "Ansage"
        ),
        BingoIncident(
            id: "conductor_asks_patience",
            text: "Zugchef wünscht Durchhaltevermögen & starke Nerven",
            iconName: "quote.opening",
            rarity: .uncommon,
            category: "Ansage"
        ),
        BingoIncident(
            id: "ticket_inspector_cheer",
            text: "Besonders gut gelaunter & witziger Zugbegleiter",
            iconName: "face.smiling.fill",
            rarity: .uncommon,
            category: "Service"
        ),

        // MARK: - 3. Selten / Kuriose Raritäten & Legenden (22 Einträge)
        BingoIncident(
            id: "lost_driver",
            text: "Warten auf Lokführer / Ablöse verschollen",
            iconName: "person.crop.circle.badge.questionmark",
            rarity: .rare,
            category: "Personal"
        ),
        BingoIncident(
            id: "wrong_turn",
            text: "Zug ist buchstäblich falsch abgebogen",
            iconName: "arrow.uturn.backward",
            rarity: .rare,
            category: "Legenden"
        ),
        BingoIncident(
            id: "on_time_miracle",
            text: "Zug hält auf die Sekunde pünktlich!",
            iconName: "star.fill",
            rarity: .rare,
            category: "Wunder"
        ),
        BingoIncident(
            id: "animals_on_track",
            text: "Kuh- oder Schafherde blockiert Gleise",
            iconName: "tortoise.fill",
            rarity: .rare,
            category: "Natur"
        ),
        BingoIncident(
            id: "balloon_catenary",
            text: "Folienballon in Oberleitung geschmolzen",
            iconName: "balloon.fill",
            rarity: .rare,
            category: "Infrastruktur"
        ),
        BingoIncident(
            id: "bistro_sold_out",
            text: "Bordbistro komplett leer gegessen",
            iconName: "cart.badge.minus",
            rarity: .rare,
            category: "Gastronomie"
        ),
        BingoIncident(
            id: "doctor_call",
            text: "„Befindet sich ein Arzt an Bord?“",
            iconName: "cross.case.fill",
            rarity: .rare,
            category: "Vorfälle"
        ),
        BingoIncident(
            id: "famous_spotter",
            text: "Trainspotter mit Profi-Stativ an der Strecke",
            iconName: "camera.fill",
            rarity: .rare,
            category: "Spotter"
        ),
        BingoIncident(
            id: "special_rainbow_view",
            text: "Regenbogen- oder Europa-ICE fährt vorbei",
            iconName: "rainbow",
            rarity: .rare,
            category: "Sichtung"
        ),
        BingoIncident(
            id: "train_split_chaos",
            text: "Zugtrennung / Flügelung schlägt fehl",
            iconName: "arrow.triangle.pull",
            rarity: .rare,
            category: "Betrieb"
        ),
        BingoIncident(
            id: "stranded_nowhere",
            text: "Zug endet vorzeitig im Nirgendwo ('Alle aussteigen!')",
            iconName: "signpost.right.and.left.fill",
            rarity: .rare,
            category: "Betrieb"
        ),
        BingoIncident(
            id: "applause_on_arrival",
            text: "Fahrgäste klatschen laut bei Ankunft am Endbahnhof",
            iconName: "hands.clap.fill",
            rarity: .rare,
            category: "Fahrgäste"
        ),
        BingoIncident(
            id: "wallet_returned_honest",
            text: "Gefundene Geldbörse wird ehrlich abgegeben",
            iconName: "wallet.pass.fill",
            rarity: .rare,
            category: "Wunder"
        ),
        BingoIncident(
            id: "bistro_cake_callout",
            text: "Bistro ruft frisch gebackenen Kuchen durch den Zug aus",
            iconName: "birthday.cake.fill",
            rarity: .rare,
            category: "Gastronomie"
        ),
        BingoIncident(
            id: "emergency_braking",
            text: "Zwangsbremsung nach Signalbeeinflussung (PZB)",
            iconName: "exclamationmark.octagon.fill",
            rarity: .rare,
            category: "Betrieb"
        ),
        BingoIncident(
            id: "bundesliga_announcement",
            text: "Lokführer gibt Bundesliga-Zwischenstand durch",
            iconName: "sportscourt.fill",
            rarity: .rare,
            category: "Ansage"
        ),
        BingoIncident(
            id: "first_class_upgrade",
            text: "Kostenloses 1.-Klasse-Upgrade wegen Überfüllung",
            iconName: "sparkle.magnifyingglass",
            rarity: .rare,
            category: "Service"
        ),
        BingoIncident(
            id: "steam_locomotive_view",
            text: "Historische Dampflok / Nostalgiezug fährt vorbei",
            iconName: "smoke",
            rarity: .rare,
            category: "Sichtung"
        ),
        BingoIncident(
            id: "early_departure",
            text: "Zug fährt 3 Minuten VOR Plan ab",
            iconName: "clock.arrow.2.circlepath",
            rarity: .rare,
            category: "Wunder"
        ),
        BingoIncident(
            id: "vip_passenger",
            text: "Prominenter / Politiker sitzt im selben Waggon",
            iconName: "person.crop.circle.badge.star",
            rarity: .rare,
            category: "Fahrgäste"
        ),
        BingoIncident(
            id: "children_cinema",
            text: "Kinderkino im ICE läuft tatsächlich ohne Störung",
            iconName: "film.fill",
            rarity: .rare,
            category: "Komfort"
        ),
        BingoIncident(
            id: "locomotive_change",
            text: "Lokomotive muss im Kopfbahnhof getauscht werden",
            iconName: "arrow.triangle.swap",
            rarity: .rare,
            category: "Wagen"
        )
    ]
}
