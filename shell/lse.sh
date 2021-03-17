#!/bin/sh

while [[ 0 -lt $# ]]
do
	[[ ${1:0:1} = "-" ]] && FLAGS="$FLAGS $1" || FIELDS="$FIELDS $1"
	shift
done

if [[ `echo $FIELDS|awk '{print NF}'` -eq 1 ]] ; then
	$HOME/.scripts/shell/pwd.sh
	FIELDS=`echo $FIELDS|sed 's/\ $//'|sed 's/\/$//'`
	[[ -d "$FIELDS" ]] && echo "$FIELDS/:" || echo "$FIELDS:"
	exa --icons --group-directories-first $FLAGS $FIELDS
	exit 0
fi

$HOME/.scripts/shell/pwd.sh ; exa --icons --group-directories-first $FLAGS $FIELDS
