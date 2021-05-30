#!/usr/bin/env bash

packages_=`pacman -Qt|fzf -m --preview 'cat <(pacman -Qi {1})' |awk '{ for (i = 1; i <= NF; i++) if (++j % 2 == 1) print $i; }'`

[ X"" = X"$packages_" ] && exit 0 || sudo pacman -Rsnc $packages_
