#!/bin/sh

# start mpd if necessery and right after start ncmpcpp
[ X"" = X"`pgrep mpd`" ] && mpd && notify-send -i $HOME/.scripts/dwm/music/icons/iwa-music.jpg "Music" "ncmpcpp successfully launched" && ncmpcpp || ncmpcpp
