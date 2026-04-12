#!/bin/bash
# Pfad: ~/.local/bin/family-dashboard.sh
# Fokus: Mathematische Echtzeit-Erkennung | Park-Filter | 101-Regel
export DISPLAY=:0
CONFIG_FILE="$HOME/.local/bin/geraete.conf"
PIDFILE="/tmp/family-dashboard.pid"

# --- PID-MANAGEMENT (Verhindert Geister-Prozesse) [cite: 2026-01-11] ---
[ -f "$PIDFILE" ] && kill $(cat "$PIDFILE") 2>/dev/null
echo $$ > "$PIDFILE"

# --- INITIALISIERUNG ---
GLOBAL_INTERVAL=7
rm -f /tmp/dashboard_stop

# Globale Zustands-Speicher (starten im Portrait)
H1_STATE="PORTRAIT"
H2_STATE="PORTRAIT"

read_config() {
    H1_NAME=$(grep "Handy" "$CONFIG_FILE" | sed -n '1p' | cut -d';' -f2)
    H1_IP=$(grep "Handy" "$CONFIG_FILE" | sed -n '1p' | cut -d';' -f3)
    H2_NAME=$(grep "Handy" "$CONFIG_FILE" | sed -n '2p' | cut -d';' -f2)
    H2_IP=$(grep "Handy" "$CONFIG_FILE" | sed -n '2p' | cut -d';' -f3)
    L1_NAME=$(grep "Laptop" "$CONFIG_FILE" | sed -n '1p' | cut -d';' -f2)
}

# --- SMARTER CHECK (Ignoriert Park-Groesse 300x301) [cite: 2026-01-11] ---
update_orientation_state() {
    local NAME=$1
    local INFO=$(wmctrl -lG | grep -i "$NAME" | head -n 1)
    [ -z "$INFO" ] && return

    local W=$(echo "$INFO" | awk '{print $5}')
    local H=$(echo "$INFO" | awk '{print $6}')

    # Wenn das Fenster die Park-Groesse hat, ignorieren wir die Messung fuer den State
    if [ "$W" -eq 300 ] && [ "$H" -eq 301 ]; then
        return
    fi

    # Ansonsten: Deine Formel Breite / Hoehe >= 1
    if [ $((W / H)) -ge 1 ]; then
        [ "$NAME" == "$H1_NAME" ] && H1_STATE="LANDSCAPE" || H2_STATE="LANDSCAPE"
    else
        [ "$NAME" == "$H1_NAME" ] && H1_STATE="PORTRAIT" || H2_STATE="PORTRAIT"
    fi
    
    # Diagnose-Ausgabe fuer das Terminal
    echo "DIAGNOSE $NAME: B=$W / H=$H | State: $( [ "$NAME" == "$H1_NAME" ] && echo $H1_STATE || echo $H2_STATE )" >&2
}

park_window() {
    local WID=$(wmctrl -l | grep -i "$1" | awk '{print $1}' | tail -n 1)
    if [ -n "$WID" ]; then
        # Parken bei 300x301 (y=101 Regel konform) [cite: 2026-02-18]
        wmctrl -i -r "$WID" -e 0,$((100 + ($2 * 40))),$((150 + ($2 * 40))),300,301
        wmctrl -i -r "$WID" -b add,below
    fi
}

# --- SZENARIEN ---
run_szenario_1() {
    echo ">>> SCHALTE: Szene 1 (Laptop)"
    park_window "$H1_NAME" 0
    park_window "$H2_NAME" 1
    WIDL=$(wmctrl -l | grep -i "$L1_NAME" | awk '{print $1}' | tail -n 1)
    [ -n "$WIDL" ] && { wmctrl -i -r "$WIDL" -b remove,below; wmctrl -i -r "$WIDL" -e 0,6,101,1668,800; wmctrl -i -a "$WIDL"; }
}

run_szenario_5() {
    echo ">>> SCHALTE: Szene 5 (Portrait)"
    park_window "$L1_NAME" 2
    WIDV1=$(wmctrl -l | grep -i "$H1_NAME" | awk '{print $1}' | tail -n 1)
    WIDV2=$(wmctrl -l | grep -i "$H2_NAME" | awk '{print $1}' | tail -n 1)
    [ -n "$WIDV1" ] && { wmctrl -i -r "$WIDV1" -b remove,below; wmctrl -i -r "$WIDV1" -e 0,0,101,840,900; }
    [ -n "$WIDV2" ] && { wmctrl -i -r "$WIDV2" -b remove,below; wmctrl -i -r "$WIDV2" -e 0,840,101,840,900; }
}

run_szenario_10() {
    echo ">>> SCHALTE: Szene 10 (Mischansicht)"
    WIDL=$(wmctrl -l | grep -i "$L1_NAME" | awk '{print $1}' | tail -n 1)
    WIDV1=$(wmctrl -l | grep -i "$H1_NAME" | awk '{print $1}' | tail -n 1)
    WIDV2=$(wmctrl -l | grep -i "$H2_NAME" | awk '{print $1}' | tail -n 1)
    
    [ -n "$WIDL" ] && wmctrl -i -r "$WIDL" -e 0,0,101,1140,500
    
    # Sortierung: Das Landscape-Handy nach unten links [cite: 2026-02-18]
    if [ "$H1_STATE" == "LANDSCAPE" ]; then
        [ -n "$WIDV1" ] && { wmctrl -i -r "$WIDV1" -b remove,below; wmctrl -i -r "$WIDV1" -e 0,0,601,1140,400; }
        [ -n "$WIDV2" ] && { wmctrl -i -r "$WIDV2" -b remove,below; wmctrl -i -r "$WIDV2" -e 0,1140,101,540,900; }
    else
        [ -n "$WIDV2" ] && { wmctrl -i -r "$WIDV2" -b remove,below; wmctrl -i -r "$WIDV2" -e 0,0,601,1140,400; }
        [ -n "$WIDV1" ] && { wmctrl -i -r "$WIDV1" -b remove,below; wmctrl -i -r "$WIDV1" -e 0,1140,101,540,900; }
    fi
}

# --- HAUPTPROGRAMM ---
read_config
killall remmina scrcpy 2>/dev/null
sleep 2
remmina -c "$HOME/.local/share/remmina/laptop_vnc_${L1_NAME}_${L1_NAME}.remmina" &
scrcpy -s "$H1_IP:5555" --window-title "$H1_NAME" --max-size 1080 &
scrcpy -s "$H2_IP:5555" --window-title "$H2_NAME" --max-size 1080 &
sleep 10 

CYCLE=0
TIMER=0

while true; do
    if [ -f /tmp/dashboard_stop ]; then sleep 1; continue; fi
    
    # Echtzeit-Update der Orientierung (Sekundentakt) [cite: 2026-01-11]
    update_orientation_state "$H1_NAME"
    update_orientation_state "$H2_NAME"
    
    if [ "$TIMER" -ge "$GLOBAL_INTERVAL" ]; then
        if [ $((CYCLE % 2)) -eq 0 ]; then
            run_szenario_1
        else
            # Weiche: Wenn eines Landscape ist -> Szene 10 [cite: 2026-01-11]
            if [ "$H1_STATE" == "LANDSCAPE" ] || [ "$H2_STATE" == "LANDSCAPE" ]; then
                run_szenario_10
            else
                run_szenario_5
            fi
        fi
        TIMER=0
        (( CYCLE++ ))
    fi
    sleep 1
    (( TIMER++ ))
done
