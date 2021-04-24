#!/bin/sh

rename_path()
{
	npath=0
	path_base="$HOME/external/device"
	path=$path_base$npath

	while [ -d "$path" ]
	do
		npath=$(($npath + 1))
		path=$path_base$npath
	done
}

mount_param_device()
{
	[ X"" = X"$path" ] && rename_path
	[ -d "$path" ] || mkdir -p "$path"

	mount -o umask=0770,gid=`id -g $(whoami)`,uid=`id -u $(whoami)` "$device" "$path"

	[ "$?" -eq 0 ] && echo "$device was SUCCESFULLY mounted in $path. Press [ENTER] to continue"
}

mount_nonparam_device()
{
	[ X"" = X"$path" ] && rename_path

	lsblk

	echo "Type the partition you want to mount: " && read device

	[ -d "$path" ] || mkdir -p "$path"

	mount -o umask=0770,gid=`id -g $(whoami)`,uid=`id -u $(whoami)` "$device" "$path"

	[ "$?" -eq 0 ] && echo "$device was SUCCESFULLY mounted in $path. Press [ENTER] to continue"
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
	if [ X"" = X"$device" ] ; then
		mount_nonparam_device
	else
		mount_param_device
	fi
	echo "... type [ENTER] to continue ..." && read aux
}

main
