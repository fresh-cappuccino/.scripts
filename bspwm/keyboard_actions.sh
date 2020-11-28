#!/bin/sh

# setting ABNT 2 layout for US keyboard
setxkbmap -model abnt -layout us -variant intl

# switching CAPS with ESC
/usr/bin/setxkbmap -option "caps:swapescape"
