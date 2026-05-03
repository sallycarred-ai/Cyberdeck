#!/bin/bash

OPTIONS=("Notes" "Photos" "Videos" "System" "Files" "Quick Note")
SELECTED=0

boot_sequence() {
    clear
    toilet -f small -F border "CYBERDECK SAL"
    echo ""
    echo "  [BOOT] Loading SAL OS..."
    sleep 0.4
    echo "  [BOOT] Checking modules..."
    sleep 0.4
    echo "  [BOOT] Network online..."
    sleep 0.4
    echo "  [OK] System ready"
    sleep 0.8
}

draw_static() {
    clear
    toilet -f small -F border "CYBERDECK SAL"
    echo ""

    echo "┌────────────────────────────────────────┐"
    echo "│                                        │"
    echo "│                                        │"
    echo "│                                        │"
    echo "│                                        │"
    echo "│                                        │"
    echo "│                                        │"
    echo "├──────────────────┬─────────────────────┤"
    echo "│                                        │"
    echo "│                                        │"
    echo "│                                        │"
    echo "│                                        │"
    echo "│                                        │"
    echo "│                                        │"
    echo "├──────────────────┴─────────────────────┤"
    echo "│  ↑/↓ select        SPACE launch         │"
    echo "│  ◆ SYSTEM READY ◆                       │"
    echo "└────────────────────────────────────────┘"
}

draw_dynamic() {
    # move cursor to menu start (adjust if needed)
    tput cup 8 0

    for i in "${!OPTIONS[@]}"; do
        case $i in
            0) INFO="Open notes" ;;
            1) INFO="Images" ;;
            2) INFO="Videos" ;;
            3) INFO="System" ;;
            4) INFO="Files" ;;
            5) INFO="Quick note" ;;
        esac

        if [ "$i" -eq "$SELECTED" ]; then
            printf "│ █ %-12s │ %-19s │\n" "${OPTIONS[$i]}" "$INFO"
        else
            printf "│   %-12s │ %-19s │\n" "${OPTIONS[$i]}" "$INFO"
        fi
    done
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

    draw_static
    draw_dynamic
}

handle_input() {
    read -rsn1 key

    if [[ "$key" == $'\x1b' ]]; then
        read -rsn2 key
        case "$key" in
            "[A") ((SELECTED--)) ;;
            "[B") ((SELECTED++)) ;;
        esac
    elif [[ "$key" == " " ]]; then
        run_selection
    fi

    if [ "$SELECTED" -lt 0 ]; then
        SELECTED=$((${#OPTIONS[@]} - 1))
    fi

    if [ "$SELECTED" -ge "${#OPTIONS[@]}" ]; then
        SELECTED=0
    fi
}

boot_sequence
tput civis

draw_static
draw_dynamic

while true; do
    OLD=$SELECTED
    handle_input

    if [ "$OLD" -ne "$SELECTED" ]; then
        draw_dynamic
    fi
done
