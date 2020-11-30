#!/bin/sh

mem()
{
	mem_used_=$(echo "($(cat /proc/meminfo|sed -n 1p|tr -d [A-Za-z:' ']) - $(cat /proc/meminfo|sed -n 2p|tr -d [A-Za-z:' '])) / 1000"|bc)
	mem_tot_=$(echo $(cat /proc/meminfo | sed -n 1p | tr -d [A-Za-z:' ']) / 1000 | bc)" MiB"
	mem_="[📏] "$mem_used_"/"$mem_tot_

}
