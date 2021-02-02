#!/bin/sh

MAX_CHAR=10
aux=`[[ -d "$HOME/wallpaper" ]] && cd "$HOME/wallpaper" && ls "wall."{"jpeg","jpg","png"} 2>/dev/null`
[[ -f "$HOME/wallpaper/$aux" ]] && [[ ${#aux} -le $MAX_CHAR ]] && feh --bg-fill "$HOME/wallpaper/$aux"
