#!/bin/sh

rename_path()
{
	npath=0
	path_base="/run/media/ed"
	path=$path_base$npath

	while [[ -d "$path" ]]
	do
		npath=$[$npath + 1]
		path=$path_base$npath
	done
}

mount_param_device()
{
	[[ -z "$path" ]] && rename_path
	[[ -d "$path" ]] || mkdir -p "$path"

	mount "$device" "$path"

	[[ $? -eq 0 ]] && echo "$device was SUCCESFULLY mounted in $path. Press [ENTER] to continue"
}

mount_nonparam_device()
{
	[[ -z "$path" ]] && rename_path

	lsblk

	echo "Type the partition you want to mount: " && read device

	[[ -d "$path" ]] || mkdir -p "$path"

	mount "$device" "$path"

	[[ $? -eq 0 ]] && echo "$device was SUCCESFULLY mounted in $path. Press [ENTER] to continue"
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
	echo "... type [ENTER] to continue ..." && read aux
}

main
