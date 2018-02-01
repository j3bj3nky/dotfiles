#!/bin/sh

# Hopefully will autostart programs for windowchef

AUTOSTART="${XDG_CONFIG_HOME:-"$HOME/.config"}/windowchef/autostart"

# Run the user windowchef autostart script
if test -f $AUTOSTART; then
    sh $AUTOSTART
elif test -f $AUTOSTART.sh; then
    sh $AUTOSTART.sh
fi
