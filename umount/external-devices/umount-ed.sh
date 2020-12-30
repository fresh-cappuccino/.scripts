#!/bin/sh

atribui_answer()
{
	if [[ "$check" = "y"* ]] || [[ "$check" = "Y"* ]] ; then
		answer=y
	elif [[ "$check" = "n"* ]] || [[ "$check" = "N"* ]] ; then
		answer=n
	elif [[ "$check" = "d"* ]] || [[ "$check" = "D"* ]] ; then
		answer=$default_answer
	else
		answer=x
	fi
}

interact()
{
	while [[ "$answer" != "y"* ]] && [[ "$answer" != "Y"* ]] && [[ "$answer" != "n"* ]] && [[ "$answer" != "N"* ]]
	do
		echo "$msg" && read answer
		[[ -z $answer ]] && answer=$default_answer
	done
}

umount_nonparam_device()
{
	lsblk

	echo "Choose the device [partition] to unmount: " && read device

	umount "$device"

	[[ $? -eq 0 ]] && echo "$device was SUCCESFULLY unmounted" || echo "Some problems appeared when unmounting $device..."
}

umount_param_device()
{
	umount "$device"

	[[ $? -eq 0 ]] && echo "$device was SUCCESFULLY unmounted" || echo "Some problems appeared when unmounting $device..."
}

while getopts d: OPTION
do
	case $OPTION in
		'd')
			device=$OPTARG
			;;

		'?')
			echo "Invalid option/parameter" && exit 1
			;;
	esac
done

main()
{
	if [ -z $device ] ; then
		umount_nonparam_device
	else
		umount_param_device
	fi

	default_answer=y
	msg="Do you want to power off the device? [Y/n]: "
	atribui_answer
	interact

	if [[ "$answer" = "y"* ]] || [[ "$answer" = "Y"* ]] ; then
		lsblk
		echo "Type the device to power-off [Disk, not partition]: " && read device
		udisksctl power-off -b "$device"
	fi
}

main
