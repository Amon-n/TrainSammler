# 🚆 trainSammler

[![iOS 17+](https://img.shields.io/badge/iOS-17.0%2B-blue?logo=apple&style=flat-square)](https://developer.apple.com/ios/)
[![Swift 5.9+](https://img.shields.io/badge/Swift-5.9%2B-orange?logo=swift&style=flat-square)](https://swift.org/)
[![SwiftUI](https://img.shields.io/badge/UI-SwiftUI-purple?style=flat-square)](https://developer.apple.com/xcode/swiftui/)
[![SwiftData](https://img.shields.io/badge/Storage-SwiftData-green?style=flat-square)](https://developer.apple.com/documentation/swiftdata)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](LICENSE)

Das „Autokennzeichen-Sammeln“ für den Bahnverkehr in Deutschland! **trainSammler** ist eine native, moderne und gamifizierte iOS-App zum Spotten von DB-Zügen, ICE-Baureihen, Triebzugnummern (Tz) und seltenen Sonderzügen (wie dem Regenbogen- oder Europa-ICE).

---

## ✨ Features

- ⚡ **Schnell-Sichtung am Bahnsteig:** 1-Tap-Zugriff auf die wichtigsten Alltags-Baureihen, automatischer GPS-Bahnhofsstamp und optimierte Einhand-Bedienung.
- 🗂️ **Train-Dex (Sammelkarten):** Sammle und entdecke alle ICE-Baureihen von der Ikone ICE 1 bis zum modernen ICE 3neo. Unentdeckte Züge erscheinen geheimnisvoll als Silhouette.
- 🔍 **Interaktives Datenblatt:** Detaillierte Baureihen-Informationen, Höchstgeschwindigkeit, Taufnamen, historische Besonderheiten und persönliche Sichtungs-Historie.
- 🏆 **Gamification & Ränge:** Sammle Erfahrungspunkte (XP) basierend auf Seltenheit (*Common, Uncommon, Rare, Legendary*) und 2x First-Catch-Boni. Steige vom *Bahnsteig-Neuling* bis zur *ICE-Legende* auf.
- 📜 **Logbuch & MapKit-Karte:** Alle Sichtungen mit Datum, Tz-Nummer, optionalem Beweisfoto und interaktiver Kartenansicht aller besuchten Bahnhöfe.
- 🔒 **100% Offline & Privat (DSGVO-konform):** Alle Daten, Fotos und Standorte verbleiben ausschließlich lokal auf dem iPhone (SwiftData). Kein Tracking, keine Werbung, keine Benutzerkonten.

---

## 🏗️ Architektur & Clean Code

Die App setzt auf den modernsten Apple-Technologie-Stack mit sauberer MVVM-Architektur:

- **SwiftUI + Observation:** Reaktives UI-Rendering mit dem `@Observable`-Makro (iOS 17+) anstelle von Combine.
- **SwiftData:** Robustes, relationales lokales Schema mit `@Model`, 1:N-Beziehungen und `@Attribute(.externalStorage)` für ressourcenschonende Fotoverwaltung.
- **CoreLocation & Geocoding:** Modernes `async/await` Reverse-Geocoding für die sekundenschnelle Adress- und Bahnhofsauflösung.
- **MapKit:** Native SwiftUI-Map mit dynamischen Koordinaten-Annotationen.
- **Taktiles Feedback:** Sanfte Haptics über `UIImpactFeedbackGenerator` und `UINotificationFeedbackGenerator`.

```
trainsammler/
├── App/
│   └── TrainSammlerApp.swift       // App-Entry, ModelContainer & Pre-Seeding
├── Models/
│   ├── Enums.swift                 // RarityTier & TrainCategory
│   ├── TrainModel.swift            // SwiftData Schema für Baureihen/Katalog
│   └── SpottedTrain.swift          // SwiftData Schema für konkrete Sichtungen
├── Services/
│   ├── LocationManager.swift       // Thread-safe CoreLocation Service mit async Geocoding
│   └── DataSeeder.swift            // Lokale DB-Befüllung & automatische Bildmigration
├── ViewModels/
│   ├── QuickSpotViewModel.swift    // Bahnsteig-Workflow, Validierung & Toast-Feedback
│   └── StatsViewModel.swift        // Gamification-Engine, XP-Score & Level-Berechnung
└── Views/
    ├── ContentView.swift           // Root TabView Navigation
    ├── QuickSpotView.swift         // High-Speed Bahnsteig-Sichtung
    ├── TrainCatalogView.swift      // "Train-Dex" Sammel-Katalog mit Trading Cards
    ├── TrainDetailView.swift       // Detailliertes Baureihen-Datenblatt
    ├── SpottedHistoryView.swift    // Chronologisches Logbuch & MapKit-Kartenansicht
    ├── StatsView.swift             // Gamification-Dashboard, Level & Rarest Catch
    ├── SettingsView.swift          // Datenschutz (DSGVO), Datenlöschung & Bildnachweise
    └── Components/
        ├── RarityBadgeView.swift   // Visuelle Seltenheits-Badges mit Glow
        └── TrainImageView.swift    // Native Bild-Komponente mit Silhouette-Modus
```

---

## 🚀 Schnellstart in Xcode

1. Repository klonen:
   ```bash
   git clone https://github.com/Amon-n/TrainSammler.git
   cd TrainSammler
   ```
2. Projekt in Xcode öffnen:
   ```bash
   open trainSammler.xcodeproj
   ```
3. Wähle oben im Simulator-Menü ein beliebiges iOS-Gerät (z. B. **iPhone 16 Pro**) und drücke **`Cmd + R`**.

---

## 🛡️ Datenschutz & App Store Readiness

`trainSammler` erfüllt alle aktuellen Richtlinien für den Apple App Store:
- **DSGVO / GDPR konform:** Keine Datenübertragung, keine externen Server.
- **Apple Review Guideline 5.1.1:** Transparente Datenschutzerklärung direkt in der App ([SettingsView.swift](Views/SettingsView.swift)).
- **Vollständige Nutzerkontrolle:** Individuelles Löschen per Swipe im Logbuch sowie Option zum vollständigen Zurücksetzen in den Einstellungen.
- **Native Berechtigungen:** Alle Nutzungstexte für Kamera, Fotos und Standort sind in [Info.plist](Info.plist) deklariert.
- **Icon:** Vollständiges 1024x1024 App Icon Set in `Assets.xcassets`.

---

## 📷 Bildnachweise (Creative Commons)

Die im Baureihen-Katalog verwendeten Zuginformationen und Fotos stammen von freien Eisenbahn-Fotografen auf **Wikimedia Commons** und stehen unter freien Creative-Commons-Lizenzen (CC BY-SA / CC0). 
Eine vollständige Liste aller Urheber und Lizenzen findest du in [ATTRIBUTION.md](ATTRIBUTION.md) sowie direkt in den Einstellungen der App.

---

## 🤝 Beitragen & Open Source

Contributions, Feature-Vorschläge und Bug-Reports sind herzlich willkommen!
1. Forke das Repository
2. Erstelle einen Feature Branch (`git checkout -b feature/NeuerZug`)
3. Committe deine Änderungen (`git commit -m 'feat: Neue Baureihe hinzugefügt'`)
4. Pushe auf deinen Branch (`git push origin feature/NeuerZug`)
5. Öffne einen Pull Request

---

## 📄 Lizenz

Dieses Projekt ist unter der **MIT-Lizenz** lizenziert. Siehe [LICENSE](LICENSE) für Details.
