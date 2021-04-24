#!/bin/sh

_PATH="$HOME/wallpaper" # path where feh is gonna look for the wallpaper
_MAX_CHAR=10 # maximun char letters wall.[ext] must have

while getopts cf:l: OPTION
do
	case $OPTION in
		'c') # deletes all the images in $_PATH, except for the main wallpaper
			_DROP_CACHE=true
			;;

		'f') # set an external file as a wallpape
			_FILE=$OPTARG
			;;

		'l') # set several images as wallpaper, that changes between each other $_TIME to $_TIME
			_TIME=$OPTARG
			_LOOP=true
			;;

		'?') # invalid flag passed or missed arguments
			echo ""
			echo "... invalid argument ..."
			echo ""
			exit 1
			;;
	esac
done

[ ! -d "$_PATH" ] && mkdir -p "$_PATH"

if [ X"" = X"$_LOOP" ] || [ "$_LOOP" = "false" ] ; then
	if [ X"" != X"$_FILE" ] && [ X"" != X"$_DROP_CACHE" ] ; then # set an external image as wallpaper and deletes every image in $_PATH
		[ ! -f "$_FILE" ] && exit 1
		_TMP="TMP_wlppr_FL-nm"
		_EXTF=`echo "$_FILE"|sed 's/\./ /g'|awk '{print $NF}' 2>/dev/null`

		while [ -f "$HOME/$_TMP" ] ; do _TMP=$_TMP"1" ; done

		cp $_FILE $HOME/$_TMP
		ls "$_PATH"
		rm -rf "$_PATH/"*
		mv $HOME/$_TMP "$_PATH/wall.$_EXTF"
	elif [ X"" != X"$_FILE" ] ; then # just set an external image as wallpaper
		[ ! -f "$_FILE" ] && exit 1
		_TMP="TmP_wLpPr_Fl-Nm"
		_EXTF=`echo "$_FILE"|sed 's/\./ /g'|awk '{print $NF}' 2>/dev/null`

		while [ -e "$HOME/$_TMP" ] ; do _TMP=$_TMP"1" ; done
		cp "$_FILE" "$HOME/$_TMP"

		_WALL_CNT=`ls "$_PATH/wall."* 2>/dev/null|wc -l`
		if [ "$_WALL_CNT" -eq 1 ] ; then
			_NAME=`ls "$_PATH/wall."*|head -n1`
			[ ! -e "$_NAME" ] && exit 1
			_RNAME_BASE="wall"
			_NM=$((`ls "$_PATH"|wc -l` - 1))
			_EXTO=`echo "$_NAME"|sed 's/\./ /g'|awk '{print $NF}' 2>/dev/null`
			_RNAME="$_RNAME_BASE$_NM.$_EXTO"

			while [ -f "$_PATH/$_RNAME" ] ; do _NM=$((_NM + 1)) ; _RNAME=$_RNAME_BASE$_NM"."$_EXTO ; done

			mv "$_PATH/wall.$_EXTO" "$_PATH/$_RNAME"
		fi
		mv "$HOME/$_TMP" "$_PATH/wall.$_EXTF"
	elif [ X"" != X"$_DROP_CACHE" ] ; then # just deletes every image in $_PATH, except for the main wallpaper
		rm -rf "$_PATH/wall"[a-zA-Z0-9_\@\-\#\^]*
	fi

	aux=`[ -d "$_PATH" ] && cd "$_PATH" && ls "wall."{"jpeg","jpg","png"} 2>/dev/null`
	[ -f "$_PATH/$aux" ] && [ ${#aux} -le $_MAX_CHAR ] && feh --bg-fill "$_PATH/$aux"

else
	if [ -d "$_PATH" ] ; then
		while :
		do
			_CNT=1
			_IMG_NM=`ls "$_PATH"|wc -l`

			while [ "$_CNT" -le "$_IMG_NM" ]
			do
				_IMG=`ls "$_PATH"|head -n$_CNT|tail -n1|awk '{print $NF}' 2>/dev/null`
				[ -f "$_PATH/$_IMG" ] && feh --bg-fill "$_PATH/$_IMG" && sleep $_TIME
				_CNT=$((_CNT + 1))
			done
		done
	fi
fi
