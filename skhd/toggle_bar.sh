#!/bin/bash


# Usa percorsi completi
YABAI="/opt/homebrew/bin/yabai"
SKETCHYBAR="/opt/homebrew/bin/sketchybar"


    # Nascondi la barra
    $YABAI -m config external_bar all:0:0
    $SKETCHYBAR --bar height=0