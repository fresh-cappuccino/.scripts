#!/bin/sh

dte()
{
	date_="📅 "$(date +"%m/%d/%Y")" - 🕗 "$(date +"%H:%M")
}

mem()
{
	mem_used_=$(echo "(`cat /proc/meminfo|sed -n 1p|tr -d \"A-Za-z:' '\"` - `cat /proc/meminfo|sed -n 2p|tr -d \"A-Za-z:' '\"`) / 1000"|bc)
	mem_tot_=$(echo "`cat /proc/meminfo|sed -n 1p|tr -d \"A-Za-z:' '\"` / 1000"|bc)" MiB"
	mem_="「📏」 "$mem_used_"/"$mem_tot_

}

cpu()
{
	#cpu_tmp
	cpu_="💻 "$(top -b -n1 -p 1|fgrep "Cpu(s)"|tail -1|awk -F'id,' -v prefix="$prefix" '{ split($1, vs, ","); v=vs[length(vs)]; sub("%", "", v); printf "%s%.1f%%\n", prefix, 100 - v }')
}

#cpu_tmp()
#{
	#cpu_tmp_="﨎$(expr $(cat "/sys/class/hwmon/hwmon1/temp1_input") / 1000)°C"
#}

disk(){
	disk_root=$(df -h|awk '{if ($6 == "/") {print}}'|awk '{print "「/」: " $5}')
	disk_home=$(df -h|awk '{if ($6 == "/home") {print}}'|awk '{print "「~」: " $5}')
	disk_=" $disk_root $disk_home"
}

user()
{
	user_=$(whoami)
	if [ "$user_" = "coffee" ] || [ "$user" = "cappuccino" ] ; then
		user_="☕$user_☕"
	fi
}

volume()
{
	#
	muted_=$(pamixer --get-mute)
	if [ "$muted_" = "true" ] ; then

		volume_="「──」「──────────」「🔇」"
	else
		num_vol=$(pamixer --get-volume)
		volume_="「$num_vol」「${vol_bar:0:$(expr $num_vol / 10)}${vol_space:0:$(expr 10 - $num_vol / 10)}」「」"
	fi
}

main()
{
	vol_bar="▇▇▇▇▇▇▇▇▇▇"
	vol_space="⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯"

	# vol_bar="██████████"
	# vol_bar="▓▓▓▓▓▓▓▓▓▓"
	# vol_space="▂▂▂▂▂▂▂▂▂▂"
	# vol_space="__________"
	while true; do
		#cpu
		disk
		dte
		mem
		user
		volume

		#🐧
		xsetroot -name " «» ⎰ $volume_ ⎮ 💻$mem_ ⎮ $disk_ ⎮ $date_ ⎱ $user_ "
		sleep 0.2
	done
}

main
