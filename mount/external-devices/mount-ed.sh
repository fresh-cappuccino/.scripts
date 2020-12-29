#!/bin/sh

mount_param_device()
{
	[[ -z "$path" ]] && path=/run/media/ed/

	[[ -d "$path" ]] || mkdir -p "$path"

	mount "$device" "$path"

	[[ $? -eq 0 ]] && echo "$device was SUCCESFULLY mounted in $path"
}

mount_nonparam_device()
{
	[[ -z "$path" ]] && path=/run/media/ed

	lsblk

	echo "Type the partition you want to mount: " && read device

	[[ -d "$path" ]] || mkdir -p "$path"

	mount "$device" "$path"

	[[ $? -eq 0 ]] && echo "$device was SUCCESFULLY mounted in $path"
}

while getopts a:d:p: OPTION
do
	case $OPTION in
		'd')
			device=$OPTARG
			;;

		'p')
			path=$OPTARG
			;;

		'?')
			echo "Invalid option/argument" && exit 1
			;;
	esac
done

main()
{
	if [ -z $device ] ; then
		mount_nonparam_device
	else
		mount_param_device
	fi
}

main
