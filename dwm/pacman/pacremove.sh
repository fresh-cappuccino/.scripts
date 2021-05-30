#!/bin/sh

packages_=`pacman -Qt|fzf -m|awk '{ for (i = 1; i <= NF; i++) if (++j % 2 == 1) print $i; }'`

sudo pacman -Rsnc $packages_
