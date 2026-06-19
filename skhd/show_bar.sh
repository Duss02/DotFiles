#!/bin/bash

# Usa percorsi completi
YABAI="/opt/homebrew/bin/yabai"
SKETCHYBAR="/opt/homebrew/bin/sketchybar"

    # Mostra la barra
    $YABAI -m config external_bar all:25:0
    $SKETCHYBAR --bar height=35