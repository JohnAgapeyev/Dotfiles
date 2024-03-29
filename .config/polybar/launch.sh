#!/usr/bin/env sh
# Terminate already running bar instances
killall -q polybar
# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

#setup environment
export ETH=$(ip link | awk '{print $2}' | grep -Eo '^en[a-z0-9]*' | sort -h | head -n 1)
export WIRE=$(ip link | awk '{print $2}' | grep -Eo '^wl[a-z0-9]*' | sort -h | head -n 1)

# Launch polybar
for i in $(polybar -m | awk -F: '{print $1}');
do
    export MONITOR=$i
    polybar main -c ~/.config/polybar/config.ini &
done
