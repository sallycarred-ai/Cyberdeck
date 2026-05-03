#!/bin/bash

OPTIONS=("Notes" "Photos" "Videos" "System" "Files" "Quick Note")
SELECTED=0

draw_menu() {
    clear

    # BIG CYBERDECK TITLE
    toilet -f small -F border "CYBERDECK SAL"

    echo ""
    printf "      %s\n" "$(date +%H:%M)"
    printf "  Use ↑ ↓ and ENTER\n"
    echo ""

    for i in "${!OPTIONS[@]}"; do
        if [ $i -eq $SELECTED ]; then
            printf "   > %s\n" "${OPTIONS[$i]}"
        else
            printf "     %s\n" "${OPTIONS[$i]}"
        fi
    done

    echo ""
}

while true
do
    draw_menu

    read -rsn1 key

    if [[ $key == $'\x1b' ]]; then
        read -rsn2 key
        case $key in
            "[A") ((SELECTED--)) ;;  # UP
            "[B") ((SELECTED++)) ;;  # DOWN
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
