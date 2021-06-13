#!/bin/sh

notifications=1
sleep_=0

[ "$1" = "--dynamic" ] && notifications=`printf ""|dmenu -p "number of notifications to show up:"` && sleep_=`printf ""|dmenu -p "interval for each notification:"`

[ "$notifications" -eq "$notifications" ] 2>/dev/null || notifications=1
[ "$notifications" -lt 1 ] && notifications=1

[ -z $sleep_ ] && sleep_=0.4
[ X"" = X"`echo "0+0$sleep_"|bc 2>/dev/null`" ] && sleep_=0.4

i=0
while [ $i -lt $notifications ] ; do
	notify-send -i $HOME/.scripts/notification/send/icons/iwa-test.jpg "Test" "Testing notify-send $i"
	i=$((i + 1))
	sleep $sleep_
done
