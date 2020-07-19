#!/bin/bash

# Source: https://retropie.org.uk/forum/topic/12895/ensuring-es-gracefully-finish-and-save-metadata-in-every-system-shutdown

# Check if EmulationStation is running. Finish the script if isn't.
espid="$(pgrep -f "/opt/retropie/supplementary/.*/emulationstation([^.]|$)")" || exit 0

# The "sed" command below isn't a crypted message :)
# It's just a trick to make $emucall regex-safe to use in the "pgrep -f" below.
emucall="$(sed '4!d; s/\([\\"]\|[[:alnum:]_]\+=[^ ]* \)//g; s/[][(){}^$*.|+? ]/\\&/g' /dev/shm/runcommand.info)"

# If there's an emulator running, we need to kill it and go back to ES.
if [[ -n "$emucall" ]]; then
    emupid="$(pgrep -f "$emucall" | tr '\n' ' ')"
    pkill -P "$(echo $emupid | tr ' ' ',')"
    kill "$emupid"
    wait "$emupid"
    sleep 5 # maybe it can be less
fi

kill "$espid"
wait "$espid"
sleep 5 # maybe it can be less
