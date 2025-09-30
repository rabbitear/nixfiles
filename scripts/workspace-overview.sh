#!/usr/bin/env bash
# Show workspace overview (activities overview)

# Trigger the overview using dbus
gdbus call --session \
    --dest org.gnome.Shell \
    --object-path /org/gnome/Shell \
    --method org.gnome.Shell.Eval \
    'Main.overview.toggle();'
