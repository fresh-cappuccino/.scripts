#!/bin/sh
#
# Set brightness with xbacklight, but never go below 1 (as that's "off").
#

# Increment to use.
incr=5%

cur=$(xbacklight -get)
case "$1" in
	"up")
		[ "$cur" -eq 0 ] && xbacklight -set 1 || xbacklight -inc $incr
		;;
	"down")
		[ "$cur" -le 5 ] && xbacklight -set 1 || xbacklight -dec $incr
		;;
	*)
		echo "Unsupported: \"$1\""
		exit 1
esac

xbacklight -get
