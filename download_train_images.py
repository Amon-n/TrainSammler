import os
import sys
import json
import urllib.request
import urllib.parse
import subprocess

BROWSER_UA = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"

TRAIN_CONFIGS = [
    {
        "name": "ice_regenbogen",
        "search": "Regenbogen-ICE Tz 304",
        "alt_search": "Regenbogen-ICE"
    },
    {
        "name": "ice_europa",
        "search": "ICE Tz 4601 Europa",
        "alt_search": "DB Class 406 Europa"
    },
    {
        "name": "ice_s",
        "search": "ICE S 410",
        "alt_search": "ICE S DB Systemtechnik"
    },
    {
        "name": "ice_3neo",
        "search": "ICE 3neo DB 408",
        "alt_search": "DB Class 408"
    },
    {
        "name": "ice_t",
        "search": "DB Class 411 ICE-T",
        "alt_search": "ICE-T 411"
    },
    {
        "name": "ice_3_velaro",
        "search": "DBAG Class 407",
        "alt_search": "ICE 3 Velaro D"
    },
    {
        "name": "ice_1",
        "search": "DBAG Class 401 ICE 1",
        "alt_search": "ICE 1 DB 401"
    },
    {
        "name": "ice_2",
        "search": "DBAG Class 402 ICE 2",
        "alt_search": "ICE 2 DB 402"
    },
    {
        "name": "ice_4",
        "search": "DBAG Class 412",
        "alt_search": "ICE 4 DB 412"
    },
    {
        "name": "twindexx_vario",
        "search": "DBAG Class 445 Twindexx",
        "alt_search": "Twindexx Vario"
    }
]

def search_wikimedia(query):
    encoded_q = urllib.parse.quote(query)
    url = (
        f"https://commons.wikimedia.org/w/api.php?action=query&generator=search"
        f"&gsrsearch={encoded_q}&gsrnamespace=6&prop=imageinfo&iiprop=url|size|mime|extmetadata"
        f"&iiurlwidth=1200&format=json&gsrlimit=10"
    )
    req = urllib.request.Request(url, headers={"User-Agent": BROWSER_UA})
    try:
        with urllib.request.urlopen(req, timeout=15) as resp:
            data = json.loads(resp.read().decode("utf-8"))
            pages = data.get("query", {}).get("pages", {})
            for page_id, page in pages.items():
                title = page.get("title", "")
                lower = title.lower()
                if any(bad in lower for bad in ["interior", "innen", "wc", "bike", "toilette", "display", "diagram", "cockpit", "fuehrerstand"]):
                    continue
                imageinfo = page.get("imageinfo", [{}])[0]
                thumburl = imageinfo.get("thumburl") or imageinfo.get("url")
                if thumburl:
                    artist = imageinfo.get("extmetadata", {}).get("Artist", {}).get("value", "Wikimedia Commons")
                    license_name = imageinfo.get("extmetadata", {}).get("LicenseShortName", {}).get("value", "CC BY-SA")
                    return {
                        "url": thumburl,
                        "title": title,
                        "artist": artist,
                        "license": license_name
                    }
    except Exception as e:
        print(f"Fehler bei Suche {query}: {e}")
    return None

def download_and_verify(url, path):
    clean_url = url.split("?")[0]
    cmd = ["curl", "-s", "-L", "-A", BROWSER_UA, clean_url, "-o", path]
    subprocess.run(cmd, check=True)
    if os.path.exists(path) and os.path.getsize(path) > 10000:
        # Check that it is not HTML
        with open(path, "rb") as f:
            header = f.read(10)
            if b"<!DOCTYPE" in header or b"<html" in header:
                return False
        return True
    return False

def main():
    assets_dir = "Assets.xcassets"
    os.makedirs(assets_dir, exist_ok=True)
    
    credits = [
        "# Bildnachweise (Wikimedia Commons)",
        "",
        "Folgende Bilder werden in trainSammler unter Creative-Commons-Lizenzen (CC BY-SA / CC0) genutzt:",
        ""
    ]
    
    for cfg in TRAIN_CONFIGS:
        name = cfg["name"]
        print(f"\n🔍 Suche {name} ({cfg['search']})...")
        res = search_wikimedia(cfg["search"])
        if not res:
            res = search_wikimedia(cfg["alt_search"])
            
        if not res:
            print(f"❌ Kein passendes Bild für {name} gefunden.")
            continue
            
        ext = ".png" if ".png" in res["url"].lower() else ".jpg"
        img_name = f"{name}{ext}"
        
        target_dir = os.path.join(assets_dir, f"{name}.imageset")
        os.makedirs(target_dir, exist_ok=True)
        target_path = os.path.join(target_dir, img_name)
        
        print(f"⬇️  Lade {res['title']}...")
        if download_and_verify(res["url"], target_path):
            size_kb = os.path.getsize(target_path) // 1024
            print(f"✅ Erfolgreich: {name}.imageset ({size_kb} KB)")
            
            # Contents.json
            cj = {
                "images": [
                    {
                        "filename": img_name,
                        "idiom": "universal"
                    }
                ],
                "info": {
                    "author": "xcode",
                    "version": 1
                }
            }
            with open(os.path.join(target_dir, "Contents.json"), "w") as f:
                json.dump(cj, f, indent=2)
                
            clean_artist = res["artist"]
            if "<" in clean_artist:
                import re
                clean_artist = re.sub(r'<[^>]+>', '', clean_artist).strip()
            clean_artist = "".join(c for c in clean_artist if c.isprintable())
            credits.append(f"- **{name}**: [{res['title']}]({res['url']}) von *{clean_artist}* ({res['license']})")
        else:
            print(f"❌ Bild ungültig für {name}")
            
    with open("ATTRIBUTION.md", "w") as f:
        f.write("\n".join(credits) + "\n")
        
    print("\n🎉 Vorgang abgeschlossen!")

if __name__ == "__main__":
    main()
