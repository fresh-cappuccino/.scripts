#!/bin/sh

while [[ 0 -lt $# ]]
do
	[[ ${1:0:1} = "-" ]] && FLAGS="$FLAGS $1" || FIELDS="$FIELDS $1"
	shift
done

$HOME/.scripts/shell/pwd.sh
SIZE=`echo $FIELDS|awk '{print NF}'`
if [ "$SIZE" -gt 0 ] ; then
	NUM=1
	while [ $NUM -le $SIZE ]
	do
		FIELD=`echo $FIELDS|cut -d" " -f$NUM`
		FIELD=`echo $FIELD|sed 's/\ $//'|sed 's/\/$//'`
		[[ -d "$FIELD" ]] && FIELD="$FIELD/" || FIELD="$FIELDS"
		$HOME/.scripts/shell/title-pwd.sh $FIELD
		exa --icons --group-directories-first $FLAGS $FIELD
		echo
		NUM=$((NUM + 1))
	done
else
	exa --icons --group-directories-first $FLAGS $FIELDS
fi
