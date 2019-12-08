#!/bin/bash

WIDTH=30
HEIGHT=16
MINES=99

not_a_number(){
	echo "\"$1\" not a number";
	exit 1
}

while getopts "w:h:m:" o; do
	case "${o}" in
		w)
			WIDTH="${OPTARG}"
			((WIDTH)) || not_a_number "$WIDTH"
			;;
		h)
			HEIGHT="${OPTARG}"
			((HEIGHT)) || not_a_number "$HEIGHT"
			;;
		m)
			MINES="${OPTARG}"
			((MINES)) || not_a_number "$MINES"
			;;
		*)
			echo "unknown option"
			exit 1
			;;
	esac
done

rm -f /tmp/.X101-lock
export DISPLAY=:101

DISPLAY_WIDTH=$((1280 + WIDTH * 24))
DISPLAY_HEIGHT=$((720 + HEIGHT * 24))

Xvfb "$DISPLAY" -screen 0 "$DISPLAY_WIDTH"x"$DISPLAY_HEIGHT"x16 &
sleep 1

x11vnc_with_game(){
	/usr/games/xdemineur -geometry "$WIDTH"x"$HEIGHT" -m "$MINES" &
	MS_PID="$!"
	sleep 1
	WINDOW_ID=$(xwininfo -root -tree | grep xdemineur | tail -n1 | sed "s/^[ \t]*//" | cut -d ' ' -f1)
	x11vnc -id "$WINDOW_ID" -forever -shared -noxkb -cursor arrow --nocursor_drag --nodragging -nosetclipboard -noclipboard -nosetprimary -noprimary -nopw
	kill "$MS_PID"
}

x11vnc_with_game_loop(){
	while true; do
		x11vnc_with_game
	done
}

x11vnc_with_game_loop &

/noVNC/utils/launch.sh --listen 80
