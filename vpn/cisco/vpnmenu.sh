#!/usr/bin/env bash

term_resolution=120x35+640+200
terminal_="st -ig $term_resolution"
vpn_state=`ciscovpn -s status|tail -n5|head -n1|awk '{print $NF}'`

# screen_heigh=`xdpyinfo|grep dimensions|sed -r 's/^[^0-9]*([0-9]+x[0-9]+).*$/\1/'|awk -F 'x' '{print $1}'`
# screen_width=`xdpyinfo|grep dimensions|sed -r 's/^[^0-9]*([0-9]+x[0-9]+).*$/\1/'|awk -F 'x' '{print $2}'`

# use notify-send if run in dumb term
OUTPUT="echo"
[[ ${TERM} == 'dumb' ]] && OUTPUT="notify-send"

declare -a options=(
"connect"
"disconnect"
"status"
"stats"
)

# Piping the above array into dmenu.
# "printf '%s\n'" used to format the array one item to a line.
choice=$(printf '%s\n' "${options[@]}" | dmenu -i -l 21 -p "[VPN] ciscovpn (`[[ "$vpn_state" = "Disconnected" ]] && echo "disc" || echo "conn"`): ")

# What to do when/if we choose one of the options.
case $choice in
	"connect")
		if [[ "$vpn_state" = "Disconnected" ]] ; then
			declare -a options=(
				"unimed"
				"other"
			)

			choice=$(printf '%s\n' "${options[@]}" | dmenu -i -p '[VPN] ciscovpn connect: ')
			if [ X"" != X"$choice" ] ; then
				case $choice in
					"unimed")
						$terminal_ ciscovpn -s connect vpn2.unimed.coop.br
						;;

					"other")
						$terminal_ ciscovpn
						;;
				esac

				vpn_state=`ciscovpn -s status|tail -n5|head -n1|awk '{print $NF}'`
				[ "$vpn_state" != "Disconnected" ] && notify-send -i $HOME/.scripts/vpn/cisco/icons/ciscovpn-logo.png "Cisco VPN" "VPN successfully connected" || notify-send -i $HOME/.scripts/vpn/cisco/icons/ciscovpn-error.png "Error" "An error occurred while trying to connect VPN"
			fi
		else
			notify-send -i $HOME/.scripts/vpn/cisco/icons/ciscovpn-logo.png "Cisco VPN" "VPN is already connected"
		fi
		;;

	"disconnect")
		if [[ "$vpn_state" != "Disconnected" ]] ; then
			ciscovpn -s disconnect
			vpn_state=`ciscovpn -s status|tail -n5|head -n1|awk '{print $NF}'`
			[ "$vpn_state" = "Disconnected" ] && notify-send -i $HOME/.scripts/vpn/cisco/icons/ciscovpn-logo.png "Cisco VPN" "VPN successfully disconnected" || notify-send -i $HOME/.scripts/vpn/cisco/icons/ciscovpn-error.png "Error" "An error occurred while trying to disconnect VPN"
		else
			notify-send -i $HOME/.scripts/vpn/cisco/icons/ciscovpn-logo.png "Cisco VPN" "VPN is already disconnected"
		fi
		;;

	"status")
		$terminal_ $HOME/.scripts/vpn/cisco/vpnstatus.sh
		;;

	"stats")
		$terminal_ $HOME/.scripts/vpn/cisco/vpnstats.sh
		;;
esac
