#!/usr/bin/env bash

progress_bar=-g
overwrite=0
_end=" ;--end--; "

are_u_sure() {
	ANS=z
	while [ "${ANS:0:1}" != "y" ] && [ "${ANS:0:1}" != "Y" ] && [ "${ANS:0:1}" != "n" ] && [ "${ANS:0:1}" != "N" ] && [[ ! -z $ANS ]]
	do
		read -p "$MSG" ANS
	done

	if [ "${ANS:0:1}" = "y" ] || [ "${ANS:0:1}" = "Y" ] ; then
		cp "$progress_bar" $FLAGS "$V" "$DIR_TAR" || cp $FLAGS "$V" "$DIR_TAR"
	else
		echo "'cp \"$V\" \"$DIR_TAR\"' CANCELED!"
	fi
}

while [ 0 -lt $# ]
do
	if [ "$1" = "--overwrite" ] || [ "$1" = "--ow" ] ; then
		overwrite=1
	else
		if [ ${1:0:1} = "-" ] ; then
			FLAGS="$FLAGS $1"
		else
			[ X"" = X"$DIR_ORI" ] && DIR_ORI="$1" || DIR_ORI="$DIR_ORI$_end$1"
		fi
	fi
	shift
done

DIR_TAR=`echo $DIR_ORI|awk -F "$_end" '{print $NF}'|sed 's/\/$//'`
DIR_ORI=`echo "$DIR_ORI"|sed 's/\/$//'`
[ "$DIR_TAR" != "/" ] && SLASHES=`echo "$DIR_TAR"|awk -F '/' '{print NF}'` || SLASHES=1
TAR=$DIR_TAR
if [ $SLASHES -gt 1 ] ; then
	SLASH=1
	[ "${TAR%"${TAR#?}"}" = / ] && SLASHES=$((SLASHES - 1))
	while [ $SLASH -lt $SLASHES ]
	do
		SUB=`echo "$TAR"|awk -F '/' '{print $NF}'`
		DIR_ORI=`echo "$DIR_ORI"|sed "s/\/$SUB$//"`
		TAR=`echo "$TAR"|sed "s/\/$SUB//"`
		SLASH=$((SLASH + 1))
	done
fi
if [ "$TAR" = "." ] ; then
	DIR_ORI=`echo $DIR_ORI|sed "s/$_end\.//"`
elif [ "$TAR" = "/" ] ; then
	DIR_ORI=`echo $DIR_ORI|sed "s/$_end\///"`
elif [ "${TAR%"${TAR#?}"}" = "/" ] ; then
	TAR=`echo "$TAR"|sed 's/^\///'`
	DIR_ORI=`echo $DIR_ORI|sed "s/$_end\/$TAR$//"`
else
	DIR_ORI=`echo $DIR_ORI|sed "s/$_end$TAR//"`
fi

NUM=1
SIZE=`echo "$DIR_ORI"|awk -F "$_end" '{print NF}'`

if [ $overwrite -eq 1 ] ; then
	while [ $NUM -le $SIZE ]
	do
		V=`echo $DIR_ORI|awk -F "$_end" '{print $1}'`
		[ ${#V} -gt 1 ] && V=`echo "$V"|sed 's/\/$//'`

		cp $progress_bar $FLAGS "$V" "$DIR_TAR" || cp "$V" "$DIR_TAR"

		# DIR_ORI=`echo $DIR_ORI|awk -F "$_end" '{$1=""; print}'`

		SLASHES=`echo $V|awk -F "/" '{print NF}'`
		if [ $SLASHES -gt 1 ] ; then
			SLASH=0
			while [ $SLASH -lt $SLASHES ]
			do
				SUB=`echo "$V"|awk -F '/' '{print $1}'`
				DIR_ORI=`echo "$DIR_ORI"|sed "s/$SUB\///"`
				V=`echo "$V"|sed "s/$SUB\///"`
				SLASH=$((SLASH + 1))
			done
		fi
		DIR_ORI=`echo "$DIR_ORI"|sed "s/$V$_end//"`
		NUM=$((NUM + 1))
	done
else
	while [ $NUM -le $SIZE ]
	do
		V=`echo $DIR_ORI|awk -F "$_end" '{print $1}'`
		[ ${#V} -gt 1 ] && v=`echo "$V"|sed 's/\/$//'` || v=$V

		if [ -e "$v" ] ; then
			if [ -e "$DIR_TAR/`echo \"$v\"|awk -F \"/\" '{print $NF}'`" ] ; then
				MSG="$DIR_TAR/`echo $v|awk -F\"/\" '{print $NF}'` already exists, want to continue? [y/N] "
				are_u_sure
			else
				if [ -e "`echo $DIR_TAR`" ] && [ ! -d "`echo $DIR_TAR`" ] ; then
					MSG="$DIR_TAR already exists, want to continue? [y/N] "
					are_u_sure
				else
					cp $progress_bar $FLAGS "$V" "$DIR_TAR" || cp "$FLAGS" "$V" "$DIR_TAR"
				fi
			fi
		else
			cp $progress_bar $FLAGS "$V" "$DIR_TAR" || cp "$FLAGS" "$V" "$DIR_TAR"
		fi

		# DIR_ORI=`echo $DIR_ORI|awk -F "$_end" '{$1=""; print}'`

		if [ "$V" != "/" ] ; then
			[ ${#V} -gt 1 ] && SLASHES=`echo $V|awk -F "/" '{print NF}'` || SLASHES=1
			if [ $SLASHES -gt 1 ] ; then
				SLASH=1
				while [ $SLASH -lt $SLASHES ]
				do
					SUB=`echo "$V"|awk -F '/' '{print $1}'`
					DIR_ORI=`echo "$DIR_ORI"|sed "s/$SUB\///"`
					V=`echo "$V"|sed "s/$SUB\///"`
					SLASH=$((SLASH + 1))
				done
			fi
			DIR_ORI=`echo "$DIR_ORI"|sed "s/$V$_end//"`
		else
			DIR_ORI=`echo "$DIR_ORI"|sed "s/\/$_end//"`
		fi
		NUM=$((NUM + 1))
	done
fi
