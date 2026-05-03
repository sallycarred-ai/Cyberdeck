#!/bin/bash

OPTIONS=("Notes" "Photos" "Videos" "System" "Files" "Quick Note")
SELECTED=0

draw_ui() {
    clear
    echo "╔══════════════════════════════╗"
    echo "║        CYBERDECK SAL         ║"
    echo "╚══════════════════════════════╝"
    echo ""

    echo "TIME: $(date +%H:%M)"
    echo "IP:   $(hostname -I | awk '{print $1}')"
    echo ""
    echo "------------------------------"

    for i in "${!OPTIONS[@]}"; do
        if [ "$i" -eq "$SELECTED" ]; then
            echo "  █ ${OPTIONS[$i]}"
            echo ""
        else
            echo "    ${OPTIONS[$i]}"
            echo ""
        fi
    done

    echo "------------------------------"
    echo "↑/↓ select   SPACE launch   q quit"
}

run_selection() {
    clear
    case $SELECTED in
        0) nano ~/Notes/notes.txt ;;
        1) ls ~/Photos; read -p "Press Enter..." ;;
        2) ls ~/Videos; read -p "Press Enter..." ;;
        3) htop ;;
        4) mc ;;
        5) nano ~/quicknote.txt ;;
    esac
    draw_ui
}

draw_ui

while true; do
    read -rsn1 key

    if [[ "$key" == $'\x1b' ]]; then
        read -rsn2 key
        case "$key" in
            "[A") ((SELECTED--)) ;;
            "[B") ((SELECTED++)) ;;
        esac
    elif [[ "$key" == " " ]]; then
        run_selection
    elif [[ "$key" == "q" ]]; then
        clear
        exit
    fi

    if [ "$SELECTED" -lt 0 ]; then
        SELECTED=$((${#OPTIONS[@]} - 1))
    fi

    if [ "$SELECTED" -ge "${#OPTIONS[@]}" ]; then
        SELECTED=0
    fi

    draw_ui
done
