#!/bin/bash

OPTIONS=("Notes" "Photos" "Videos" "System" "Files" "Quick Note")
SELECTED=0

boot_sequence() {
    clear
    toilet -f small -F border "CYBERDECK SAL"
    echo ""
    echo "[BOOT] Initialising core..."
    sleep 0.3
    echo "[BOOT] Loading interface..."
    sleep 0.3
    echo "[BOOT] Checking network..."
    sleep 0.3
    echo "[BOOT] Mounting modules..."
    sleep 0.3
    echo "[OK] SYSTEM READY"
    sleep 1
}

draw_ui() {
    clear

    # 🔥 HEADER
    toilet -f small -F border "CYBERDECK SAL"

    echo ""
    date +"   %H:%M"
    echo "   Use ↑ ↓ and ENTER"
    echo ""

    # 📋 MENU
    for i in "${!OPTIONS[@]}"; do
        if [ $i -eq $SELECTED ]; then
            echo "   > ${OPTIONS[$i]}"
        else
            echo "     ${OPTIONS[$i]}"
        fi
    done

    echo ""
    echo "   -----------------------"

    # 📊 SYSTEM PANEL
    CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}')
    MEM=$(free -m | awk '/Mem:/ {print $3}')
    IP=$(hostname -I | awk '{print $1}')

    echo "   CPU: ${CPU}%"
    echo "   MEM: ${MEM}MB"
    echo "   IP : ${IP}"

    echo ""
    echo "   ======================="
    echo "      SYSTEM READY"
    echo "   ======================="
}

handle_input() {
    read -rsn1 key
    if [[ $key == $'\x1b' ]]; then
        read -rsn2 key
        case "$key" in
            "[A") ((SELECTED--)) ;; # UP
            "[B") ((SELECTED++)) ;; # DOWN
        esac
    elif [[ $key == "" ]]; then
        run_selection
    fi

    # Wrap around
    if [ $SELECTED -lt 0 ]; then
        SELECTED=$((${#OPTIONS[@]} - 1))
    fi
    if [ $SELECTED -ge ${#OPTIONS[@]} ]; then
        SELECTED=0
    fi
}

run_selection() {
    case $SELECTED in
        0) nano ~/Notes/notes.txt ;;
        1) clear; ls ~/Photos; read -p "Press Enter" ;;
        2) clear; ls ~/Videos; read -p "Press Enter" ;;
        3) clear; htop ;;
        4) clear; ls; read -p "Press Enter" ;;
        5) nano ~/quicknote.txt ;;
    esac
}

# 🚀 STARTUP
boot_sequence

# 🔁 LOOP
while true; do
    draw_ui
    handle_input
done
