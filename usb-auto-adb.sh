#!/bin/bash
# Pfad: ~/.local/bin/usb-auto-adb.sh
export DISPLAY=:0
LAST_DEVICE=""

while true; do
    # Filtert gezielt nach dem USB-Geraet (Geraete ohne Doppelpunkt/IP in der ID)
    DEVICE_READY=$(adb devices | grep -v "offline" | grep "device$" | grep -v ":" | head -n 1 | awk '{print $1}')
    USB_PHYSICAL=$(lsusb | grep -i -e "Xiaomi" -e "Samsung" | wc -l)
    
    if [ -n "$DEVICE_READY" ]; then
        if [ "$DEVICE_READY" != "$LAST_DEVICE" ]; then
            # NUTZT JETZT -s UM NUR DAS USB-GERAET ZU AKTIVIEREN
            OUTPUT=$(adb -s "$DEVICE_READY" tcpip 5555 2>&1)
            if [[ $OUTPUT == *"restarting in TCP mode"* ]]; then
                zenity --info --title="Handy-Aktivierung" --text="<b>Erfolg!</b>\nPort 5555 offen für $DEVICE_READY.\nKabel abziehen." --timeout=15 &
                LAST_DEVICE=$DEVICE_READY
            else
                zenity --error --title="Fehler" --text="ADB fehlgeschlagen: $OUTPUT" --timeout=15 &
                LAST_DEVICE=$DEVICE_READY 
            fi
        fi
    elif [ "$USB_PHYSICAL" -gt 0 ] && [ -z "$DEVICE_READY" ]; then
        if [ "NO_DEBUG" != "$LAST_DEVICE" ]; then
            zenity --error --title="Handy stumm" --text="USB-Debugging pruefen!" --timeout=15 &
            LAST_DEVICE="NO_DEBUG"
        fi
    else
        LAST_DEVICE=""
    fi
    sleep 5
done
