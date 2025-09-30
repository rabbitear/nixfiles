#!/usr/bin/env bash
# Take a screenshot of selected area and save to ~/Pictures/Screenshots

mkdir -p ~/Pictures/Screenshots
filename="$HOME/Pictures/Screenshots/screenshot-$(date +%Y%m%d-%H%M%S).png"
gnome-screenshot -a -f "$filename"
notify-send "Screenshot saved" "$filename"
