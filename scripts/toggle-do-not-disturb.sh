#!/usr/bin/env bash
# Toggle Do Not Disturb mode

current=$(gsettings get org.gnome.desktop.notifications show-banners)

if [ "$current" = "true" ]; then
    gsettings set org.gnome.desktop.notifications show-banners false
    notify-send "Do Not Disturb" "Enabled"
else
    gsettings set org.gnome.desktop.notifications show-banners true
    notify-send "Do Not Disturb" "Disabled"
fi
