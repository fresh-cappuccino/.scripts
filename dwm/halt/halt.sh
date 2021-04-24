#!/usr/bin/env bash

# Define LOCKER in .xprofile to set to different LOCKER program
LOCKER="${LOCKER:-slock}"

# use notify-send if run in dumb term
OUTPUT="echo"
[[ ${TERM} == 'dumb' ]] && OUTPUT="notify-send"

declare -a MANAGERS=(
"awesome"
"bspwm"
"dwm"
"spectrwm"
"xmonad"
"qtile"
)

# An array of options to choose.
declare -a options=(
"Lock screen"
"Logout"
"Reboot"
"Shutdown"
"Suspend"
"Quit"
)

yesno()
{
	# shellcheck disable=SC2005
	echo "$(echo -e "No\nYes" | dmenu -i -p "${1}")"
}

# Piping the above array into dmenu.
# We use "printf '%s\n'" to format the array one item to a line.
choice=$(printf '%s\n' "${options[@]}" | dmenu -i -p 'Shutdown menu:')

# What to do when/if we choose one of the options.
case $choice in
	'Logout')
		if [[ $(yesno "Logout?") == "Yes" ]]; then
			for manager in "${MANAGERS[@]}"; do
				killall "${manager}" || ${OUTPUT} "Process ${manager} was not running."
			done
		else
			${OUTPUT} "User chose not to logout." && exit 1
		fi
		;;

	'Lock screen')
		${LOCKER}
		;;

	'Reboot')
		if [[ $(yesno "Reboot?") == "Yes" ]]; then
			shutdown -r now
		else
			${OUTPUT} "User chose not to reboot." && exit 0
		fi
		;;

	'Shutdown')
		if [[ $(yesno "Shutdown?") == "Yes" ]]; then
			shutdown -h now
		else
			${OUTPUT} "User chose not to shutdown." && exit 0
		fi
		;;

	'Suspend')
		if [[ $(yesno "Suspend?") == "Yes" ]]; then
			systemctl suspend
		else
			${OUTPUT} "User chose not to suspend." && exit 0
		fi
		;;

	'Quit')
		${OUTPUT} "Program terminated." && exit 0
		;;
		# It is a common practice to use the wildcard asterisk symbol (*) as a final
		# pattern to define the default case. This pattern will always match.
		*)
		exit 0
		;;
esac
