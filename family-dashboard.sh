#!/bin/bash
# Pfad: ~/.local/bin/family-dashboard.sh
# Dieses Skript wurde fuer maximale Wartbarkeit angepasst.
export DISPLAY=:0
CONFIG_FILE="$HOME/.local/bin/geraete.conf"

# --- CONFIG-PARSER ---
# Wir lesen die echten Namen und IPs aus der geraete.conf
H1_NAME=$(grep "Handy" "$CONFIG_FILE" | sed -n '1p' | cut -d';' -f2)
H1_IP=$(grep "Handy" "$CONFIG_FILE" | sed -n '1p' | cut -d';' -f3)
H2_NAME=$(grep "Handy" "$CONFIG_FILE" | sed -n '2p' | cut -d';' -f2)
H2_IP=$(grep "Handy" "$CONFIG_FILE" | sed -n '2p' | cut -d';' -f3)
L1_NAME=$(grep "Laptop" "$CONFIG_FILE" | sed -n '1p' | cut -d';' -f2)

# --- ADB INITIALISIERUNG & CHECK ---
init_adb_connections() {
    echo "Pruefe ADB-Verbindungen im VPN fuer $H1_NAME und $H2_NAME..."
    adb kill-server && adb start-server
    sleep 2
    
    # Verbindungsaufbau basierend auf Config-IPs
    [ -n "$H1_IP" ] && adb connect "$H1_IP:5555"
    [ -n "$H2_IP" ] && adb connect "$H2_IP:5555"
    sleep 2
}

# --- PARK-ALGORITHMUS (Kaskade) ---
park_window() {
    local WID=$1
    local INDEX=$2
    if [[ -n "$WID" && "$WID" != "null" ]]; then
        # Parkplatz-Groesse: 300x300 [cite: 2026-02-18]
        local OFFSET_X=$((100 + (INDEX * 40)))
        local OFFSET_Y=$((150 + (INDEX * 40)))
        echo "Parke $WID auf Kaskaden-Position $INDEX..."
        wmctrl -i -r "$WID" -e 0,$OFFSET_X,$OFFSET_Y,300,300
        wmctrl -i -r "$WID" -b add,below
    fi
}

# --- SZENARIEN ---

run_szenario_1() {
    echo "Szenario 1: Laptop Fokus - Handies kaskadieren..."
    WID_L=$(wmctrl -l | grep -i "$L1_NAME" | awk '{print $1}' | tail -n 1)
    WID_V1=$(wmctrl -l | grep -i "$H1_NAME" | awk '{print $1}' | tail -n 1)
    WID_V2=$(wmctrl -l | grep -i "$H2_NAME" | awk '{print $1}' | tail -n 1)

    park_window "$WID_V1" 0
    park_window "$WID_V2" 1

    if [ -n "$WID_L" ]; then
        wmctrl -i -r "$WID_L" -b remove,below
        # 101-Regel fuer y-Achse angewendet [cite: 2026-02-18]
        wmctrl -i -r "$WID_L" -e 0,6,101,1668,800
        wmctrl -i -a "$WID_L"
    fi
}

run_szenario_5() {
    echo "Szenario 5: Handy Fokus - Laptop kaskadiert..."
    WID_L=$(wmctrl -l | grep -i "$L1_NAME" | awk '{print $1}' | tail -n 1)
    WID_V1=$(wmctrl -l | grep -i "$H1_NAME" | awk '{print $1}' | tail -n 1)
    WID_V2=$(wmctrl -l | grep -i "$H2_NAME" | awk '{print $1}' | tail -n 1)

    park_window "$WID_L" 2

    # Rueckkehr aus dem Parkplatz (101-Regel) [cite: 2026-02-18]
    if [ -n "$WID_V1" ]; then
        wmctrl -i -r "$WID_V1" -b remove,below
        wmctrl -i -r "$WID_V1" -e 0,0,101,840,900
    fi
    if [ -n "$WID_V2" ]; then
        wmctrl -i -r "$WID_V2" -b remove,below
        wmctrl -i -r "$WID_V2" -e 0,840,101,840,900
    fi
    [ -n "$WID_V1" ] && wmctrl -i -a "$WID_V1"
}

run_szenario_10() {
    echo "Baue Szenario 10 (Start-Layout) auf..."
    # 1. Laptop starten (Profilname dynamisch)
    remmina -c "$HOME/.local/share/remmina/laptop_vnc_${L1_NAME}_${L1_NAME}.remmina" &
    sleep 5
    
    # 2. Handies starten via IP
    scrcpy -s "$H1_IP:5555" --window-title "$H1_NAME" --max-size 1080 &
    sleep 5
    scrcpy -s "$H2_IP:5555" --window-title "$H2_NAME" --max-size 1080 &
    sleep 5
    
    WIDL=$(wmctrl -l | grep -i "$L1_NAME" | awk '{print $1}' | tail -n 1)
    WIDV=$(wmctrl -l | grep -i "$H1_NAME" | awk '{print $1}' | tail -n 1)
    WIDH=$(wmctrl -l | grep -i "$H2_NAME" | awk '{print $1}' | tail -n 1)
    
    # Layout unter Beruecksichtigung der Systemleiste (y=101) [cite: 2026-02-18]
    [ -n "$WIDL" ] && wmctrl -i -r "$WIDL" -e 0,0,101,1140,500
    [ -n "$WIDV" ] && wmctrl -i -r "$WIDV" -e 0,1140,101,540,900
    [ -n "$WIDH" ] && wmctrl -i -r "$WIDH" -e 0,0,601,1140,400
    [ -n "$WIDL" ] && wmctrl -i -a "$WIDL"
}

# --- HAUPTABLAUF ---
killall remmina scrcpy 2>/dev/null
init_adb_connections 
sleep 2
run_szenario_10

while true; do
    INFO=$(wmctrl -lG | grep -i "$H2_NAME")
    if [ -n "$INFO" ]; then
        WIDTH=$(echo $INFO | awk '{print $5}')
        HEIGHT=$(echo $INFO | awk '{print $6}')
        if [ "$HEIGHT" -gt "$WIDTH" ]; then
            echo "Rotation bei $H2_NAME erkannt! Starte 20s-Zyklus..."
            while true; do
                run_szenario_5
                sleep 20
                run_szenario_1
                sleep 20
            done
        fi
    fi
    sleep 2
done
