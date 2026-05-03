#!/bin/bash

OPTIONS=("Notes" "Photos" "Videos" "System" "Files" "Quick Note")
SELECTED=0

boot_sequence() {
    clear
    toilet -f small -F border "CYBERDECK SAL"
    echo ""
    for msg in "Initialising core" "Loading modules" "Checking network" "Mounting interface" "System ready"; do
        echo "  [BOOT] $msg..."
        sleep 0.25
    done
    sleep 0.6
}

draw_ui() {
    clear

    toilet -f small -F border "CYBERDECK SAL"
    echo ""

    TIME=$(date +%H:%M)
    CPU=$(top -bn1 | awk '/Cpu/ {print $2}')
    MEM=$(free -m | awk '/Mem:/ {print $3}')
    IP=$(hostname -I | awk '{print $1}')

    FRAME=$((SECONDS % 4))
    case $FRAME in
        0) SPIN="-" ;;
        1) SPIN="\\" ;;
        2) SPIN="|" ;;
        3) SPIN="/" ;;
    esac

    case $((SECONDS % 3)) in
        0) BAR="░▒▓" ;;
        1) BAR="▒▓█" ;;
        2) BAR="▓█▓" ;;
    esac

    echo "┌────────────────────────────────────────┐"
    printf "│ TIME %-5s │ CPU %-5s%% │ MEM %-5sMB │\n" "$TIME" "$CPU" "$MEM"
    printf "│ IP   %-34s │\n" "$IP"
    echo "├──────────────────┬─────────────────────┤"

    for i in "${!OPTIONS[@]}"; do
        case $i in
            0) INFO="Edit notes" ;;
            1) INFO="Scan images" ;;
            2) INFO="Load media" ;;
            3) INFO="Monitor sys" ;;
            4) INFO="Browse files" ;;
            5) INFO="Capture note" ;;
        esac

        if [ "$i" -eq "$SELECTED" ]; then
            printf "│ █ %-12s │ %-19s │\n" "${OPTIONS[$i]}" "$INFO"
        else
            printf "│   %-12s │ %-19s │\n" "${OPTIONS[$i]}" "$INFO"
        fi
    done

    echo "├──────────────────┴─────────────────────┤"
    printf "│ CORE %s  SIGNAL %s  READY ▊             │\n" "$SPIN" "$BAR"
    echo "└────────────────────────────────────────┘"
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
}

handle_input() {
    read -rsn1 -t 0.25 key

    # If no key was pressed, do absolutely nothing
    if [ -z "$key" ]; then
        return
    fi

    # Arrow keys
    if [[ "$key" == $'\x1b' ]]; then
        read -rsn2 key
        case "$key" in
            "[A") ((SELECTED--)) ;;
            "[B") ((SELECTED++)) ;;
        esac
    fi

    # Use SPACE to launch instead of Enter
    if [[ "$key" == " " ]]; then
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

while true; do
    draw_ui
    handle_input
done
