#!/usr/bin/env bash

# Terminate already running bar instances
killall polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch polybar
polybar center -c $HOME/.config/bspwm/polybar/config &
polybar left -c $HOME/.config/bspwm/polybar/config &
polybar right -c $HOME/.config/bspwm/polybar/config &
polybar tray -c $HOME/.config/bspwm/polybar/config &

if [[ $(xrandr -q | grep 'HDMI1 connected') ]]; then
	polybar external -c $(dirname $0)/config &
fi
