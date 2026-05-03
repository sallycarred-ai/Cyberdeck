#!/bin/bash

OPTIONS=("Notes" "Photos" "Videos" "System" "Files" "Quick Note")
SELECTED=0

draw_ui() {
    clear

    # 🔥 TITLE
    toilet -f small -F border "CYBERDECK SAL"

    # 🕒 TIME + INSTRUCTIONS
    echo ""
    printf "        %s\n" "$(date +%H:%M)"
    printf "     Use ↑ ↓ and ENTER\n"
    echo ""

    # 📋 MENU (centered feel)
    for i in "${!OPTIONS[@]}"; do
        if [ $i -eq $SELECTED ]; then
            printf "        > %s\n" "${OPTIONS[$i]}"
        else
            printf "          %s\n" "${OPTIONS[$i]}"
        fi
    done

    echo ""
    echo "----------------------"

    # ⚙️ SYSTEM STATUS (fills blank space)
    CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}')
    MEM=$(free -m | awk '/Mem:/ {print $3 "MB"}')
    IP=$(hostname -I | awk '{print $1}')

    printf " CPU: %s%%\n" "$CPU"
    printf " MEM: %s\n" "$MEM"
    printf " IP : %s\n" "$IP"

    echo ""
    echo "======================"
    echo "   SYSTEM READY"
    echo "======================"
}

while true
do
    draw_ui

    read -rsn1 key

    if [[ $key == $'\x1b' ]]; then
        read -rsn2 key
        case $key in
            "[A") ((SELECTED--)) ;;
            "[B") ((SELECTED++)) ;;
        esac

    elif [[ $key == "" ]]; then
        clear
        case $SELECTED in
            0) nano Notes/notes.txt ;;
            1) echo "📸 Photos coming soon"; sleep 1 ;;
            2) echo "🎬 Videos coming soon"; sleep 1 ;;
            3) htop ;;
            4) mc ;;
            5) nano Notes/quick.txt ;;
        esac
    fi

    # wrap selection
    if [ $SELECTED -lt 0 ]; then
        SELECTED=$((${#OPTIONS[@]} - 1))
    fi

    if [ $SELECTED -ge ${#OPTIONS[@]} ]; then
        SELECTED=0
    fi
done
