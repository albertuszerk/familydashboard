# Pfad auf dem Laptop: ~/.local/bin/vnc-start.sh

#!/bin/bash
# 1. Alte Instanzen beenden [cite: 2026-02-18]
pkill x0vncserver
sleep 1

# 2. Start mit erweiterten Sicherheitseinstellungen und VPN-Freigabe [cite: 2026-02-18]
x0vncserver -display :0 -passwordfile ~/.vnc/passwd -localhost 0 -BlacklistThreshold 100 -BlacklistTimeout 0 &
