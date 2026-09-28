# trainSammler 🚆

Das native iOS-"Autokennzeichen-Sammeln" für den Bahnverkehr in Deutschland (Fokus DB & ICEs).

## Architektur-Übersicht

```
trainsammler/
├── App/
│   └── TrainSammlerApp.swift       // App-Entry & SwiftData ModelContainer Setup
├── Models/
│   ├── Enums.swift                 // RarityTier (Common, Uncommon, Rare, Legendary) & TrainCategory
│   ├── TrainModel.swift            // SwiftData Schema für Baureihen/Katalog
│   └── SpottedTrain.swift          // SwiftData Schema für individuelle Sichtungen
├── Services/
│   ├── LocationManager.swift       // CoreLocation GPS-Fix & CLGeocoder Reverse Geocoding
│   └── DataSeeder.swift            // Initialer Zug-Katalog (ICE 1 bis ICE 3neo, Sonderzüge)
├── ViewModels/
│   ├── QuickSpotViewModel.swift    // Schnelle Erfassung am Bahnsteig, Validierung, Haptics
│   └── StatsViewModel.swift        // Gamification-Engine, Score, First-Catch Boni, Progress
└── Views/
    ├── ContentView.swift           // Root TabView Navigation
    ├── QuickSpotView.swift         // Bahnsteig-optimierter Single-Tap Logging Workflow
    ├── TrainCatalogView.swift      // "Train-Dex" mit Filtern & Status (Entdeckt / Unentdeckt)
    ├── SpottedHistoryView.swift    // Chronologisches Logbuch mit Listen- und Kartenansicht (MapKit)
    ├── StatsView.swift             // Gamification-Dashboard, Rarest Catch & Rarity Grid
    └── Components/
        └── RarityBadgeView.swift   // Visuelle Differenzierung mit Farbcodes & Glow
```

## Erforderliche Berechtigungen (Info.plist)

Füge folgende Keys in das Xcode Target `Info.plist` ein:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>trainSammler benötigt deinen Standort, um den Bahnhof und die Koordinaten deiner Sichtung automatisch zu erfassen.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>trainSammler benötigt Zugriff auf deine Fotobibliothek, um Sichtungsfotos zuzuordnen.</string>
<key>NSCameraUsageDescription</key>
<string>trainSammler benötigt Zugriff auf die Kamera, um Züge am Bahnsteig direkt zu fotografieren.</string>
```
