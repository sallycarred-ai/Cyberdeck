#!/bin/bash
while true
do
  clear
  toilet -f small "CYBERDECK"
  echo ""
  echo ""
  echo "$(date +%H:%M)"
  echo "==========================="
OPTIONS=("Notes" "Photos" "Videos" "System" "Files" "Quick Note")
SELECTED=0

while true; do
    clear

    echo "==== CYBERDECK SAL ===="
    echo "$(date +%H:%M)"
    echo "Use ↑ ↓ and ENTER"
    echo ""

    for i in "${!OPTIONS[@]}"; do
        if [ $i -eq $SELECTED ]; then
            echo "> ${OPTIONS[$i]}"
        else
            echo "  ${OPTIONS[$i]}"
        fi
    done

    read -rsn1 key

    if [[ $key == $'\x1b' ]]; then
        read -rsn2 key

        case $key in
            "[A") ((SELECTED--)) ;;  # UP
            "[B") ((SELECTED++)) ;;  # DOWN
        esac
    elif [[ $key == "" ]]; then
        case $SELECTED in
            0) nano Notes/notes.txt ;;
            1) echo "Photos coming soon"; sleep 1 ;;
            2) echo "Videos coming soon"; sleep 1 ;;
            3) htop ;;
            4) mc ;;
            5) nano Notes/quick.txt ;;
        esac
    fi

    # wrap around
    if [ $SELECTED -lt 0 ]; then
        SELECTED=$((${#OPTIONS[@]} - 1))
    fi
    if [ $SELECTED -ge ${#OPTIONS[@]} ]; then
        SELECTED=0
    fi
done
