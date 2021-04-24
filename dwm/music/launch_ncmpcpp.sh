#!/bin/sh

# start mpd if necessery and right after start ncmpcpp
[ X"" = X"`pgrep mpd`" ] && mpd && ncmpcpp || ncmpcpp
