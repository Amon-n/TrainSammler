import os
import sys
import json
import urllib.request
import urllib.parse
import subprocess
import time
import re

BROWSER_UA = "TrainSammlerApp/1.1 (https://github.com/Amon-n/TrainSammler; info@trainsammler.de)"

CURATED_IMAGES = [
    # 1. Sonder- & Erprobungszüge
    {
        "asset": "ice_605_trainlab",
        "file": "File:Das advanced TrainLab mit Sensorik am Endwagen.jpg",
        "train": "advanced TrainLab (BR 605)",
        "label": "advanced TrainLab (BR 605)",
        "feature": "Fahrendes Digitallabor mit Messsensorik, Kameras und Lidar am Triebkopf.",
        "category": "Sonderzüge & Erprobung"
    },
    {
        "asset": "ice_605_sensors",
        "file": "File:20230916.Advanced TrainLab.-011.jpg",
        "train": "advanced TrainLab (BR 605)",
        "label": "Messfahrt & Sensorik",
        "feature": "Ehemaliger ICE-TD Triebzug bei der Sensor-Erprobung mit 5G-Antennen auf freier Strecke.",
        "category": "Sonderzüge & Erprobung"
    },
    {
        "asset": "ice_regenbogen_detail",
        "file": "File:Regenbogen-ICE in Stuttgart.jpg",
        "train": "Regenbogen-ICE (Tz 304)",
        "label": "Regenbogen-Zierstreifen",
        "feature": "Der sechsfarbige Regenbogenstreifen als klares Zeichen für Toleranz und Vielfalt.",
        "category": "Sonderzüge & Erprobung"
    },
    {
        "asset": "ice_europa_detail",
        "file": "File:ICE \"Europa-Europe\" End 2.jpg",
        "train": "Europa-ICE (Tz 4601)",
        "label": "Europa-Sterne & Flagge",
        "feature": "Die europäischen Sterne und der blaue Kontraststreifen am Triebkopf von Tz 4601.",
        "category": "Sonderzüge & Erprobung"
    },
    {
        "asset": "ice_female_cab",
        "file": "File:Female ICE driving end.jpg",
        "train": "Female ICE (Tz 9015)",
        "label": "Female ICE Triebkopf",
        "feature": "Triebkopf Tz 9015 Mainz mit der auffälligen Female-ICE-Symbolbeklebung.",
        "category": "Sonderzüge & Erprobung"
    },
    {
        "asset": "ice_female_restaurant",
        "file": "File:Female ICE Bordrestaurant.jpg",
        "train": "Female ICE (Tz 9015)",
        "label": "Bordrestaurant Tz 9015",
        "feature": "Speisewagen mit besonderem Aktionsdesign an den Außenwänden.",
        "category": "Sonderzüge & Erprobung"
    },
    {
        "asset": "ice_s_run",
        "file": "File:ICE S Geisbergtunnel.jpg",
        "train": "ICE S (BR 410)",
        "label": "Messfahrt bei 300+ km/h",
        "feature": "Erprobungszug der DB Systemtechnik bei einer Hochgeschwindigkeits-Testfahrt auf der Schnellfahrstrecke.",
        "category": "Sonderzüge & Erprobung"
    },

    # 2. Fernverkehr / ICE Flotte
    {
        "asset": "ice_1_powerhead",
        "file": "File:Triebkopf ICE 1 (4872423367).jpg",
        "train": "ICE 1 (BR 401)",
        "label": "Klassischer Triebkopf",
        "feature": "Charakteristische, geschwungene Nase des Triebkopfes 401 mit DB-Keks ohne Fronttüren.",
        "category": "ICE-Flotte (Fernverkehr)"
    },
    {
        "asset": "ice_1_restaurant",
        "file": "File:Deutsche Bahn ICE 2020 -DBAG Class 401 Speisewagen- by RaBoe00102.jpg",
        "train": "ICE 1 (BR 401)",
        "label": "Buckelspeisewagen",
        "feature": "Das unverkennbare Bordrestaurant mit erhöhtem Dach – das Wahrzeichen des ICE 1.",
        "category": "ICE-Flotte (Fernverkehr)"
    },
    {
        "asset": "ice_1_interior",
        "file": "File:ICE 1-Abteil zweiter Klasse nach zweitem Redesign.jpg",
        "train": "ICE 1 (BR 401)",
        "label": "Fahrgastabteil Redesign",
        "feature": "Modernisierter Fahrgastraum im Lebensdauerverlängerungs-Programm (LDV).",
        "category": "ICE-Flotte (Fernverkehr)"
    },
    {
        "asset": "ice_2_cab",
        "file": "File:J33 160 Bf Hannover Hbf, 808 003.jpg",
        "train": "ICE 2 (BR 402)",
        "label": "Steuerwagen 808",
        "feature": "Der Steuerwagen mit integriertem Führerstand und Fahrgastabteil für das Flügelungskonzept.",
        "category": "ICE-Flotte (Fernverkehr)"
    },
    {
        "asset": "ice_3_sfs",
        "file": "File:ICE 3 auf der Schnellfahrstrecke Köln - Rhein-Main bei Weilbach.jpg",
        "train": "ICE 3 (BR 403)",
        "label": "Schnellfahrstrecke 300 km/h",
        "feature": "Der Hochgeschwindigkeits-Klassiker mit 300 km/h auf der KRM-Neubaustrecke.",
        "category": "ICE-Flotte (Fernverkehr)"
    },
    {
        "asset": "ice_3_lounge",
        "file": "File:Lounge ICE 3.jpg",
        "train": "ICE 3 (BR 403 / 406)",
        "label": "Lounge mit Lokführerblick",
        "feature": "Einzigartiger Lounge-Blick durch die Panoramascheibe direkt auf die Strecke.",
        "category": "ICE-Flotte (Fernverkehr)"
    },
    {
        "asset": "ice_3m_multi",
        "file": "File:406 001 - DB Fernverkehr -- Eschweiler - 2. April 2014 (14304734175).jpg",
        "train": "ICE 3M (BR 406)",
        "label": "Mehrsystem-Dachausrüstung",
        "feature": "Vier verschiedene Dachstromabnehmer für Bahnstrom in Deutschland, Frankreich, Belgien und den Niederlanden.",
        "category": "ICE-Flotte (Fernverkehr)"
    },
    {
        "asset": "ice_407_interior",
        "file": "File:DBAG Class 407 interior 2nd 2014-01.jpg",
        "train": "ICE 3 (BR 407 Velaro D)",
        "label": "Velaro D Fahrgastraum",
        "feature": "Moderne 2. Klasse des Siemens Velaro D mit ergonomischen Sitzen und Deckenmonitoren.",
        "category": "ICE-Flotte (Fernverkehr)"
    },
    {
        "asset": "ice_3neo_interior",
        "file": "File:DBAG Class 408 Interior.jpg",
        "train": "ICE 3neo (BR 408)",
        "label": "Neues DB-Innendesign",
        "feature": "Neues Designkonzept der Deutschen Bahn mit Holztönen, warmen Stoffen und Tablet-Haltern.",
        "category": "ICE-Flotte (Fernverkehr)"
    },
    {
        "asset": "ice_4_front",
        "file": "File:ICE4 Front.jpg",
        "train": "ICE 4 (BR 412)",
        "label": "Kantige Frontpartie",
        "feature": "Die markante, kantig-aerodynamische Kopfform der Baureihe 412 mit LED-Lichtband.",
        "category": "ICE-Flotte (Fernverkehr)"
    },
    {
        "asset": "ice_4_interior",
        "file": "File:Augsburg Aug 2023 15 37 22 164000.jpeg",
        "train": "ICE 4 (BR 412)",
        "label": "ICE 4 Fahrgastbereich",
        "feature": "Großzügiger Fahrgastraum mit flexibler Sitzplatzanordnung und modernem Raumklima.",
        "category": "ICE-Flotte (Fernverkehr)"
    },
    {
        "asset": "ice_l_cab",
        "file": "File:ICE L SteuerwagenLV 12.23.jpg",
        "train": "ICE L (BR 105 Talgo 230)",
        "label": "ICE L Steuerwagen",
        "feature": "Modernster Steuerwagen von Talgo für den Wendezugbetrieb auf Urlaubsstrecken.",
        "category": "ICE-Flotte (Fernverkehr)"
    },
    {
        "asset": "ice_l_interior",
        "file": "File:Talgo 230 DB ICE-L at InnoTrans 2022 05.jpg",
        "train": "ICE L (BR 105 Talgo 230)",
        "label": "Stufenloser Niederflur-Einstieg",
        "feature": "Barrierefreier Fahrgastraum mit ebenem Boden ohne Stufen zwischen den Wagen.",
        "category": "ICE-Flotte (Fernverkehr)"
    },

    # 3. Intercity & Lokomotiven
    {
        "asset": "br_101_cab",
        "file": "File:DB AG 101 Führerstand.jpg",
        "train": "Intercity 1 (BR 101)",
        "label": "BR 101 Führerstand",
        "feature": "Echter Führertisch der Baureihe 101 mit Fahrschalter, Ebula-Display und MFA-Instrumenten.",
        "category": "Intercity & Lokomotiven"
    },
    {
        "asset": "ic2_twindexx_cab",
        "file": "File:J24 331 Schönefelder Gruppe, DBpbzfa 668.2.jpg",
        "train": "Intercity 2 (Twindexx)",
        "label": "Weißer IC2 Steuerwagen",
        "feature": "Weiß lackierter Doppelstock-Steuerwagen im ICE-Farbkleid mit spitzer Nase.",
        "category": "Intercity & Lokomotiven"
    },
    {
        "asset": "ic2_kiss_front",
        "file": "File:4110 110(2) Kiss.jpg",
        "train": "Intercity 2 (KISS)",
        "label": "Stadler KISS Front",
        "feature": "Kraftvoller Doppelstock-Triebkopf des Schweizer Herstellers Stadler im DB-Fernverkehr.",
        "category": "Intercity & Lokomotiven"
    },
    {
        "asset": "ic2_kiss_wien",
        "file": "File:2021-06-18 Stadler KISS BR 4110 at Wien Hauptbahnhof.jpg",
        "train": "Intercity 2 (KISS)",
        "label": "BR 4110 Doppelstockzug",
        "feature": "Spurtschneller 6-teiliger Doppelstock-Triebzug am Bahnsteig.",
        "category": "Intercity & Lokomotiven"
    },
    {
        "asset": "nightjet_viaggio",
        "file": "File:Siemens Viaggio Next Level ÖBB nightjet 2023-12 - 05.jpg",
        "train": "ÖBB Nightjet (Viaggio)",
        "label": "ÖBB Nightjet (Viaggio)",
        "feature": "Neuer Nachtzug der Zukunft im charakteristischen nachtblauen Siemens-Design.",
        "category": "Intercity & Lokomotiven"
    },
    {
        "asset": "nightjet_cab",
        "file": "File:Steuerwagen Siemens Viaggio Next Level ÖBB nightjet 2023-12 - 03.jpg",
        "train": "ÖBB Nightjet (Viaggio)",
        "label": "Nightjet Steuerwagen",
        "feature": "Aerodynamischer Steuerwagen für den schnellen Wendezugbetrieb bei 230 km/h.",
        "category": "Intercity & Lokomotiven"
    },
    {
        "asset": "nightjet_minicabin",
        "file": "File:Mini cabin coach of Siemens Viaggio Next Level ÖBB nightjet 2023-12 - 06.jpg",
        "train": "ÖBB Nightjet (Viaggio)",
        "label": "Mini-Cabin Schlafkapseln",
        "feature": "Die revolutionären Mini-Cabins für ungestörten Schlaf von Alleinreisenden im Nachtzug.",
        "category": "Intercity & Lokomotiven"
    },

    # 4. Regionalverkehr & S-Bahn
    {
        "asset": "desiro_hc_hybrid",
        "file": "File:J33 779 Desiro HC (462 083).jpg",
        "train": "Siemens Desiro HC",
        "label": "Hybrid-Wagenzug (Dosto & Flach)",
        "feature": "Übergang vom einstöckigen Endwagen zum doppelstöckigen Mittelwagen – die Besonderheit des Desiro HC.",
        "category": "Regionalverkehr & S-Bahn"
    },
    {
        "asset": "desiro_hc_interior",
        "file": "File:RRX 2.Klasse.jpg",
        "train": "Siemens Desiro HC",
        "label": "RRX Fahrgastraum",
        "feature": "Moderner Rhein-Ruhr-Express Innenraum mit Steckdosen, Monitoren und Leselampen.",
        "category": "Regionalverkehr & S-Bahn"
    },
    {
        "asset": "talent_2_front",
        "file": "File:Talent, Stralsund (LRM 20240104 140825).jpg",
        "train": "Talent 2 (BR 442)",
        "label": "Charakteristische Hamsterbacke",
        "feature": "Die prägnante, tiefgezogene Kopfform, die dem Bombardier Talent 2 seinen Kult-Kosenamen gab.",
        "category": "Regionalverkehr & S-Bahn"
    },
    {
        "asset": "talent_2_interior",
        "file": "File:I11 333 Bombardier Talent 2, Innenraum.jpg",
        "train": "Talent 2 (BR 442)",
        "label": "Fahrgastraum & Niederflur",
        "feature": "Niederfluriger Einstiegsbereich mit Jakobs-Drehgestellübergang und bequemen Sitzen.",
        "category": "Regionalverkehr & S-Bahn"
    },
    {
        "asset": "flirt_3_front",
        "file": "File:Süwex Flirt Mannheim Hbf.JPG",
        "train": "Stadler FLIRT 3",
        "label": "FLIRT 3 Frontpartie",
        "feature": "Markante, kantige Stadler-FLIRT-Kopfform im schnittigen SÜWEX-Design mit LED-Leuchten.",
        "category": "Regionalverkehr & S-Bahn"
    },
    {
        "asset": "flirt_3_interior",
        "file": "File:Fahrgastraum eines Stadler FLIRT 3 XL der NWB (2024).jpg",
        "train": "Stadler FLIRT 3",
        "label": "Großraum-Fahrgastabteil",
        "feature": "Heller, stufenloser Innenraum mit Jakobs-Gelenken und Panoramaverglasung.",
        "category": "Regionalverkehr & S-Bahn"
    },
    {
        "asset": "mireo_front",
        "file": "File:Mireo Bwegt - Offenburg.jpg",
        "train": "Siemens Mireo",
        "label": "Mireo Aerodynamik-Front",
        "feature": "Energieeffiziente, windschnittige Kopfform der Siemens-Mireo-Familie im bwegt-Design.",
        "category": "Regionalverkehr & S-Bahn"
    },
    {
        "asset": "mireo_interior",
        "file": "File:FahrgastraumMireoNetz4.jpg",
        "train": "Siemens Mireo",
        "label": "Mireo Fahrgastraum",
        "feature": "Großzügiges Leichtbau-Fahrgastabteil mit moderner LED-Ambientebeleuchtung.",
        "category": "Regionalverkehr & S-Bahn"
    },
    {
        "asset": "twindexx_regio_cab",
        "file": "File:Twindexx 445 013 Nortorf.jpg",
        "train": "Twindexx Vario",
        "label": "Twindexx Vario Triebwagen",
        "feature": "Angetriebener Doppelstock-Endwagen (BR 445) mit vollwertigem Antrieb unter den Drehgestellen.",
        "category": "Regionalverkehr & S-Bahn"
    },
    {
        "asset": "coradia_continental",
        "file": "File:DB-Baureihe 1440-Alstom Coradia Continental in Hagen Hbf.jpg",
        "train": "Coradia Continental (BR 1440)",
        "label": "Coradia Continental (BR 1440)",
        "feature": "Elektrischer Triebzug mit dem markanten, freundlichen Frontlächeln („Grinsekatze“).",
        "category": "Regionalverkehr & S-Bahn"
    },
    {
        "asset": "coradia_continental_front",
        "file": "File:Alstom Coradia Continental (1440) am Bw Aachen.jpg",
        "train": "Coradia Continental (BR 1440)",
        "label": "Grinsekatze Frontpartie",
        "feature": "Geschwungene Scheinwerfermaske und aerodynamische Kopfform der Baureihe 1440.",
        "category": "Regionalverkehr & S-Bahn"
    },
    {
        "asset": "coradia_lint_front",
        "file": "File:DB Regio 623 505 Alstom Coradia LINT Weinheim.jpg",
        "train": "Coradia LINT (BR 622 / 648)",
        "label": "LINT Triebwagen-Front",
        "feature": "Charakteristische Nahverkehrs-Diesel-Front mit hochgesetzter Scheibe und Scharfenbergkupplung.",
        "category": "Regionalverkehr & S-Bahn"
    },
    {
        "asset": "coradia_lint_interior",
        "file": "File:Innenraum eines modernisierten LNVG Lint 41.JPG",
        "train": "Coradia LINT (BR 622 / 648)",
        "label": "LINT 41 Innenraum",
        "feature": "Moderner Regional-Fahrgastraum für Nebenstrecken mit großflächigen Fenstern.",
        "category": "Regionalverkehr & S-Bahn"
    },
    {
        "asset": "et_423_front",
        "file": "File:Mainz-Kastel- Bahnhof- auf Brücke der Bundesstraße 40- Richtung Frankfurt am Main- DBAG-Baureihe 423 873-9 4.6.2010.jpg",
        "train": "S-Bahn ET 423",
        "label": "S-Bahn Frontpartie",
        "feature": "Kompakte, abgerundete Kopfform mit Zielanzeige für schnellen Fahrgastwechsel im S-Bahn-Netz.",
        "category": "Regionalverkehr & S-Bahn"
    },
    {
        "asset": "et_423_interior",
        "file": "File:S-Bahn München, Klasse 423, Waggon 2. Klasse, innen — 2005.jpg",
        "train": "S-Bahn ET 423",
        "label": "S-Bahn Großraumwagen",
        "feature": "Durchgängiger Großraumtriebzug ohne Trenntüren mit Haltestangen für hohen Pendlerandrang.",
        "category": "Regionalverkehr & S-Bahn"
    },
    {
        "asset": "et_425_front",
        "file": "File:Bahnhof Weinheim - DB-Baureihe 425 - 425-818 - 2019-02-13 14-46-41.jpg",
        "train": "ET 425 (Quietschie)",
        "label": "ET 425 Front & Falttüren",
        "feature": "Flache, steile Frontpartie und zahlreiche Außenschwenktüren für schnelle Halte.",
        "category": "Regionalverkehr & S-Bahn"
    },
    {
        "asset": "et_425_interior",
        "file": "File:DBAG-Baureihe 425- Interieur.JPG",
        "train": "ET 425 (Quietschie)",
        "label": "ET 425 Innenraum",
        "feature": "Klassischer Regionalbahn-Innenraum mit Klappsitzen im Mehrzweckbereich.",
        "category": "Regionalverkehr & S-Bahn"
    }
]

def batch_get_metadata(file_titles):
    results = {}
    chunk_size = 20
    for i in range(0, len(file_titles), chunk_size):
        chunk = file_titles[i:i + chunk_size]
        pipe_str = "|".join(chunk)
        url = f"https://commons.wikimedia.org/w/api.php?action=query&titles={urllib.parse.quote(pipe_str)}&prop=imageinfo&iiprop=url|size|mime|extmetadata&iiurlwidth=1200&format=json"
        req = urllib.request.Request(url, headers={"User-Agent": BROWSER_UA})
        try:
            with urllib.request.urlopen(req, timeout=15) as r:
                d = json.loads(r.read().decode())
                pages = d.get("query", {}).get("pages", {})
                for _, page in pages.items():
                    title = page.get("title")
                    if not title or "imageinfo" not in page:
                        continue
                    info = page["imageinfo"][0]
                    meta = info.get("extmetadata", {})
                    artist = meta.get("Artist", {}).get("value", "Wikimedia Commons")
                    clean_artist = re.sub(r"<[^>]+>", "", artist).strip()
                    clean_artist = "".join(c for c in clean_artist if c.isprintable())
                    lic = meta.get("LicenseShortName", {}).get("value", "CC BY-SA")
                    thumb = info.get("thumburl") or info.get("url")
                    results[title] = {
                        "thumb": thumb,
                        "artist": clean_artist or "Wikimedia Commons",
                        "license": lic,
                        "file_page": f"https://commons.wikimedia.org/wiki/{urllib.parse.quote(title)}"
                    }
        except Exception as e:
            print(f"Error fetching chunk: {e}")
        time.sleep(1.0)
    return results

def download_file(url, target_path):
    cmd = ["curl", "-s", "-L", "-A", BROWSER_UA, url, "-o", target_path]
    subprocess.run(cmd, check=True)
    if os.path.exists(target_path) and os.path.getsize(target_path) > 10000:
        with open(target_path, "rb") as f:
            header = f.read(10)
            if b"<!DOCTYPE" in header or b"<html" in header:
                return False
        return True
    return False

def main():
    assets_dir = "Assets.xcassets"
    os.makedirs(assets_dir, exist_ok=True)
    
    titles = [x["file"] for x in CURATED_IMAGES]
    print(f"Lade Metadaten für {len(titles)} Dateien gebündelt von Wikimedia Commons...")
    meta_map = batch_get_metadata(titles)
    print(f"Erfolgreich {len(meta_map)} Metadatensätze empfangen.")
    
    results = []
    
    for idx, item in enumerate(CURATED_IMAGES, 1):
        asset = item["asset"]
        file_title = item["file"]
        meta = meta_map.get(file_title)
        if not meta:
            print(f"⚠️  Keine Metadaten für {file_title}")
            continue
            
        ext = ".jpg"
        img_filename = f"{asset}{ext}"
        img_dir = os.path.join(assets_dir, f"{asset}.imageset")
        os.makedirs(img_dir, exist_ok=True)
        target_path = os.path.join(img_dir, img_filename)
        
        print(f"[{idx}/{len(CURATED_IMAGES)}] Lade {asset} ({meta['artist']})...")
        if download_file(meta["thumb"], target_path):
            size_kb = os.path.getsize(target_path) // 1024
            print(f"  ✅ Gespeichert ({size_kb} KB)")
            
            # Contents.json
            contents_json = {
                "images": [
                    {
                        "filename": img_filename,
                        "idiom": "universal"
                    }
                ],
                "info": {
                    "author": "xcode",
                    "version": 1
                }
            }
            with open(os.path.join(img_dir, "Contents.json"), "w") as f:
                json.dump(contents_json, f, indent=2)
                
            results.append({
                "asset": asset,
                "file": file_title,
                "train": item["train"],
                "label": item["label"],
                "feature": item["feature"],
                "category": item["category"],
                "artist": meta["artist"],
                "license": meta["license"],
                "url": meta["file_page"]
            })
        else:
            print(f"  ❌ Download-Fehler bei {meta['thumb']}")
        time.sleep(0.5)
        
    with open("scripts/curated_metadata.json", "w") as f:
        json.dump(results, f, indent=2, ensure_ascii=False)
        
    print(f"\n🎉 Vorgang abgeschlossen! {len(results)}/{len(CURATED_IMAGES)} Bilder erfolgreich aufbereitet.")

if __name__ == "__main__":
    main()
