#!/bin/sh

killall dwm_statusbar.sh 2>&1 >/dev/null

$HOME/.scripts/dwmstatusbar/dwm_statusbar.sh &
