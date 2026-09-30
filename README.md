# 🚆 TrainSammler

[![iOS 17+](https://img.shields.io/badge/iOS-17.0%2B-blue?logo=apple&style=flat-square)](https://developer.apple.com/ios/)
[![Swift 5.9+](https://img.shields.io/badge/Swift-5.9%2B-orange?logo=swift&style=flat-square)](https://swift.org/)
[![SwiftUI](https://img.shields.io/badge/UI-SwiftUI-purple?style=flat-square)](https://developer.apple.com/xcode/swiftui/)
[![SwiftData](https://img.shields.io/badge/Storage-SwiftData-green?style=flat-square)](https://developer.apple.com/documentation/swiftdata)
[![Version](https://img.shields.io/badge/Version-1.1%20(Build%201)-teal?style=flat-square)](Info.plist)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](LICENSE)

Das „Autokennzeichen-Sammeln“ für den Bahnverkehr in Deutschland! **TrainSammler** ist eine native, moderne und gamifizierte iOS-App zum Spotten von DB-Zügen, ICE-Baureihen, Regionalverkehr-Triebzügen, Triebzugnummern (Tz) und seltenen Sonderzügen (wie dem Regenbogen- oder Europa-ICE).

---

## ✨ Features

- ⚡ **Schnell-Sichtung am Bahnsteig:** 1-Tap-Schnellauswahl der häufigsten Alltags-Baureihen, automatischer GPS-Standort-Stamp via CoreLocation und optimierte Einhand-Bedienung.
- 🗂️ **Train-Dex (31 Baureihen):** Vollständiger Katalog über Fernverkehr (ICE 1 bis ICE 3neo, ICE L, ICE T/TD), Regionalverkehr (FLIRT, Talent, Desiro HC, Mireo, Twindexx, KISS, u.v.m.) sowie Test- und Sonderzüge (ICE S, Advanced TrainLab, Sylt Shuttle Plus).
- 📸 **Multi-Bildergalerie & Eigene Fotos:**
  - Wische interaktiv durch hochauflösende Perspektiven (Frontansicht, Seitenprofil, Streckenfahrt, Führerstand/Innenansicht) – auch vor der Freischaltung zum visuellen Abgleich!
  - Persönliche Beweisfotos deiner Sichtungen werden automatisch in die Detail-Galerie des jeweiligen Zuges integriert.
- 🔍 **Spotter-Guide & Erkennungsmerkmale:** Ausführliche Identifikationstipps pro Zug (Scheinwerferform, Frontnase, Stromabnehmer, Türanordnung) für zielsicheres Erkennen am Gleis.
- 🏆 **Gamification & Rangsystem:** Bahn-XP basierend auf Seltenheit (*Common, Uncommon, Rare, Legendary*) mit 2x First-Catch-Bonus für Erstfunde. Steige vom *Bahnsteig-Neuling* bis zur *ICE-Legende* auf.
- 📜 **Logbuch & MapKit-Karte:** Alle Sichtungen mit Datum, Tz-Nummer, Notizen, optionalem Beweisfoto und interaktiver Kartenansicht deiner gespotteten Bahnhöfe.
- 🔒 **100% Offline & Privat (DSGVO-konform):** Alle Daten, Notizen, Fotos und Standorte verbleiben ausschließlich lokal auf dem iPhone (SwiftData). Kein Tracking, keine Werbung, keine Benutzerkonten.

---

## 🏗️ Architektur & Clean Code

Die App ist nach modernen Clean-Code-Prinzipien und strikter MVVM-Architektur aufgebaut:

- **SwiftUI + Observation:** Reaktives State-Management mit dem `@Observable`-Makro (iOS 17+) ohne veraltetes Combine/`ObservableObject`.
- **SwiftData:** Relationale Modellierung (`TrainModel` 1:N `SpottedTrain`) mit kaskadierender Integrität, typisierten Predicates und `@Attribute(.externalStorage)` für ressourcenschonende Fotoverwaltung.
- **CoreLocation Service:** Thread-sicherer `@MainActor`-isolierter `LocationManager` mit modernem `async/await` Reverse-Geocoding.
- **Typisierte Gamification-Engine:** Entkoppelte `StatsCalculator`-Domain-Logik, die typisierte `TrainStats`- und `UserRank`-Modelle erzeugt.
- **Design-System:** Modulare UI-Komponenten (`RarityBadgeView`, `TrainImageView`, `FactPill`) mit dynamischen Farbverläufen und Dark-Mode-Support.

```
trainsammler/
├── App/
│   └── TrainSammlerApp.swift              // App-Lifecycle, ModelContainer & Pre-Seeding
├── Models/
│   ├── Enums.swift                        // RarityTier & TrainCategory
│   ├── TrainModel.swift                   // SwiftData Schema für Baureihen/Katalog
│   ├── TrainModel+Identification.swift    // Spotter-Guide & Identifikationsmerkmale
│   └── SpottedTrain.swift                 // SwiftData Schema für Sichtungen & Fotos
├── Services/
│   ├── LocationManager.swift              // CoreLocation Service mit async Reverse-Geocoding
│   └── DataSeeder.swift                   // Lokales Catalog-Seeding (31 Züge) & Bildmapping
├── ViewModels/
│   ├── QuickSpotViewModel.swift           // Bahnsteig-Workflow, Validierung & Feedback
│   └── StatsViewModel.swift               // Gamification-Engine, TrainStats & UserRank
├── Views/
│   ├── ContentView.swift                  // Root TabView Navigation (Spotten, Train-Dex, Logbuch, Stats)
│   ├── QuickSpotView.swift                // High-Speed Bahnsteig-Erfassung
│   ├── TrainCatalogView.swift             // "Train-Dex" Sammel-Katalog mit Trading Cards & Suchfilter
│   ├── TrainDetailView.swift              // Detailliertes Baureihen-Datenblatt mit Multi-Bildergalerie
│   ├── SpottedHistoryView.swift           // Chronologisches Logbuch & MapKit-Kartenansicht
│   ├── StatsView.swift                    // Gamification-Dashboard, Level, XP & Seltenster Fund
│   ├── SettingsView.swift                 // Datenschutz (DSGVO), Datenverwaltung & Urheber-Sheet
│   └── Components/
│       ├── RarityBadgeView.swift          // Seltenheits-Badges mit Glow & Animation
│       └── TrainImageView.swift           // Native Bildkomponente mit Skeleton & Silhouette
└── scripts/
    ├── download_train_images.py           // Asset-Download & Vorbereitung
    └── generate_project.py                // Xcode-Projekt-Generator
```

---

## 🚀 Schnellstart in Xcode

### Voraussetzungen
- macOS 14 Sonoma oder neuer
- Xcode 15.0+ (oder Xcode 16+)
- iOS 17.0+ Simulator oder echtes iOS-Gerät

### Installation & Ausführung
1. Repository klonen:
   ```bash
   git clone https://github.com/Amon-n/TrainSammler.git
   cd TrainSammler
   ```
2. Projekt in Xcode öffnen:
   ```bash
   open trainSammler.xcodeproj
   ```
3. Wähle oben im Ziel-Menü ein beliebiges iOS-Gerät (z. B. **iPhone 16 Pro**) und drücke **`Cmd + R`** zum Starten.

### Über die Befehlszeile kompilieren
```bash
xcodebuild -scheme trainSammler -destination 'generic/platform=iOS' build
```

---

## 🛡️ Datenschutz & App Store Readiness

`TrainSammler` erfüllt alle aktuellen Richtlinien für den Apple App Store:
- **DSGVO / GDPR konform:** Keine Datenübertragung, keine Analysetools, keine externen Server.
- **Apple Review Guideline 5.1.1:** Transparente Datenschutzerklärung direkt in der App ([SettingsView.swift](Views/SettingsView.swift)).
- **Vollständige Nutzerkontrolle:** Individuelles Löschen per Swipe im Logbuch sowie Option zum vollständigen Zurücksetzen in den Einstellungen.
- **Native Berechtigungen:** Alle Nutzungstexte für Kamera, Fotos und Standort sind in [Info.plist](Info.plist) hinterlegt.
- **Dynamische Versionierung:** Versions- und Build-Nummern werden dynamisch aus `CFBundleShortVersionString` und `CFBundleVersion` bezogen.

---

## 📷 Bildnachweise (Creative Commons)

Die im Baureihen-Katalog verwendeten Zuginformationen und Fotos stammen von engagierten Eisenbahn-Fotografen auf **Wikimedia Commons** und stehen unter freien Creative-Commons-Lizenzen (CC BY-SA 4.0 / 3.0 / 2.0 / CC0). 
Eine vollständige Liste aller 42 Bildnachweise und Lizenzen findest du in [ATTRIBUTION.md](ATTRIBUTION.md) sowie direkt in den Einstellungen der App.

---

## 📄 Lizenz

Dieses Projekt ist unter der **MIT-Lizenz** lizenziert. Siehe [LICENSE](LICENSE) für Details.
