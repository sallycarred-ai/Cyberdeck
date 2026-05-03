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

draw_ui() {
    clear

    toilet -f small -F border "CYBERDECK SAL"
    echo ""

    TIME=$(date +%H:%M)
    CPU=$(top -bn1 | awk '/Cpu/ {print $2}')
    MEM=$(free -m | awk '/Mem:/ {print $3}')
    IP=$(hostname -I | awk '{print $1}')

    echo "┌────────────────────────────────────────┐"
    printf "│ TIME %-5s │ CPU %-5s%% │ MEM %-5sMB │\n" "$TIME" "$CPU" "$MEM"
    printf "│ IP   %-34s │\n" "$IP"
    echo "├──────────────────┬─────────────────────┤"

    for i in "${!OPTIONS[@]}"; do
        case $i in
            0) INFO="Open notes" ;;
            1) INFO="Image files" ;;
            2) INFO="Video files" ;;
            3) INFO="Monitor" ;;
            4) INFO="Browse files" ;;
            5) INFO="Fast note" ;;
        esac

        if [ "$i" -eq "$SELECTED" ]; then
            printf "│ █ %-12s │ %-19s │\n" "${OPTIONS[$i]}" "$INFO"
        else
            printf "│   %-12s │ %-19s │\n" "${OPTIONS[$i]}" "$INFO"
        fi

        echo "│                  │                     │"
    done

    echo "├──────────────────┴─────────────────────┤"
    echo "│  ↑/↓ select        SPACE launch         │"
    echo "│  ◆ SYSTEM READY ◆                       │"
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

while true; do
    draw_ui
    handle_input
done

boot_sequence

while true; do
    draw_ui
    handle_input
done
