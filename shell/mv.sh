#!/bin/sh

are_u_sure()
{
	ANS=z
	while [[ "$ANS" != "y"* ]] && [[ "$ANS" != "Y"* ]] && [[ "$ANS" != "n"* ]] && [[ "$ANS" != "N"* ]] && [[ ! -z $ANS ]]
	do
		read -p "$MSG" ANS
	done

	if [[ "$ANS" = "y"* ]] || [[ "$ANS" = "Y"* ]] ; then
		mv -g $FLAGS $V $DIR_TAR || mv $V $DIR_TAR
	else
		echo "'mv \"$V\" \"$DIR_TAR\"' CANCELED!"
	fi
}

while [[ 0 -lt $# ]]
do
	[[ ${1:0:1} = "-" ]] && FLAGS="$FLAGS $1" || DIR_ORI="$DIR_ORI $1"
	shift
done

DIR_TAR=`echo $DIR_ORI|awk '{print $NF}'|sed 's/\/$//'`
DIR_ORI=`echo $DIR_ORI|awk '{$NF=""; print}'|sed 's/\/\ /\ /g'|sed 's/\/$//'`

while [[ ! -z $DIR_ORI ]]
do
	V=`echo $DIR_ORI|awk '{print $1}'`

	if [[ -e "$DIR_TAR/`echo \"$V\"|awk -F \"/\" '{print $NF}'`" ]] ; then
		MSG="$DIR_TAR/`echo $V|awk -F\"/\" '{print $NF}'` already exists, want to continue? [y/N] "
		are_u_sure

	else
		if [[ -e `echo $DIR_TAR`  ]] && [[ ! -d `echo $DIR_TAR` ]] ; then
			MSG="$DIR_TAR already exists, want to continue? [y/N] "
			are_u_sure

		else
			mv -g $FLAGS $V $DIR_TAR || mv $V $DIR_TAR
		fi
	fi

	DIR_ORI=`echo $DIR_ORI|awk '{$1=""; print}'`
done
