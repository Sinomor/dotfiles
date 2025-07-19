#!/bin/bash

hex_color=$(niri msg pick-color | awk '/Hex:/ {print $2}')
echo -n "$hex_color" | wl-copy
