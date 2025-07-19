#!/bin/bash

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
[ ! -d "$SCREENSHOT_DIR" ] && mkdir -p "$SCREENSHOT_DIR"
FILENAME="$SCREENSHOT_DIR/$(date +'%Y-%m-%d_%H-%M-%S').png"
MODE="full"

while [[ $# -gt 0 ]]; do
    case "$1" in
        --area)
            MODE="area"
            shift
            ;;
        --full)
            MODE="full"
            shift
            ;;
        *)
            echo "Unknow option: $1"
            exit 1
            ;;
    esac
done

if [ "$MODE" = "area" ]; then
    grim -t png - | satty --filename - --fullscreen --output-filename "$FILENAME"
else
    grim -t png "$FILENAME"
    wl-copy < "$FILENAME"
fi

if [ -f "$FILENAME" ]; then
    notify-send -a "Satty" -h "string:image-path:$FILENAME" "File saved at $FILENAME"
fi
