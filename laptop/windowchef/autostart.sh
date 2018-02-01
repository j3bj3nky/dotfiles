#!/bin/sh
# autostart for windowchef

windowchef
sxkhd &
lemonbar -p &
i3status --config ~/.config/status-windowchef.conf
compton --config ${HOME}/.config/compton/compton.conf -b
exec feh --bg-scale ${HOME}/Pics/cybergamebak.jpg &
