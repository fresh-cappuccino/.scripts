#!/usr/bin/env bash

terminal_='st'

# use notify-send if run in dumb term
OUTPUT="echo"
[[ ${TERM} == 'dumb' ]] && OUTPUT="notify-send"

declare -a options=(
"update --- ( -Syyu )"
"install --- ( -S )"
"install [ AUR ] --- ( -S --AUR )"
"remove --- ( -Rsnc )"
"list --- ( -Qt )"
"list all --- ( -Q )"
)

# Piping the above array into dmenu.
# "printf '%s\n'" used to format the array one item to a line.
choice=$(printf '%s\n' "${options[@]}" | dmenu -i -l 21 -p '[comm] pacman: ')

# What to do when/if we choose one of the options.
case $choice in
	"update --- ( -Syyu )")
		$terminal_ $HOME/.scripts/dwm/pacman/pacupdate.sh
		[ $? -eq 0 ] && notify-send "Pacman update" "Package(s) successfully updated" || notify-send "Error" "An error occurred while trying to update the package(s)"
		;;

	"install --- ( -S )")
		$terminal_ $HOME/.scripts/dwm/pacman/pacinstall.sh
		[ $? -eq 0 ] && notify-send "Pacman install" "Package(s) successfully installed" || notify-send "Error" "An error occurred while trying to install the package(s)"
		;;

	"install [ AUR ] --- ( -S --AUR )")
		$terminal_ $HOME/.scripts/dwm/pacman/pacinstall_aur.sh
		[ $? -eq 0 ] && notify-send "AUR install" "Package(s) successfully installed" || notify-send "Error" "An error occurred while trying to install the package(s)"
		;;

	"remove --- ( -Rsnc )")
		$terminal_ $HOME/.scripts/dwm/pacman/pacremove.sh
		[ $? -eq 0 ] && notify-send "Pacman remove" "Package(s) successfully removed" || notify-send "Error" "An error occurred while trying to remove the package(s)"
		;;

	"list --- ( -Qt )")
		$terminal_ $HOME/.scripts/dwm/pacman/paclist.sh
		;;

	"list all --- ( -Q )")
		$terminal_ $HOME/.scripts/dwm/pacman/paclist_all.sh
		;;
esac
