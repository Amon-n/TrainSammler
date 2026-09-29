import SwiftUI

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
    /// Liste aller verfügbaren Bilder für die Bildergalerie
    public var galleryImageNames: [String] {
        var images: [String] = []
        
        // Primäres Asset
        images.append(assetName)
        
        // Spezifische Sekundärbilder / Frontaufnahmen
        switch seriesCode {
        case _ where seriesCode.contains("408"): // ICE 3neo
            images.append("ice_3neo_2")
            images.append("ice_3_velaro")
        case _ where seriesCode.contains("401"): // ICE 1
            images.append("ice_1_front")
        case _ where seriesCode.contains("402"): // ICE 2
            images.append("ice_2_front")
        case _ where seriesCode.contains("403") && !seriesCode.contains("Tz 304"): // ICE 3
            images.append("ice_3_front")
        case _ where seriesCode.contains("406") && !seriesCode.contains("Tz 4601"): // ICE 3M
            images.append("ice_3_front")
        case _ where seriesCode.contains("411") || seriesCode.contains("415"): // ICE-T
            images.append("ice_t_front")
        case _ where seriesCode.contains("Tz 304"): // Regenbogen
            images.append("ice_3_front")
        case _ where seriesCode.contains("Tz 4601"): // Europa
            images.append("ice_3_front")
        case _ where seriesCode.contains("412"): // ICE 4
            images.append("ice_4")
        case _ where seriesCode.contains("105"): // ICE L
            images.append("ice_l")
        case _ where seriesCode.contains("101"): // BR 101
            images.append("br_101")
        default:
            break
        }
        
        // Duplikate entfernen und Reihenfolge beibehalten
        var seen = Set<String>()
        return images.filter { seen.insert($0).inserted }
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
