#!/usr/bin/env bash

_end=" ;--END--; "

while [ 0 -lt $# ]
do
	if [[ ${1:0:1} = "-" ]] ; then
		FLAGS="$FLAGS $1"
	else
		[ X"" = X"$FIELDS" ] && FIELDS="$1" || FIELDS="$FIELDS$_end$1"
	fi
	shift
done

$HOME/.scripts/shell/pwd.sh
SIZE=`echo $FIELDS|awk -F "$_end" '{print NF}'`
if [ "$SIZE" -gt 0 ] ; then
	NUM=1
	while [ $NUM -le $SIZE ]
	do
		FIELD=`echo $FIELDS|awk -F "$_end" '{print $'$NUM'}'`
		FIELD=`echo $FIELD|sed 's/\ $//'|sed 's/\/$//'`
		[[ -d "$FIELD" ]] && FIELD="$FIELD/"
		$HOME/.scripts/shell/title-pwd.sh $FIELD
		exa --icons --group-directories-first $FLAGS $FIELD
		echo
		NUM=$((NUM + 1))
	done
else
	exa --icons --group-directories-first $FLAGS $FIELDS
fi
