#!/bin/sh

if [ X"" = X"`ps ax|grep dwm_statusbar_complete|grep -v grep`" ] ; then
	killall dwm_statusbar.sh 2>&1 >/dev/null
else
	killall dwm_statusbar_complete.sh 2>&1 >/dev/null
fi
