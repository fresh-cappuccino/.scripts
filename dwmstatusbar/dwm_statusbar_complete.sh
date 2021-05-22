#!/bin/sh

dte()
{
	date_="📅 "$(date +"%m/%d/%Y")" ╌ 🕗 "$(date +"%H:%M")
	hour_="`date +"%H"`"
	if [ $hour_ -eq "00" ] || [ $hour_ -eq "12" ] ; then
		clock_symbol="🕛"
	elif [ $hour_ -eq "01" ] || [ $hour_ -eq "13" ] ; then
		clock_symbol="🕐"
	elif [ $hour_ -eq "02" ] || [ $hour_ -eq "14" ] ; then
		clock_symbol="🕑"
	elif [ $hour_ -eq "03" ] || [ $hour_ -eq "15" ] ; then
		clock_symbol="🕒"
	elif [ $hour_ -eq "04" ] || [ $hour_ -eq "16" ] ; then
		clock_symbol="🕓"
	elif [ $hour_ -eq "05" ] || [ $hour_ -eq "17" ] ; then
		clock_symbol="🕔"
	elif [ $hour_ -eq "06" ] || [ $hour_ -eq "18" ] ; then
		clock_symbol="🕕"
	elif [ $hour_ -eq "07" ] || [ $hour_ -eq "19" ] ; then
		clock_symbol="🕖"
	elif [ $hour_ -eq "08" ] || [ $hour_ -eq "20" ] ; then
		clock_symbol="🕗"
	elif [ $hour_ -eq "09" ] || [ $hour_ -eq "21" ] ; then
		clock_symbol="🕘"
	elif [ $hour_ -eq "10" ] || [ $hour_ -eq "22" ] ; then
		clock_symbol="🕙"
	elif [ $hour_ -eq "11" ] || [ $hour_ -eq "23" ] ; then
		clock_symbol="🕚"
	fi
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
		volume_="⎡───⎦━━━━━━━━━━━━━━━━━━━━⎡🔇⎦"
	else
		num_vol=$(pamixer --get-volume)
		if [ $num_vol -eq 0 ] ; then
			num_vol_show="⎡◌◌◌⎦"
			vol_symbol="🔈"
		elif [ $num_vol -lt 10 ] ; then
			num_vol_show="⎡◌◌$num_vol⎦"
			vol_symbol="🔈"
		elif [ $num_vol -lt 20 ] ; then
			num_vol_show="⎡◌$num_vol⎦"
			vol_symbol="🔈"
		elif [ $num_vol -lt 50 ] ; then
			num_vol_show="⎡◌$num_vol⎦"
			vol_symbol="🔉"
		elif [ $num_vol -lt 100 ] ; then
			num_vol_show="⎡◌$num_vol⎦"
			vol_symbol="🔊"
		elif [ $num_vol -lt 500 ] ; then
			num_vol_show="⎡$num_vol⎦"
			vol_symbol="📣"
		elif [ $num_vol -lt 1000 ] ; then
			num_vol_show="⎡$num_vol⎦"
			vol_symbol="📢"
		else
			num_vol_show="⎡◌∞◌⎦"
			vol_symbol="∞"
		fi
		# 
		if [ $num_vol -gt 200 ] ; then
			volume_="$num_vol_show$vol_bar_extra⎡$vol_symbol⎦"
		elif [ $num_vol -gt 100 ] ; then
			num_vol_aux=$((num_vol - 100))
			volume_="$num_vol_show${vol_bar_extra:0:$(expr $num_vol_aux / 5)}${vol_bar:0:$(expr 20 - $num_vol_aux / 5)}⎡$vol_symbol⎦"
		else
			volume_="$num_vol_show${vol_bar:0:$(expr $num_vol / 5)}${vol_space:0:$(expr 20 - $num_vol / 5)}⎡$vol_symbol⎦"
		fi
	fi
}

initialization()
{
	vol_bar="▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇"
	# vol_bar_extra="❏❏❏❏❏❏❏❏❏❏❏❏❏❏❏❏❏❏❏❏"
	vol_bar_extra="⍐⍐⍐⍐⍐⍐⍐⍐⍐⍐⍐⍐⍐⍐⍐⍐⍐⍐⍐⍐"
	vol_space="⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯"

	# vol_bar="██████████"
	# vol_bar="▓▓▓▓▓▓▓▓▓▓"
	# vol_space="▂▂▂▂▂▂▂▂▂▂"
	# vol_space="__________"
}

main()
{
	initialization
	while true; do
		# cpu
		disk
		dte
		mem
		user
		volume

		# 🐧
		xsetroot -name " «» ⎮ $volume_ ⎮ 💻$mem_ ⎮ $disk_ ⎮ $date_ ⎰$user_⎱"
		# xsetroot -name "⎰«»⎱ $volume_ $date_ ⎰$user_⎱"
		sleep 0.1
	done
}

main
