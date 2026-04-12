#!/bin/bash
# Pfad: ~/.local/bin/family-dashboard.sh
# Fokus: Fixer Test-Loop fuer Szenario 1 und 5
export DISPLAY=:0
CONFIG_FILE="$HOME/.local/bin/geraete.conf"

# --- CONFIG-PARSER (Namen und IPs aus geraete.conf laden) [cite: 2026-01-20] ---
H1_NAME=$(grep "Handy" "$CONFIG_FILE" | sed -n '1p' | cut -d';' -f2)
H1_IP=$(grep "Handy" "$CONFIG_FILE" | sed -n '1p' | cut -d';' -f3)
H2_NAME=$(grep "Handy" "$CONFIG_FILE" | sed -n '2p' | cut -d';' -f2)
H2_IP=$(grep "Handy" "$CONFIG_FILE" | sed -n '2p' | cut -d';' -f3)
L1_NAME=$(grep "Laptop" "$CONFIG_FILE" | sed -n '1p' | cut -d';' -f2)

# --- ADB INITIALISIERUNG ---
init_adb_connections() {
    echo "Verbindungen fuer $H1_NAME und $H2_NAME werden stabilisiert..."
    adb kill-server && adb start-server
    sleep 2
    [ -n "$H1_IP" ] && adb connect "$H1_IP:5555"
    [ -n "$H2_IP" ] && adb connect "$H2_IP:5555"
    sleep 2
}

# --- PARK-ALGORITHMUS (101-Regel & 300x300 Groesse) [cite: 2026-02-18] ---
park_window() {
    local WID=$1
    local INDEX=$2
    if [[ -n "$WID" && "$WID" != "null" ]]; then
        local OFFSET_X=$((100 + (INDEX * 40)))
        local OFFSET_Y=$((150 + (INDEX * 40)))
        echo "Parke $WID auf Kaskaden-Position $INDEX..."
        wmctrl -i -r "$WID" -e 0,$OFFSET_X,$OFFSET_Y,300,300
        wmctrl -i -r "$WID" -b add,below
    fi
}

# --- DIE TEST-SZENARIEN (Fixe Loops) ---

run_szenario_1() {
    echo "Szenario 1: Laptop Fokus (101-Regel aktiv) [cite: 2026-02-18]"
    WID_L=$(wmctrl -l | grep -i "$L1_NAME" | awk '{print $1}' | tail -n 1)
    WID_V1=$(wmctrl -l | grep -i "$H1_NAME" | awk '{print $1}' | tail -n 1)
    WID_V2=$(wmctrl -l | grep -i "$H2_NAME" | awk '{print $1}' | tail -n 1)

    park_window "$WID_V1" 0
    park_window "$WID_V2" 1

    if [ -n "$WID_L" ]; then
        wmctrl -i -r "$WID_L" -b remove,below
        # y=101 fuer freien Zugriff auf Systemleisten [cite: 2026-02-18]
        wmctrl -i -r "$WID_L" -e 0,6,101,1668,800
        wmctrl -i -a "$WID_L"
    fi
}

run_szenario_5() {
    echo "Szenario 5: Handies Fokus (101-Regel aktiv) [cite: 2026-02-18]"
    WID_L=$(wmctrl -l | grep -i "$L1_NAME" | awk '{print $1}' | tail -n 1)
    WID_V1=$(wmctrl -l | grep -i "$H1_NAME" | awk '{print $1}' | tail -n 1)
    WID_V2=$(wmctrl -l | grep -i "$H2_NAME" | awk '{print $1}' | tail -n 1)

    park_window "$WID_L" 2

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
    echo "Szenario 10: Initialer Aufbau unter y=101 [cite: 2026-02-18]"
    remmina -c "$HOME/.local/share/remmina/laptop_vnc_${L1_NAME}_${L1_NAME}.remmina" &
    sleep 5
    scrcpy -s "$H1_IP:5555" --window-title "$H1_NAME" --max-size 1080 &
    sleep 3
    scrcpy -s "$H2_IP:5555" --window-title "$H2_NAME" --max-size 1080 &
    sleep 5
    
    WIDL=$(wmctrl -l | grep -i "$L1_NAME" | awk '{print $1}' | tail -n 1)
    WIDV=$(wmctrl -l | grep -i "$H1_NAME" | awk '{print $1}' | tail -n 1)
    WIDH=$(wmctrl -l | grep -i "$H2_NAME" | awk '{print $1}' | tail -n 1)
    
    [ -n "$WIDL" ] && wmctrl -i -r "$WIDL" -e 0,0,101,1140,500
    [ -n "$WIDV" ] && wmctrl -i -r "$WIDV" -e 0,1140,101,540,900
    [ -n "$WIDH" ] && wmctrl -i -r "$WIDH" -e 0,0,601,1140,400
}

# --- HAUPTPROGRAMM (FIXER TEST-LOOP) ---
killall remmina scrcpy 2>/dev/null
init_adb_connections 
sleep 2
run_szenario_10
sleep 5

echo "Start des fixen Test-Loops (1-5-1-5...)"
while true; do
    # Kontroll-Check fuer den X-Pilot (Stop/Start)
    if [ -f /tmp/dashboard_stop ]; then
        sleep 5
        continue
    fi

    run_szenario_5
    sleep 20
    
    [ -f /tmp/dashboard_stop ] && continue

    run_szenario_1
    sleep 20

    # HINWEIS: Die Rotations-Logik (wmctrl -lG) ist fuer spaeter reserviert.
done
