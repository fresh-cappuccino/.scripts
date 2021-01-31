#!/bin/sh

# start mpd if necessery and right after start ncmpcpp
[[ -z `pgrep mpd` ]] && mpd && ncmpcpp || ncmpcpp
