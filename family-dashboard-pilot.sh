#!/bin/bash
# Pfad: ~/.local/bin/family-dashboard-pilot.sh
export DISPLAY=:0
LOCKFILE="/tmp/x-pilot.lock"

if [ -f "$LOCKFILE" ] && ps -p $(cat "$LOCKFILE") > /dev/null; then exit 1; fi
echo $$ > "$LOCKFILE"
trap "rm -f $LOCKFILE" EXIT

while true; do
    WAHL=$(zenity --list --title="X-Family Pilot" --column="Aktion" \
    "Automatik STARTEN" "Automatik PAUSIEREN" "System NEUSTART" "Beenden")

    case $WAHL in
        "Automatik STARTEN") rm -f /tmp/dashboard_stop ;;
        "Automatik PAUSIEREN") touch /tmp/dashboard_stop ;;
        "System NEUSTART") 
            rm -f /tmp/dashboard_stop
            pkill -f family-dashboard.sh
            sleep 1
            bash ~/.local/bin/family-dashboard.sh &
            ;;
        "Beenden"|*) 
            pkill -f family-dashboard.sh
            killall scrcpy remmina 2>/dev/null
            rm -f /tmp/family-dashboard.pid
            exit 0 
            ;;
    esac
done
