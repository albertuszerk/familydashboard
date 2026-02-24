# Das Digitale Familien-Cockpit
### Alle Bildschirme von Handys und Laptops sicher im Blick – auf einem Monitor.

Willkommen beim **familydashboard**! Dieses Projekt hilft Eltern dabei, die digitale Übersicht im Haushalt zu behalten. Es vereint die Bildschirme von bis zu 8 Handys und 8 Laptops auf einem zentralen Monitor, damit nichts im Verborgenen bleibt.

## 📋 Was dieses Cockpit für dich tut
* **Alles auf einem Blick:** Zeigt alle aktiven Geräte gleichzeitig in einer geordneten Ansicht an.
* **Automatische Ordnung:** Das System erkennt selbstständig, wie viele Geräte gerade an sind, und ordnet sie perfekt auf dem Schirm an (9 Basis-Szenarien).
* **Selbstheilung:** Behebt bekannte Netzwerkprobleme (wie das "WLAN-Fragezeichen" unter Zorin OS) automatisch im Hintergrund.
* **Privatsphäre:** Alle Daten bleiben in deinem eigenen Netzwerk (VPN) und gehen nicht über fremde Server.

## 🛠️ Was du brauchst
* **Zentraler PC:** Ein Rechner mit Zorin OS (unser Monitor-Zentrum).
* **Endgeräte:** Handys (Android) und Kinder-Laptops (Zorin OS).
* **Netzwerk:** Eine stabile VPN-Verbindung (z.B. MyFRITZ/DuckDNS), damit alles sicher bleibt.

## 🚀 Schnellanleitung (Installation)

### 1. System-Basis & Software-Installation
Installiere die Kern-Komponenten auf dem Zentral-PC (Zorin OS):
```
sudo apt update && sudo apt install -y scrcpy adb xtightvncviewer wmctrl tailscale remmina
```

### 2. Sicherheits-Infrastruktur (VPN & DynDNS)
* **Verbindung:** Ein Site-to-Site VPN koppelt die Router direkt, sodass ADB (5555) und VNC (5900) nur intern erreichbar sind.
* **Handy-Vorbereitung:** Wireless Debugging am Handy einschalten und einmalig per USB initialisieren: `adb tcpip 5555`.

### 3. Remote-Desktop: Das VNC-Setup
* **Auf Kinder-Laptops:** `sudo apt install x11vnc`, Passwort mit `vncpasswd` vergeben und Autostart einrichten: `x11vnc -forever -usepw -display :0`.
* **Auf dem Zentral-PC:** Anzeige via `Remmina` oder `xtightvncviewer`.

### 4. Startprogramme & Helfer (Autostart)
Um das Netzwerk-Fragezeichen in Zorin OS zu beheben, erstelle diesen Autostart-Eintrag:
```
cat < ~/.config/autostart/vpn-heiler.desktop
[Desktop Entry]
Type=Application
Name=VPN Auto-Heiler
Exec=bash -c "sleep 20 && nmcli connection down wg0; sleep 2 && nmcli connection up wg0"
X-GNOME-Autostart-enabled=true
EOF
```

## ⚖️ Die Goldenen Regeln des Systems
* **Die 101-Regel:** Fenster kehren aus dem Parkplatz immer auf die Position `y=101` zurueck, um die Systemleisten zu schuetzen.
* **Der Parkplatz:** Inaktive Fenster werden automatisch auf 300x300 verkleinert und gestapelt.
* **Krisenvorsorge:** Im BIOS ist "Restore on AC Power Loss" auf **[Power On]** gestellt, damit das System nach einem Stromausfall selbstaendig startet.
* **Der Service-Desk:** Technische Manipulation fuehrt zur Abgabe des Geraets in der physischen Schublade.

## 🖼️ Printscreens
Optische Uebersicht, wie das Dashboard die Geraete anordnet:

![Die 9 Basis Szenarien](./docs/images/aufteilung2.jpg)
*Bild 1: Uebersicht der 9 Basis-Szenarien und Zyklen.*

![Cockpit Ansicht 1](./docs/images/placeholder.png)
*Bild 2: Platzhalter fuer Live-Ansicht Laptop-Fokus.*

![Cockpit Ansicht 2](./docs/images/placeholder.png)
*Bild 3: Platzhalter fuer Handy-Monitoring.*

![Hardware Setup](./docs/images/placeholder.png)
*Bild 4: Platzhalter fuer das physische Monitor-Setup.*

![Service Desk](./docs/images/placeholder.png)
*Bild 5: Platzhalter fuer den Service-Desk (Schublade).*

![Netzwerk Struktur](./docs/images/placeholder.png)
*Bild 6: Platzhalter fuer das VPN-Verbindungsschema.*

---
*Projekt-Stand: Februar 2026 – Erstellt fuer maximale Stabilitaet und Familien-Frieden.*
