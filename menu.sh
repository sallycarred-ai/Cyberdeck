#!/bin/bash

OPTIONS=("Notes" "Photos" "Videos" "System" "Files" "Quick Note")
SELECTED=0

show_splash() {
    sudo fbi -T 1 -noverbose -a ~/cyberdeck/splash.jpg >/dev/null 2>&1 &
    sleep 2
    sudo killall fbi >/dev/null 2>&1
    }
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
    echo "[OK] SYSTEM READY"
    sleep 1
}

draw_ui() {
    clear

    toilet -f small -F border "CYBERDECK SAL"
    echo ""

    CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}')
    MEM=$(free -m | awk '/Mem:/ {print $3}')
    IP=$(hostname -I | awk '{print $1}')
    TIME=$(date +%H:%M)

    printf "  %-14s  TIME: %s\n" "" "$TIME"
    printf "  %-14s  CPU : %s%%\n" "" "$CPU"
    printf "  %-14s  MEM : %sMB\n" "" "$MEM"
    printf "  %-14s  IP  : %s\n" "" "$IP"
    echo "  -----------------------------"

    for i in "${!OPTIONS[@]}"; do
        if [ $i -eq $SELECTED ]; then
            printf "  > %-12s  %s\n" "${OPTIONS[$i]}" ""
        else
            printf "    %-12s  %s\n" "${OPTIONS[$i]}" ""
        fi
    done

    echo ""
    echo "  [ SYSTEM READY ]"
}

handle_input() {
    read -rsn1 key

    if [[ $key == $'\x1b' ]]; then
        read -rsn2 key
        case "$key" in
            "[A") ((SELECTED--)) ;;
            "[B") ((SELECTED++)) ;;
        esac
    elif [[ $key == "" ]]; then
        run_selection
    fi

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

boot_sequence

while true; do
    draw_ui
    handle_input
done
# 🚀 STARTUP
show_splash
boot_sequence

# 🔁 MAIN LOOP
while true
do
    draw_ui
    handle_input
done
