# Datenschutzerklärung für TrainSammler (Privacy Policy)

**Stand:** Oktober 2026  
**Gültig für:** TrainSammler (iOS App)

Der Schutz deiner persönlichen Daten ist uns ein zentrales Anliegen. Die App **TrainSammler** wurde nach dem Prinzip der Datensparsamkeit („Privacy by Design“) entwickelt: **Wir erheben, verarbeiten, übertragen oder verkaufen zu keinem Zeitpunkt personenbezogene Daten an externe Server oder Dritte.**

---

### 1. Verantwortlicher
Verantwortlich für den Betrieb der App ist der Entwickler von TrainSammler:  
GitHub: [https://github.com/Amon-n/TrainSammler](https://github.com/Amon-n/TrainSammler)

---

### 2. Grundprinzip: 100% Lokale Datenspeicherung
Alle Eingaben, die du in TrainSammler vornimmst – einschließlich:
* gespotteter Züge und Baureihen,
* Triebzugnummern und persönlicher Notizen,
* aufgenommener oder ausgewählter Fotos,
* Datum und Uhrzeit von Sichtungen,
* gespielter DB-Bingo-Karten und abgekreuzter Felder,
* erreichter XP-Punkte und Statistiken –

**verbleiben ausnahmslos und ausschließlich lokal auf deinem Gerät.**  
Die Speicherung erfolgt über das iOS-eigene Framework **SwiftData** im geschützten Sandbox-Speicherbereich der App. Es existiert keine Datenbank auf externen Servern, keine Cloud-Synchronisation und kein Tracking.

---

### 3. Zugriffsberechtigungen auf dem Gerät

Zur Bereitstellung der Kernfunktionen fragt TrainSammler bei Bedarf nach folgenden iOS-Berechtigungen. Diese Zugriffe erfolgen ausschließlich nach deiner ausdrücklichen Zustimmung:

#### a) Standortzugriff (`NSLocationWhenInUseUsageDescription`)
* **Zweck:** Wenn du beim Anlegen einer Schnell-Sichtung auf das Standort-Feld tippst, wird mithilfe von `CoreLocation` dein aktueller Standort ermittelt, um den Namen des jeweiligen Bahnhofs oder die Koordinaten automatisch in das Sichtungs-Formular einzutragen.
* **Verarbeitung:** Der Standort wird auf dem Gerät via Apple Reverse-Geocoding in eine lesbare Ortsangabe umgewandelt. Zu keinem Zeitpunkt werden Bewegungsprofile erstellt oder Standorte an Dritte übermittelt.

#### b) Kamerazugriff (`NSCameraUsageDescription`)
* **Zweck:** Ermöglicht es dir, direkt am Bahnsteig ein Beweisfoto des gesichteten Zuges aufzunehmen und an die Sichtung anzuhängen.
* **Verarbeitung:** Das Foto wird ausschließlich lokal auf deinem Gerät in der internen App-Datenbank abgelegt.

#### c) Fotobibliotheks-Zugriff (`NSPhotoLibraryUsageDescription`)
* **Zweck:** Ermöglicht es dir, ein bereits zuvor aufgenommenes Zugs-Foto aus deinen Fotos auszuwählen und einer Sichtung zuzuordnen.
* **Verarbeitung:** Es werden ausschließlich die von dir aktiv ausgewählten Bilder importiert. Die App scannt oder liest deine restliche Fotobibliothek nicht aus.

---

### 4. Keine Benutzerkonten & Keine Registrierung
Für die Nutzung von TrainSammler ist weder eine Registrierung noch ein Login erforderlich. Es werden keine E-Mail-Adressen, Namen oder Passwörter erhoben.

---

### 5. Kein Tracking & Keine Werbedienste
* TrainSammler enthält **keine Werbe-Netzwerke** (wie z. B. Google AdMob).
* TrainSammler verwendet **keine Analyse- oder Tracking-Dienste** (wie z. B. Firebase, Facebook SDK, Google Analytics).
* Es findet kein Tracking deiner Aktivitäten über Apps oder Websites hinweg statt.

---

### 6. Löschung aller Daten
Du hast jederzeit die volle Kontrolle über deine Daten:
* Einzelne Sichtungen können im **Logbuch** per Wischgeste gelöscht werden.
* In den **Einstellungen** der App steht die Funktion *„Alle Sichtungen löschen“* zur Verfügung, die alle gesammelten Daten unwiderruflich von deinem Gerät entfernt.
* Durch das Löschen (Deinstallieren) der App von deinem iPhone werden sämtliche von der App gespeicherten Daten restlos gelöscht.

---

### 7. Bildrechte & Urheberrechte
Alle in der App mitgelieferten Zugs- und Modellfotos stammen aus Wikimedia Commons und unterliegen freien Creative-Commons-Lizenzen (CC BY / CC BY-SA / CC0). Vollständige Bildnachweise sind transparent in der App unter *Einstellungen → Open-Content Bildnachweise* sowie in der Datei `ATTRIBUTION.md` aufgeführt.

---

### 8. Kontakt & Fragen
Wenn du Fragen zu dieser Datenschutzerklärung oder zum Datenschutz in TrainSammler hast, kannst du jederzeit ein Issue im GitHub-Repository eröffnen:  
[https://github.com/Amon-n/TrainSammler/issues](https://github.com/Amon-n/TrainSammler/issues)
