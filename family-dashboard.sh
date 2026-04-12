#!/bin/bash
# Pfad: ~/.local/bin/family-dashboard.sh
# Fokus: Globale Taktung & Echtzeit-Reaktion auf Rotation
export DISPLAY=:0
CONFIG_FILE="$HOME/.local/bin/geraete.conf"

# --- ZENTRALE EINSTELLUNGEN ---
GLOBAL_INTERVAL=10  # Sekunden pro Szene (global fuer alle Wechsel)

# --- CONFIG-PARSER (Namen und IPs laden) [cite: 2026-01-20] ---
read_config() {
    H1_NAME=$(grep "Handy" "$CONFIG_FILE" | sed -n '1p' | cut -d';' -f2)
    H1_IP=$(grep "Handy" "$CONFIG_FILE" | sed -n '1p' | cut -d';' -f3)
    H2_NAME=$(grep "Handy" "$CONFIG_FILE" | sed -n '2p' | cut -d';' -f2)
    H2_IP=$(grep "Handy" "$CONFIG_FILE" | sed -n '2p' | cut -d';' -f3)
    L1_NAME=$(grep "Laptop" "$CONFIG_FILE" | sed -n '1p' | cut -d';' -f2)
}

# --- ORIENTIERUNGS-CHECK (Echtzeit-Erkennung) [cite: 2026-01-11] ---
get_orientation() {
    local NAME=$1
    local INFO=$(wmctrl -lG | grep -i "$NAME" | head -n 1)
    [ -z "$INFO" ] && { echo "UNKNOWN"; return; }
    local W=$(echo $INFO | awk '{print $5}')
    local H=$(echo $INFO | awk '{print $6}')
    [ "$W" -gt "$H" ] && echo "LANDSCAPE" || echo "PORTRAIT"
}

# --- PARK-ALGORITHMUS (101-Regel konform) [cite: 2026-02-18] ---
park_window() {
    local WID=$1
    local INDEX=$2
    if [[ -n "$WID" && "$WID" != "null" ]]; then
        local OX=$((100 + (INDEX * 40)))
        local OY=$((150 + (INDEX * 40)))
        wmctrl -i -r "$WID" -e 0,$OX,$OY,300,300
        wmctrl -i -r "$WID" -b add,below
    fi
}

# --- SZENARIEN (Basierend auf Grafik aufteilung2.jpg) [cite: 2026-02-18] ---

run_szenario_1() {
    echo "Szenario 1: Laptop Vollbild-Fokus"
    WID_L=$(wmctrl -l | grep -i "$L1_NAME" | awk '{print $1}' | tail -n 1)
    WID_V1=$(wmctrl -l | grep -i "$H1_NAME" | awk '{print $1}' | tail -n 1)
    WID_V2=$(wmctrl -l | grep -i "$H2_NAME" | awk '{print $1}' | tail -n 1)
    park_window "$WID_V1" 0
    park_window "$WID_V2" 1
    [ -n "$WID_L" ] && { wmctrl -i -r "$WID_L" -b remove,below; wmctrl -i -r "$WID_L" -e 0,6,101,1668,800; wmctrl -i -a "$WID_L"; }
}

run_szenario_5() {
    echo "Szenario 5: Handies Fokus (Hochformat)"
    WID_L=$(wmctrl -l | grep -i "$L1_NAME" | awk '{print $1}' | tail -n 1)
    WID_V1=$(wmctrl -l | grep -i "$H1_NAME" | awk '{print $1}' | tail -n 1)
    WID_V2=$(wmctrl -l | grep -i "$H2_NAME" | awk '{print $1}' | tail -n 1)
    park_window "$WID_L" 2
    [ -n "$WID_V1" ] && { wmctrl -i -r "$WID_V1" -b remove,below; wmctrl -i -r "$WID_V1" -e 0,0,101,840,900; }
    [ -n "$WID_V2" ] && { wmctrl -i -r "$WID_V2" -b remove,below; wmctrl -i -r "$WID_V2" -e 0,840,101,840,900; }
}

run_szenario_10() {
    echo "Szenario 10: Mischansicht (Eines quer unten)"
    WIDL=$(wmctrl -l | grep -i "$L1_NAME" | awk '{print $1}' | tail -n 1)
    WIDV1=$(wmctrl -l | grep -i "$H1_NAME" | awk '{print $1}' | tail -n 1)
    WIDV2=$(wmctrl -l | grep -i "$H2_NAME" | awk '{print $1}' | tail -n 1)
    O1=$(get_orientation "$H1_NAME")
    # Laptop bleibt oben (y=101) [cite: 2026-02-18]
    [ -n "$WIDL" ] && wmctrl -i -r "$WIDL" -e 0,0,101,1140,500
    if [ "$O1" == "LANDSCAPE" ]; then
        [ -n "$WIDV1" ] && wmctrl -i -r "$WIDV1" -e 0,0,601,1140,400    # Quer-Handy unten
        [ -n "$WIDV2" ] && wmctrl -i -r "$WIDV2" -e 0,1140,101,540,900 # Hoch-Handy rechts
    else
        [ -n "$WIDV2" ] && wmctrl -i -r "$WIDV2" -e 0,0,601,1140,400    # Quer-Handy unten
        [ -n "$WIDV1" ] && wmctrl -i -r "$WIDV1" -e 0,1140,101,540,900 # Hoch-Handy rechts
    fi
}

# --- HAUPTPROGRAMM ---
read_config
killall remmina scrcpy 2>/dev/null
sleep 2

# Initialer Start der Fenster
remmina -c "$HOME/.local/share/remmina/laptop_vnc_${L1_NAME}_${L1_NAME}.remmina" &
scrcpy -s "$H1_IP:5555" --window-title "$H1_NAME" --max-size 1080 &
scrcpy -s "$H2_IP:5555" --window-title "$H2_NAME" --max-size 1080 &
sleep 8

LAST_STATE=""
TIMER=$GLOBAL_INTERVAL
CYCLE=0

while true; do
    # Pause via X-Pilot [cite: 2026-01-11]
    if [ -f /tmp/dashboard_stop ]; then sleep 2; continue; fi

    # Echtzeit-Check der Rotation (jede Sekunde) [cite: 2026-01-11]
    O1=$(get_orientation "$H1_NAME")
    O2=$(get_orientation "$H2_NAME")
    CURRENT_STATE="${O1}_${O2}"

    # SOFORT-REAKTION: Bei Drehung sofort Umschaltung erzwingen
    if [ "$CURRENT_STATE" != "$LAST_STATE" ]; then
        echo "Lagegeaenderung erkannt! Schalte Szenen sofort um."
        LAST_STATE=$CURRENT_STATE
        TIMER=$GLOBAL_INTERVAL # Setzt Timer auf Maximum fuer sofortigen Trigger
    fi

    # Szenenwechsel-Entscheidung
    if [ "$TIMER" -ge "$GLOBAL_INTERVAL" ]; then
        if [[ "$O1" == "LANDSCAPE" || "$O2" == "LANDSCAPE" ]]; then
            # Zyklus [1, 10]
            (( CYCLE++ ))
            [ $((CYCLE % 2)) -eq 0 ] && run_szenario_1 || run_szenario_10
        else
            # Zyklus [1, 5]
            (( CYCLE++ ))
            [ $((CYCLE % 2)) -eq 0 ] && run_szenario_1 || run_szenario_5
        fi
        TIMER=0
    fi

    sleep 1
    (( TIMER++ ))
done
