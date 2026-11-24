# 🚆 TrainSammler

[![iOS 17+](https://img.shields.io/badge/iOS-17.0%2B-blue?logo=apple&style=flat-square)](https://developer.apple.com/ios/)
[![Swift 5.9+](https://img.shields.io/badge/Swift-5.9%2B-orange?logo=swift&style=flat-square)](https://swift.org/)
[![SwiftUI](https://img.shields.io/badge/UI-SwiftUI-purple?style=flat-square)](https://developer.apple.com/xcode/swiftui/)
[![SwiftData](https://img.shields.io/badge/Storage-SwiftData-green?style=flat-square)](https://developer.apple.com/documentation/swiftdata)
[![Version](https://img.shields.io/badge/Version-1.9-teal?style=flat-square)](Info.plist)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](LICENSE)

Das „Autokennzeichen-Sammeln“ für den Bahnverkehr in Deutschland! **TrainSammler** ist eine native, moderne und gamifizierte iOS-App zum Spotten von DB-Zügen, ICE-Baureihen, Regionalverkehr-Triebzügen, Triebzugnummern (Tz), seltenen Sonderzügen (wie dem Regenbogen- oder Europa-ICE) – inklusive interaktivem **DB-Bingo** für unterwegs.

---

## ✨ Features

- ⚡ **Schnell-Sichtung am Bahnsteig:** Dynamische 1-Tap-Schnellauswahl (deine zuletzt gesichteten Baureihen + Klassiker), automatischer GPS-Standort-Stamp via CoreLocation (oder manuelle Eingabe im Tiefbahnhof), **Live-Kamera & Mediathek** mit automatischer Bildkomprimierung sowie optimierter Einhand-Bedienung.
- 🎲 **DB-Bingo mit Wahrscheinlichkeits-Engine:**
  - **155+ kuratierte Bahn-Momente:** Keine trivialen 100%-Selbstverständlichkeiten mehr, sondern echte Beobachtungen und unterhaltsame Bahn-Klassiker in 4 Stufen: *Alltag (65–90 %)*, *Häufig (35–60 %)*, *Gelegentlich (12–32 %)* und *Selten / Jackpot (< 10 %)*.
  - **Anti-Cluster-Mix & garantierte Highlights:** Jedes Spielfeld (3×3, 4×4, 5×5) erhält in beiden Modi (*Alltagsnah* & *Chaos-Mix*) einen ausgewogenen Mix mit garantierten High-Level-Highlights, die gleichmäßig über Zeilen und Spalten verteilt werden.
  - **Logbuch-Speicherung nur auf Wunsch:** Laufende Runden bleiben während der Fahrt erhalten, landen aber erst dann im Logbuch, wenn du aktiv *„Fahrt im Logbuch speichern“* wählst – inklusive Schutzabfrage vor versehentlichem Verwerfen beim Größenwechsel.
  - **Einzel-Feld-Tausch & Details:** Halte ein beliebiges Feld gedrückt, um Wahrscheinlichkeit und Kategorie zu sehen oder es gegen ein anderes Ereignis derselben Seltenheitsstufe auszutauschen.
  - **Visuelle Share-Cards:** Teile gewonnene Bingo-Karten und Zugsichtungen direkt als gerenderte Bild-Karte (`ImageRenderer`).
- 🗂️ **Train-Dex (34 Baureihen):** Vollständiger Katalog über Fernverkehr (ICE 1 bis ICE 3neo, ICE L, ICE T, IC 1/2, ÖBB Railjet, SBB Giruno, Siemens Vectron, Nightjet), Regionalverkehr (FLIRT, Talent 2, Desiro HC, Mireo, Twindexx, KISS, LINT, ET 423/425) sowie Test- und Sonderzüge (ICE S, advanced TrainLab, Regenbogen-ICE, Europa-ICE, BRD-ICE, Female ICE) inklusive **Triebzugnummern-Sammlung**.
- 📸 **Multi-Bildergalerie & Eigene Fotos:**
  - Wische interaktiv durch 70+ hochauflösende Perspektiven (Frontansicht, Seitenprofil, Streckenfahrt, Führerstand, Innenraum) inklusive Vollbild-Zoom.
  - Persönliche Beweisfotos deiner Sichtungen werden direkt in die Detail-Galerie und in dein Statistiken-Showcase integriert.
- 🔍 **Spotter-Guide & Erkennungsmerkmale:** Ausführliche Identifikationstipps pro Zug (Scheinwerferform, Frontnase, Stromabnehmer, Türanordnung) für zielsicheres Erkennen am Gleis.
- 🏆 **Gamification, Tz-Bonus & Meilensteine:** Bahn-XP aus Zugsichtungen (mit 2x First-Catch-Bonus, **+25 XP Triebzug-Sammlerbonus** für neue Tz-Nummern und **8 Meilensteinen**). Steige vom *Bahnsteig-Neuling* bis zur *ICE-Legende* auf.
- 📜 **Editierbares Logbuch & interaktive MapKit-Karte:** Durchsuchbares Logbuch für alle Zugsichtungen (mit nachträglicher Bearbeitung per Swipe/Kontextmenü und anklickbaren Karten-Pins) sowie alle gespeicherten DB-Bingo-Fahrten.
- 💾 **Lokales JSON-Backup & 100% Offline (DSGVO-konform):** Alle Daten, Notizen, Fotos und Standorte verbleiben ausschließlich lokal auf dem iPhone (SwiftData) und lassen sich optional als lokale JSON-Datei exportieren/wiederherstellen. Kein Tracking, keine Werbung, keine Benutzerkonten.

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
│   ├── DataSeeder.swift                   // Lokales Catalog-Seeding (34 Züge) & Bildmapping
│   ├── ImageCompressor.swift              // JPEG-Downsampling & ImageIO Thumbnail-Cache
│   └── BackupService.swift                // Lokaler JSON-Backup Export & Import
├── ViewModels/
│   ├── QuickSpotViewModel.swift           // Bahnsteig-Workflow, Tz-Bonus & Feedback
│   ├── BingoViewModel.swift               // Gewichtete Brett-Generierung & Option-A1-Logbuch
│   └── StatsViewModel.swift               // Gamification-Engine, Meilensteine & UserRank
├── Views/
│   ├── ContentView.swift                  // Root TabView Navigation (5 Tabs)
│   ├── QuickSpotView.swift                // High-Speed Bahnsteig-Erfassung mit Live-Kamera
│   ├── TrainCatalogView.swift             // "Train-Dex" Sammel-Katalog mit Filter & Sortierung
│   ├── TrainDetailView.swift              // Detailliertes Baureihen-Datenblatt mit Galerie
│   ├── DBBingoView.swift                  // Interaktives DB-Bingo mit optionaler Speicherung
│   ├── BingoHistorySheet.swift            // Wiederverwendbare Bingo-Logbuch-Komponente
│   ├── SpottedHistoryView.swift           // Editierbares Logbuch & interaktive MapKit-Karte
│   ├── PhotoPreviewSheet.swift            // Vollbild-Foto-Lightbox mit Pinch-to-Zoom & Share
│   ├── StatsView.swift                    // Gamification-Dashboard, Meilensteine & Bingo-Bilanz
│   ├── SettingsView.swift                 // Datenschutz (DSGVO), JSON-Backup & Bildnachweise
│   └── Components/
│       ├── RarityBadgeView.swift          // Seltenheits-Badges mit Glow & Animation
│       ├── TrainImageView.swift           // Native Bildkomponente mit Silhouette-Modus
│       ├── CameraPickerView.swift         // Native UIImagePickerController Live-Kamera
│       └── ShareCardRenderer.swift        // ImageRenderer-Karten für Bingo & Sichtungen
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
