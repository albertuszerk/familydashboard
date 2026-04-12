#!/bin/bash
# Pfad: ~/.local/bin/usb-auto-adb.sh
export DISPLAY=:0
CONFIG_FILE="$HOME/.local/bin/geraete.conf"
LAST_USB_DEVICE=""

# Hilfsfunktion fuer Benachrichtigungen (immer mit "ss") [cite: 2026-01-11, 2025-12-02]
notify_user() {
    zenity --$3 --title="$1" --text="$2" --timeout=10 &
}

while true; do
    # --- TEIL 1: AUTO-CONNECT VIA IP (VPN) ---
    if [ -f "$CONFIG_FILE" ]; then
        while IFS=';' read -r GTYP GNAME GIP; do
            [[ "$GTYP" =~ ^#.*$ || -z "$GTYP" ]] && continue
            
            # Nur Handies/Tablets via ADB verbinden
            if [[ "$GTYP" == "Handy" ]]; then
                if ! adb devices | grep -q "$GIP:5555"; then
                    if ping -c 1 -W 1 "$GIP" > /dev/null 2>&1; then
                        adb connect "$GIP:5555" > /dev/null 2>&1
                        notify_user "Dashboard" "Verbindung zu $GNAME aktiv." "info"
                    fi
                fi
            fi
        done < "$CONFIG_FILE"
    fi

    # --- TEIL 2: DIE USB-TANKSTELLE (INITIALISIERUNG) ---
    DEVICE_READY=$(adb devices | grep -v "offline" | grep "device$" | grep -v ":" | head -n 1 | awk '{print $1}')
    
    if [ -n "$DEVICE_READY" ]; then
        if [ "$DEVICE_READY" != "$LAST_USB_DEVICE" ]; then
            OUTPUT=$(adb -s "$DEVICE_READY" tcpip 5555 2>&1)
            if [[ $OUTPUT == *"restarting in TCP mode"* ]]; then
                notify_user "Tanksaeule" "Erfolg! Port 5555 offen.\nKabel fuer $DEVICE_READY abziehen." "info"
                LAST_USB_DEVICE=$DEVICE_READY
            else
                notify_user "Fehler" "ADB-Initialisierung fehlgeschlagen." "error"
                LAST_USB_DEVICE=$DEVICE_READY 
            fi
        fi
    else
        LAST_USB_DEVICE=""
    fi
    
    sleep 10
done
