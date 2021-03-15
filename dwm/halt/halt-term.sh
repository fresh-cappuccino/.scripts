#!/bin/sh

list_opt()
{
	echo "############################"
	echo "#        ___       _______ #"
	echo "# |   | /   \\ |       |    #"
	echo "# |___| |___| |       |    #"
	echo "# |   | |   | |       |    #"
	echo "# |   | |   | \\___    |    #"
	echo "############################"
	echo "|___|______________________|"
	echo "|   |                      |"
	echo "| ? | DESC                 |"
	echo "|   |                      |"
	echo "| 1 | SLOCK                |"
	echo "|   |                      |"
	echo "| 2 | QUIT DWM             |"
	echo "|   |                      |"
	echo "| 3 | REBOOT               |"
	echo "|   |                      |"
	echo "| 4 | HALT                 |"
	echo "|   |                      |"
	echo "| 0 | CANCEL               |"
	echo "|___|______________________|"
}

catch_opt()
{
	while [[ "$opt" != "1"* ]] &&
				[[ "$opt" != "2"* ]] &&
				[[ "$opt" != "3"* ]] &&
				[[ "$opt" != "4"* ]] &&
				[[ "$opt" != "0"* ]] &&
				[[ "$opt" != "?"* ]]
	do
		read opt
	done

	opt=${opt:0:1}

	case $opt in
		'1')
			opt_slock
			;;

		'2')
			echo "TO EXIT DWM, PRESS: <SUPER> + <ALT> + Q" ; echo "" ; echo "... press [ENTER] to exit the script ..." ; read aux
			;;

		'3')
			opt_reboot
			;;

		'4')
			opt_halt
			;;

		'0')
			break
			;;

		'?')
			clear
			echo "##############################################"
		  echo "#  __    ___  ___  ___  ___     ___  _______ #"
			echo "# |  \\  /    /    /    |   \\ | |   \\    |    #"
			echo "# |   \\ |__  \\__  |    |___/ | |___/    |    #"
			echo "# |   / |       \\ |    |   \\ | |        |    #"
			echo "# |__/  \\___ ___/ \\___ |   | | |        |    #"
			echo "##############################################"
			echo "|___|________________________________________|"
			echo "|   |                                        |"
			echo "| ? | SHOW DESCRIPTIONS OF EACH OPTION       |"
			echo "|   |                                        |"
			echo "| 1 | LOCK SCREEN WITH SLOCK                 |"
			echo "|   |                                        |"
			echo "| 2 | QUIT INTERFACE                         |"
			echo "|   |                                        |"
			echo "| 3 | REBOOT THE SYSTEM                      |"
			echo "|   |                                        |"
			echo "| 4 | TURN OFF THE SYSTEM                    |"
			echo "|   |                                        |"
			echo "| 0 | CANCEL SCRIPT                          |"
			echo "|___|________________________________________|"
			echo ""
			echo "... press [ENTER] to go back to main menu ..." && read aux
			;;
	esac
}

opt_slock()
{
	_init=0
	_end=13
	_char=""
	_space=""

	while [[ $_init -lt $_end ]]
	do
		_space=$_space"-"
		_init=$[$_init + 1]
	done
	$_init=0

	while [[ ${#_char} -le $_end ]]
	do
		clear
		echo "... slocking screen ..." ; echo ""
		echo -n "    [" ; echo -n $_char ; echo -n "${_space:0:$[$_end - ${#_char}]}" ; echo -n "]"
		_char=$_char"#"
		sleep 0.1
	done
	slock
}

opt_reboot()
{
	_init=0
	_end=7
	_char=""
	_space=""

	while [[ $_init -lt $_end ]]
	do
		_space=$_space"-"
		_init=$[$_init + 1]
	done
	$_init=0

	while [[ ${#_char} -le $_end ]]
	do
		clear
		echo "... rebooting ..." ; echo ""
		echo -n "    [" ; echo -n $_char ; echo -n "${_space:0:$[$_end - ${#_char}]}" ; echo -n "]"
		_char=$_char"#"
		sleep 0.5
	done
	shutdown -r now
}

opt_halt()
{
	_init=0
	_end=9
	_char=""
	_space=""

	while [[ $_init -lt $_end ]]
	do
		_space=$_space"-"
		_init=$[$_init + 1]
	done
	$_init=0

	while [[ ${#_char} -le $_end ]]
	do
		clear
		echo "... turning off ..." ; echo ""
		echo -n "    [" ; echo -n $_char ; echo -n "${_space:0:$[$_end - ${#_char}]}" ; echo -n "]"
		_char=$_char"#"
		sleep 0.5
	done
	shutdown -h now
}

main()
{
	clear

	opt='?'
	while [[ "$opt" = "?"* ]]
	do
		clear
		opt=''
		list_opt
		catch_opt
	done
}

main
