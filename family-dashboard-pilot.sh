#!/bin/bash
# Pfad: ~/.local/bin/family-dashboard-pilot.sh
export DISPLAY=:0

while true; do
    WAHL=$(zenity --list --title="X-Family Pilot" --column="Aktion" \
    "Automatik STARTEN (Loop aktiv)" \
    "Automatik PAUSIEREN (Stop)" \
    "System NEUSTART (Reset)" \
    "Pilot Beenden")

    case $WAHL in
        "Automatik STARTEN (Loop aktiv)")
            rm -f /tmp/dashboard_stop
            notify-send "Dashboard" "Der automatische Wechsel wurde aktiviert."
            ;;
        "Automatik PAUSIEREN (Stop)")
            touch /tmp/dashboard_stop
            notify-send "Dashboard" "Pause! Die Fenster bleiben jetzt stehen."
            ;;
        "System NEUSTART (Reset)")
            pkill -f family-dashboard.sh
            sleep 1
            bash ~/.local/bin/family-dashboard.sh &
            notify-send "Dashboard" "Das System wird neu gestartet."
            ;;
        "Pilot Beenden"|*)
            exit 0
            ;;
    esac
done
