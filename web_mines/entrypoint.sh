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
XVFB_PID="$!"
sleep 1

x11vnc_with_game(){
	xdemineur -geometry "$WIDTH"x"$HEIGHT" -m "$MINES" &
	MS_PID="$!"
	sleep 1
	WINDOW_ID=$(xwininfo -root -tree | grep -a xdemineur | tail -n1 | sed "s/^[ \t]*//" | cut -d ' ' -f1)
	x11vnc -id "$WINDOW_ID" -forever -shared -cursor arrow -safer \
		-nobell -noclipboard -nocmds -nocursor_drag -nodragging -nomodtweak -noprimary \
		-nopw -noremote -nosel -nosetclipboard -nosetprimary -novncconnect -noxkb -noxrecord
	kill "$MS_PID"
}

x11vnc_with_game_loop(){
	while true; do
		x11vnc_with_game
	done
}

x11vnc_with_game_loop &
GAMELOOP_PID="$!"

exit_trap(){
	kill -s SIGTERM "${GAMELOOP_PID}" "${XVFB_PID}"
}

trap exit_trap EXIT

/root/utils/novnc_proxy --listen 80 --web /root/noVNC &
NOVNC_PID="$!"

term_trap(){
	kill -s SIGTERM "$NOVNC_PID"
}

trap term_trap TERM
wait -f
