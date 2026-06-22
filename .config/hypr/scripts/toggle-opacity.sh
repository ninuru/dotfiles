#!/bin/bash
current=$(hyprctl getoption decoration:active_opacity | awk '/float/ { print $2 }')

if (( $(echo "$current < 1.0" | bc -l) )); then
    hyprctl keyword decoration:active_opacity 1.0
    hyprctl keyword decoration:inactive_opacity 1.0
else
    hyprctl keyword decoration:active_opacity 0.9
    hyprctl keyword decoration:inactive_opacity 0.8
fi
