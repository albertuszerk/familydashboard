#!/bin/bash
# Pfad: ~/.local/bin/family-dashboard.sh
export DISPLAY=:0

# --- ADB INITIALISIERUNG & CHECK ---
init_adb_connections() {
    echo "Prüfe ADB-Verbindungen im VPN..."
    # Neustart des ADB-Servers zur Sicherheit
    adb kill-server && adb start-server
    sleep 2
    
    # Versuche aktive Verbindung zu erzwingen (IPs basierend auf deinem Setup)
    # Falls die IPs abweichen, bitte im Skript anpassen
    adb connect sms-rcvr1-mobile:5555
    adb connect namechef2-mobile-galaxy:5555
    sleep 2
}

# --- PARK-ALGORITHMUS (Kaskade) ---
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

# --- BASIS-LOGIK ---

run_szenario_1() {
    echo "Szenario 1: Laptop Fokus - Handys kaskadieren..."
    WID_L=$(wmctrl -l | grep -i "namechef2-laptop" | awk '{print $1}' | tail -n 1)
    WID_V1=$(wmctrl -l | grep -i "sms-rcvr1-mobile" | awk '{print $1}' | tail -n 1)
    WID_V2=$(wmctrl -l | grep -i "namechef2-mobile-galaxy" | awk '{print $1}' | tail -n 1)

    park_window "$WID_V1" 0
    park_window "$WID_V2" 1

    if [ -n "$WID_L" ]; then
        wmctrl -i -r "$WID_L" -b remove,below
        wmctrl -i -r "$WID_L" -e 0,6,101,1668,800
        wmctrl -i -a "$WID_L"
    fi
}

run_szenario_5() {
    echo "Szenario 5: Handy Fokus - Laptop kaskadiert..."
    WID_L=$(wmctrl -l | grep -i "namechef2-laptop" | awk '{print $1}' | tail -n 1)
    WID_V1=$(wmctrl -l | grep -i "sms-rcvr1-mobile" | awk '{print $1}' | tail -n 1)
    WID_V2=$(wmctrl -l | grep -i "namechef2-mobile-galaxy" | awk '{print $1}' | tail -n 1)

    park_window "$WID_L" 2

    # Rückkehr aus dem Parkplatz (y=101 Regel)
    if [ -n "$WID_V1" ]; then
        wmctrl -i -r "$WID_V1" -b remove,below
        wmctrl -i -r "$WID_V1" -e 0,0,101,840,1080
    fi
    if [ -n "$WID_V2" ]; then
        wmctrl -i -r "$WID_V2" -b remove,below
        wmctrl -i -r "$WID_V2" -e 0,840,101,840,1080
    fi
    [ -n "$WID_V1" ] && wmctrl -i -a "$WID_V1"
}

run_szenario_10() {
    echo "Baue Szenario 10 auf..."
    # 1. Laptop starten (Remmina Profil mit neuem Namen)
    remmina -c "$HOME/.local/share/remmina/laptop_vnc_namechef2-laptop_namechef2-laptop.remmina" &
    sleep 5
    
    # 2. Handys starten (mit ADB-Sicherheit)
    scrcpy -s sms-rcvr1-mobile:5555 --window-title "sms-rcvr1-mobile" --max-size 1080 &
    sleep 5
    scrcpy -s namechef2-mobile-galaxy:5555 --window-title "namechef2-mobile-galaxy" --max-size 1080 &
    sleep 5
    
    WIDL=$(wmctrl -l | grep -i "namechef2-laptop" | awk '{print $1}' | tail -n 1)
    WIDV=$(wmctrl -l | grep -i "sms-rcvr1-mobile" | awk '{print $1}' | tail -n 1)
    WIDH=$(wmctrl -l | grep -i "namechef2-mobile-galaxy" | awk '{print $1}' | tail -n 1)
    
    [ -n "$WIDL" ] && wmctrl -i -r "$WIDL" -e 0,0,0,1140,560
    [ -n "$WIDV" ] && wmctrl -i -r "$WIDV" -e 0,1140,0,540,1080
    [ -n "$WIDH" ] && wmctrl -i -r "$WIDH" -e 0,0,596,1140,416
    [ -n "$WIDL" ] && wmctrl -i -a "$WIDL"
}

# --- HAUPTABLAUF ---
killall remmina scrcpy 2>/dev/null
init_adb_connections # Erst ADB stabilisieren
sleep 2
run_szenario_10

while true; do
    INFO=$(wmctrl -lG | grep -i "namechef2-mobile-galaxy")
    if [ -n "$INFO" ]; then
        WIDTH=$(echo $INFO | awk '{print $5}')
        HEIGHT=$(echo $INFO | awk '{print $6}')
        if [ "$HEIGHT" -gt "$WIDTH" ]; then
            echo "Rotation erkannt! Starte 20s-Zyklus..."
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
