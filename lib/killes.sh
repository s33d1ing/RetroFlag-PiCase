#!/bin/bash

# Source: https://retropie.org.uk/forum/topic/12895/ensuring-es-gracefully-finish-and-save-metadata-in-every-system-shutdown

# Check if EmulationStation is running. Finish the script if isn't.
espid="$(pgrep -f "/opt/retropie/supplementary/.*/emulationstation([^.]|$)")" || exit 0

# If there's an emulator running, we need to kill it and go back to ES.
emupid="$(pgrep -f -n runcommand.sh)"
if [[ -n "$emupid" ]]; then
    pkill -P "$(echo $emupid | tr ' ' ',')"
    kill "$emupid"
    # Hold in this while loop until the emulator process stops
    while s=$(ps -p "$emupid" -o s=) && [ "$s" ] && [ "$s" != 'Z' ]; do
        sleep 1
        done
fi

kill "$espid"
wait "$espid"
sleep 5 # maybe it can be less
