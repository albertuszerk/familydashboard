#!/bin/bash
# Pfad: ~/.local/bin/family-dashboard-pilot.sh
export DISPLAY=:0
LOCKFILE="/tmp/x-pilot.lock"

if [ -f "$LOCKFILE" ]; then
    if ps -p $(cat "$LOCKFILE") > /dev/null; then
        notify-send "X-Pilot" "Es laeuft bereits eine Sitzung."
        exit 1
    fi
fi
echo $$ > "$LOCKFILE"
trap "rm -f $LOCKFILE" EXIT

while true; do
    WAHL=$(zenity --list --title="X-Family Pilot" --column="Aktion" \
    "Automatik STARTEN" "Automatik PAUSIEREN" "System NEUSTART" "Beenden")

    case $WAHL in
        "Automatik STARTEN") rm -f /tmp/dashboard_stop; notify-send "Dashboard" "Loop aktiv.";;
        "Automatik PAUSIEREN") touch /tmp/dashboard_stop; notify-send "Dashboard" "Loop gestoppt.";;
        "System NEUSTART") pkill -f family-dashboard.sh; sleep 1; bash ~/.local/bin/family-dashboard.sh &;;
        "Beenden"|*) exit 0;;
    esac
done
