#!/usr/bin/env bash

terminal_='st'

# use notify-send if run in dumb term
OUTPUT="echo"
[[ ${TERM} == 'dumb' ]] && OUTPUT="notify-send"

declare -a options=(
"update"
"install"
"install - AUR"
"remove"
"list"
"list - all"
)


# Piping the above array into dmenu.
# We use "printf '%s\n'" to format the array one item to a line.
choice=$(printf '%s\n' "${options[@]}" | dmenu -i -l 21 -p '[comm] pacman: ')

# What to do when/if we choose one of the options.
case $choice in
	'update')
		$terminal_ $HOME/.scripts/dwm/pacman/pacupdate.sh
		[ $? -eq 0 ] && notify-send "Pacman update" "Package(s) successfully updated" || notify-send "Error" "An error occurred while trying to update the package(s)"
		;;

	'install')
		$terminal_ $HOME/.scripts/dwm/pacman/pacinstall.sh
		[ $? -eq 0 ] && notify-send "Pacman install" "Package(s) successfully installed" || notify-send "Error" "An error occurred while trying to install the package(s)"
		;;

	'install - AUR')
		$terminal_ $HOME/.scripts/dwm/pacman/pacinstall_aur.sh
		[ $? -eq 0 ] && notify-send "Pacman install" "Package(s) successfully installed" || notify-send "Error" "An error occurred while trying to install the package(s)"
		;;

	'remove')
		$terminal_ $HOME/.scripts/dwm/pacman/pacremove.sh
		[ $? -eq 0 ] && notify-send "Pacman remove" "Package(s) successfully removed" || notify-send "Error" "An error occurred while trying to remove the package(s)"
		;;

	'list')
		$terminal_ $HOME/.scripts/dwm/pacman/paclist.sh
		;;

	'list - all')
		$terminal_ $HOME/.scripts/dwm/pacman/paclist_all.sh
		;;
esac
