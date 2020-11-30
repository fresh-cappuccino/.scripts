#!/bin/sh

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
	disk_root=$(df -h|awk '{if ($6 == "/") {print}}'|awk '{print "[/]: " $5}')
	disk_home=$(df -h|awk '{if ($6 == "/home") {print}}'|awk '{print "[/home]: " $5}')
	disk_="💾 $disk_root $disk_home"
}
