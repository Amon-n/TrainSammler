# 🚆 TrainSammler

[![iOS 17+](https://img.shields.io/badge/iOS-17.0%2B-blue?logo=apple&style=flat-square)](https://developer.apple.com/ios/)
[![Swift 5.9+](https://img.shields.io/badge/Swift-5.9%2B-orange?logo=swift&style=flat-square)](https://swift.org/)
[![SwiftUI](https://img.shields.io/badge/UI-SwiftUI-purple?style=flat-square)](https://developer.apple.com/xcode/swiftui/)
[![SwiftData](https://img.shields.io/badge/Storage-SwiftData-green?style=flat-square)](https://developer.apple.com/documentation/swiftdata)
[![Version](https://img.shields.io/badge/Version-1.7%20(Build%207)-teal?style=flat-square)](Info.plist)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](LICENSE)

Das „Autokennzeichen-Sammeln“ für den Bahnverkehr in Deutschland! **TrainSammler** ist eine native, moderne und gamifizierte iOS-App zum Spotten von DB-Zügen, ICE-Baureihen, Regionalverkehr-Triebzügen, Triebzugnummern (Tz), seltenen Sonderzügen (wie dem Regenbogen- oder Europa-ICE) – inklusive interaktivem **DB-Bingo** für unterwegs.

---

## ✨ Features

- ⚡ **Schnell-Sichtung am Bahnsteig:** 1-Tap-Schnellauswahl der häufigsten Alltags-Baureihen, automatischer GPS-Standort-Stamp via CoreLocation (oder manuelle Eingabe im Tiefbahnhof) und optimierte Einhand-Bedienung.
- 🎲 **DB-Bingo mit Wahrscheinlichkeits-Engine:**
  - Über **140+ abwechslungsreiche Bahn-Erlebnisse** in 4 realistischen Wahrscheinlichkeitsstufen: *Alltag (65–95 %)*, *Häufig (35–60 %)*, *Gelegentlich (12–32 %)* und *Selten (< 10 %)*.
  - **Alltagsnaher Algorithmus:** Faire Verteilung mit Fokus auf normale Vorfälle (z. B. +5 Min. Verspätung, Ticketkontrolle, Durchsagen, Alltag im Wagen), sodass keine unlösbaren Reihen entstehen.
  - **„Reise beenden & speichern“:** Schließe deine Zugfahrt jederzeit ab, vergib einen Reisenamen, sammle Bahn-XP für erlebte Vorfälle (+150 XP Bingo-Bonus) und speichere das Brett dauerhaft im Logbuch.
  - **Einzel-Feld-Tausch:** Halte ein beliebiges Feld gedrückt, um die genaue Wahrscheinlichkeit zu sehen oder ein einzelnes Feld auszutauschen.
- 🗂️ **Train-Dex (34 Baureihen):** Vollständiger Katalog über Fernverkehr (ICE 1 bis ICE 3neo, ICE L, ICE T, IC 1/2, ÖBB Railjet, SBB Giruno, Siemens Vectron, Nightjet), Regionalverkehr (FLIRT, Talent 2, Desiro HC, Mireo, Twindexx, KISS, LINT, ET 423/425) sowie Test- und Sonderzüge (ICE S, advanced TrainLab, Regenbogen-ICE, Europa-ICE, BRD-ICE, Female ICE).
- 📸 **Multi-Bildergalerie & Eigene Fotos:**
  - Wische interaktiv durch 70+ hochauflösende Perspektiven (Frontansicht, Seitenprofil, Streckenfahrt, Führerstand, Innenraum) inklusive Vollbild-Zoom.
  - Persönliche Beweisfotos deiner Sichtungen werden direkt in die Detail-Galerie des jeweiligen Zuges integriert.
- 🔍 **Spotter-Guide & Erkennungsmerkmale:** Ausführliche Identifikationstipps pro Zug (Scheinwerferform, Frontnase, Stromabnehmer, Türanordnung) für zielsicheres Erkennen am Gleis.
- 🏆 **Gamification & Rangsystem:** Bahn-XP aus Zugsichtungen (mit 2x First-Catch-Bonus für Erstfunde) und DB-Bingo-Runden. Steige vom *Bahnsteig-Neuling* bis zur *ICE-Legende* auf.
- 📜 **Vereintes Logbuch & MapKit-Karte:** Durchsuchbares Logbuch für alle Zugsichtungen (Liste & interaktive Karte) sowie alle abgeschlossenen DB-Bingo-Reisen.
- 🔒 **100% Offline & Privat (DSGVO-konform):** Alle Daten, Notizen, Fotos und Standorte verbleiben ausschließlich lokal auf dem iPhone (SwiftData). Kein Tracking, keine Werbung, keine Benutzerkonten.

---

## 🏗️ Architektur & Clean Code

Die App ist nach modernen Clean-Code-Prinzipien und strikter MVVM-Architektur aufgebaut:

- **SwiftUI + Observation:** Reaktives State-Management mit dem `@Observable`-Makro (iOS 17+) ohne veraltetes Combine/`ObservableObject`.
- **SwiftData:** Relationale Modellierung (`TrainModel` 1:N `SpottedTrain`, `BingoGame` 1:N `BingoCell`) mit kaskadierender Integrität und `@Attribute(.externalStorage)` für ressourcenschonende Fotoverwaltung.
- **CoreLocation Service:** Thread-sicherer `@MainActor`-isolierter `LocationManager` mit modernem `async/await` Reverse-Geocoding.
- **Typisierte Gamification-Engine:** Entkoppelte `StatsCalculator`-Domain-Logik, die Sichtungen und Bingo-Fahrten in `TrainStats`- und `UserRank`-Modelle überführt.

```
trainsammler/
├── App/
│   └── TrainSammlerApp.swift              // App-Lifecycle, ModelContainer & Pre-Seeding
├── Models/
│   ├── Enums.swift                        // RarityTier & TrainCategory
│   ├── TrainModel.swift                   // SwiftData Schema für Baureihen/Katalog
│   ├── TrainModel+Identification.swift    // Spotter-Guide, Galerie-Katalog & Lizenzen
│   ├── SpottedTrain.swift                 // SwiftData Schema für Sichtungen & Fotos
│   ├── BingoGame.swift                    // SwiftData Schema für Bingo-Runden & Felder
│   └── BingoItem.swift                    // Wahrscheinlichkeits-Stufen & Vorfalls-Katalog
├── Services/
│   ├── LocationManager.swift              // CoreLocation Service mit async Reverse-Geocoding
│   └── DataSeeder.swift                   // Lokales Catalog-Seeding (34 Züge) & Bildmapping
├── ViewModels/
│   ├── QuickSpotViewModel.swift           // Bahnsteig-Workflow, Validierung & Feedback
│   ├── BingoViewModel.swift               // Gewichtete Brett-Generierung & Reise-Speicherung
│   └── StatsViewModel.swift               // Gamification-Engine, TrainStats & UserRank
├── Views/
│   ├── ContentView.swift                  // Root TabView Navigation (5 Tabs)
│   ├── QuickSpotView.swift                // High-Speed Bahnsteig-Erfassung
│   ├── TrainCatalogView.swift             // "Train-Dex" Sammel-Katalog mit Filter & Sortierung
│   ├── TrainDetailView.swift              // Detailliertes Baureihen-Datenblatt mit Galerie
│   ├── DBBingoView.swift                  // Interaktives DB-Bingo mit „Reise beenden“-Workflow
│   ├── BingoHistorySheet.swift            // Archiv-Ansicht & Detail-Blatt für Bingo-Fahrten
│   ├── SpottedHistoryView.swift           // Vereintes Logbuch (Sichtungen, Karte & Bingo)
│   ├── PhotoPreviewSheet.swift            // Vollbild-Foto-Lightbox mit Pinch-to-Zoom
│   ├── StatsView.swift                    // Gamification-Dashboard, Level, XP & Bingo-Bilanz
│   ├── SettingsView.swift                 // Datenschutz (DSGVO), Datenverwaltung & Urheber-Sheet
│   └── Components/
│       ├── RarityBadgeView.swift          // Seltenheits-Badges mit Glow & Animation
│       └── TrainImageView.swift           // Native Bildkomponente mit Silhouette-Modus
└── scripts/
    ├── curate_train_images.py             // Wikimedia Commons Kuratierung & Metadaten
    ├── download_train_images.py           // Asset-Download & Vorbereitung
    ├── generate_curated_data.py           // Code-Generator für Fotokatalog
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
xcodebuild -scheme trainSammler -destination 'generic/platform=iOS Simulator' build
```

---

## 🛡️ Datenschutz & App Store Readiness

`TrainSammler` erfüllt alle aktuellen Richtlinien für den Apple App Store:
- **DSGVO / GDPR konform:** Keine Datenübertragung, keine Analysetools, keine externen Server. Vollständige Datenschutzerklärung siehe [PRIVACY.md](PRIVACY.md).
- **Apple Review Guideline 5.1.1:** Transparente Datenschutzerklärung direkt in der App ([SettingsView.swift](Views/SettingsView.swift)) sowie öffentlich unter [PRIVACY.md](PRIVACY.md).
- **Vollständige Nutzerkontrolle:** Individuelles Löschen per Swipe im Logbuch sowie Optionen zum Zurücksetzen von Sichtungen und Bingo-Historie in den Einstellungen.
- **Native Berechtigungen:** Alle Nutzungstexte für Kamera, Fotos und Standort sind in [Info.plist](Info.plist) hinterlegt.

---

## 📷 Bildnachweise (Creative Commons)

Die im Baureihen-Katalog verwendeten Zuginformationen und Fotos stammen von engagierten Eisenbahn-Fotografen auf **Wikimedia Commons** und stehen unter freien Creative-Commons-Lizenzen (CC BY-SA 4.0 / 3.0 / 2.0 / CC0). 
Eine vollständige Liste aller Bildnachweise und Lizenzen findest du in [ATTRIBUTION.md](ATTRIBUTION.md) sowie direkt in den Einstellungen der App.

---

## 📄 Lizenz

Dieses Projekt ist unter der **MIT-Lizenz** lizenziert. Siehe [LICENSE](LICENSE) für Details.
