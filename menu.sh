#!/bin/bash

OPTIONS=("Notes" "Photos" "Videos" "WiFi" "Reboot" "Shutdown" "Exit")
SELECTED=0

while true
do
clear
TIME=$(date +%H:%M)

echo "====CYBERDECK SAL===="
echo "_____________________"
echo "$TIME"
echo "Use UP/DOWN + ENTER"
echo ""

for i in "${!OPTIONS[@]}"
do
  if [ "$i" -eq "$SELECTED" ]; then
    echo "> ${OPTIONS[$I]}"
  else
    echo "  $OPTIONS[$i]}"
  fi
done

read -rsn1 key
if [[ "$key" == $'\e' ]]; then
  read -rsn2 key
fi

case "$key" in
 A) SELECTED=$((SELECTED - 1)) ;;   # UP
 B) SELECTED=$((SELECTED + 1)) ;;   # DOWN

 "") # ENTER
   case "$SELECTED" in
     0) nano  Notes/notes.txt ;;
     1) echo "Photos coming soon"; read ;;
     2) echo "Videos coming soon"; read ;;
     3) echo "System info"; read ;;
     4) echo "Manageb files"; read ;;
     5) nano quicknote.txt ;;
     6) sudo shutdown now ;;
     7) iwconfig wlan0; read ;;
     8) sudo reboot ;;
     9) exit ;;
   esac
  ;;
esac

if [ "$SELECTED" -LT 0 ]; then
 SELECTED=$((${#OPTIONS[@]} - 1))
fi

if [ "$SELECTED" -lt 0 ]; then
 SELECTED=0
fi
done


echo ""
echo "Use 
# TOP BAR
TIME=$(date +%H:%M)
WIFI=$(iwgetid -r)
IP=$(hostname -I | cut -d" " -f1)

echo "======================================="
printf "   %s   WiFi: %s\n" "$TIME" "$WIFI"
printf "   IP: %s  Sig: %s  dBm   Bat: %s\n" "$IP" "$SIGNAL" "$BAT"
echo "======================================="


echo ""
echo "==== CYBERDECK MENU ===="
echo "1) Notes"

echo "2) Photos"
echo "3) Videos"

echo "4) System"

echo "5) Manage Files"
echo "6) Quick Note"

echo "7) Shutdown"
echo "8) WiFi Status"
echo "9) Reboot"

echo "0) EXIT"
echo ""
read -p "Choose: " choice

case $choice in

1)
  files=$(ls Notes | fzf --prompt="Choose notes: ")
  if [ -z "$file" ]; then
    read -p "New note name: " newfile
    micro "Notes/$newfile.txt"
  else
    micro "Notes/$file"
  fi
  ;;

2)
  files=$(ls Photos | fzf --prompt="Choose photo: ")
  [ -n "$file" ] && sudo fbi -T 1 "Photos/$file"
  ;;

3)
  files=$(ls Videos | fzf --prompt="Choose video: ")
  [ -n "$file" ] && mpv --vo=drm "Videos/$file"
  ;;

4)  clear
  === TOP BAR ===
  clear

  TIME=$(date +%H:%M)
  WIFI=$(iwgetid -r)
  IP=$(hostname -I | -d" " -f1)


  SIGNAL=$(iwconfig wlan0 2>/dev/null | grep "Signal level" | cut -d= -f3 | cut -d" " -f1)

  BAT=$(upower -i $(upower -e | grep BAT | head -1) 2>/dev/null | grep percentage | cut -d: -f2 | xargs)

  if [ -z "$BAT" ]; then
    BAT="Ext"
  fi
  echo "======================================="
  printf "   %s   WiFi: %s\n" "$TIME" "$WIFI"
  printf "   IP: %s  Sig: %s  dBm   Bat: %s\n" "$IP" "$SIGNAL" "$BAT"
  echo "======================================="

  echo ""
  read -p "Press enter..."
  ;;

5)
  echo "1) Delete photo"
  echo "2) Delete video"
  echo "3) elete note"
  read -p "Choose: " delchoice

  if [ "$delchoice" = "1" ]; then
    file=$(ls Photos | fzf)
    [ -n "$file" ] && rm "Photos/$file"
  elif [ "$delchoice" = "2" ]; then
    file=$(ls Videos | fzf)
    [ -n "$file" ] && rm "Videos/$file"
  elif [ "$delchoice" = "3" ]; then
    file=$(ls Notes | fzf)
    [ -n "$file" ] && rm "Notes/$file"
  fi
  ;;

6)

  micro Notes/qicknote.txt
  ;;

7)
  sudo shutdown now
  ;;

8)
  clear
  iwconfig wlan0
  read -p "Press enter..."
  ;;

9)
  sudo reboot
  ;;

0)
  clear
  exit
  ;;


*)
  echo "Invalid option"
  sleep 1
  ;;

esac
done
