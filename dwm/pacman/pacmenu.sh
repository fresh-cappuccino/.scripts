#!/usr/bin/env bash

term_resolution=120x35+640+200
terminal_="st -ig $term_resolution"

# use notify-send if run in dumb term
OUTPUT="echo"
[[ ${TERM} == 'dumb' ]] && OUTPUT="notify-send"

declare -a options=(
"update --- ( -Syyu )"
"install --- ( -S )"
"remove --- ( -R )"
"list --- ( -Q[t] )"
)

# Piping the above array into dmenu.
# "printf '%s\n'" used to format the array one item to a line.
choice=$(printf '%s\n' "${options[@]}" | dmenu -i -l 21 -p '[comm] pacman: ')

# What to do when/if we choose one of the options.
case $choice in
	"update --- ( -Syyu )")
		$terminal_ $HOME/.scripts/dwm/pacman/pacupdate.sh
		[ $? -eq 0 ] && notify-send -i $HOME/.scripts/dwm/pacman/icons/pacman-logo.png "Pacman update" "Package(s) successfully updated" || notify-send -i $HOME/.scripts/dwm/pacman/icons/pacman-error.png "Error" "An error occurred while trying to update the package(s)"
		;;

	"install --- ( -S )")
		declare -a options=(
			"Pacman"
			"AUR"
			"Menu"
		)
		choice=$(printf '%s\n' "${options[@]}" | dmenu -i -p '[install] pacman -S: ')
		if [ X"" != X"$choice" ] ; then
			case $choice in
				'Pacman')
					$terminal_ $HOME/.scripts/dwm/pacman/pacinstall.sh
					;;

				'AUR')
					$terminal_ $HOME/.scripts/dwm/pacman/pacinstall_aur.sh
					;;

				"Menu")
					$terminal_ $HOME/.scripts/dwm/pacman/pacinstall_menu.sh
					;;
			esac

			if [ "$choice" != "Menu" ] ; then
				[ $? -eq 0 ] && notify-send -i $HOME/.scripts/dwm/pacman/icons/pacman-logo.png "Pacman install" "Package(s) successfully installed" || notify-send -i $HOME/.scripts/dwm/pacman/icons/pacman-error.png "Error" "An error occurred while trying to install the package(s)"
			fi
		fi
		;;

	"remove --- ( -R )")
		declare -a options=(
			"--all-dependencies"
			"--only-package"
		)
		choice=$(printf '%s\n' "${options[@]}" | dmenu -i -p '[remove] pacman -R: ')

		if [ X"" != X"$choice" ] ; then
			case $choice in
				'--all-dependencies')
					$terminal_ $HOME/.scripts/dwm/pacman/pacremove_all.sh
					;;

				'--only-package')
					$terminal_ $HOME/.scripts/dwm/pacman/pacremove.sh
					;;
			esac
			[ $? -eq 0 ] && notify-send -i $HOME/.scripts/dwm/pacman/icons/pacman-logo.png "Pacman remove" "Package(s) successfully removed" || notify-send -i $HOME/.scripts/dwm/pacman/icons/pacman-error.png "Error" "An error occurred while trying to remove the package(s)"
		fi
		;;

	"list --- ( -Q[t] )")
		declare -a options=(
			"all"
			"all --include-default"
			"local"
			"unused"
		)
		choice=$(printf '%s\n' "${options[@]}" | dmenu -i -p '[list] pacman -Q[t]: ')
		case $choice in
			'all')
				$terminal_ $HOME/.scripts/dwm/pacman/paclist_all.sh
				;;

			'all --include-default')
				$terminal_ $HOME/.scripts/dwm/pacman/paclist_all_include_default.sh
				;;

			'local')
				$terminal_ $HOME/.scripts/dwm/pacman/paclist.sh
				;;

			'unused')
				$terminal_ $HOME/.scripts/dwm/pacman/paclist_unused.sh
				;;
		esac
		;;
esac
