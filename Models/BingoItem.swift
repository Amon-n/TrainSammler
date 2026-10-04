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
        // MARK: - 1. Häufig / Alltägliche Klassiker
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
        
        // MARK: - 2. Ungewöhnlich / Kuriose & typische Erlebnisse
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
        
        // MARK: - 3. Selten / Kuriose Raritäten & Legenden
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
        )
    ]
}
