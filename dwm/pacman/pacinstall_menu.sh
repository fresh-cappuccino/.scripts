#!/bin/sh

exiopt=0
pacopt=1
auropt=2
overopt=3
opt=3

while [ $opt -ne $exiopt ]
do
	clear

	echo "$pacopt) Install with pacman"
	echo "$auropt) Install from AUR"
	echo "$exiopt) Exit"

	read opt

	case $opt in
		$pacopt)
			pacman -Slq | fzf -m --preview 'cat <(pacman -Si {1}) <(pacman -Fl {1} | awk \"{print \$2}\")' | xargs -ro sudo pacman -S
			;;

		$auropt)
			paru -Slq | fzf -m --preview 'cat <(paru -Si {1}) <(paru -Fl {1} | awk \"{print \$2}\")' | xargs -ro paru -S
			;;
	esac

	[ $opt -ne 0 ] && ! expr "$opt" + 0 >/dev/null 2>&1 && echo "Ony numbers are allowed!" && opt=$overopt && read -p "Press [ENTER] to continue"
done

exit 0
