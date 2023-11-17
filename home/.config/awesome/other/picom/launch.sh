#!/bin/bash

pkill compfy
while pgrep -u $UID -x compfy >/dev/null; do sleep 0; done

case $1 in
--opacity)
	compfy --config $HOME/.config/awesome/other/picom/picom.conf -b &
	;;
--no-opacity)
	compfy --config $HOME/.config/awesome/other/picom/picom_no_opacity.conf -b &
	;;
esac
