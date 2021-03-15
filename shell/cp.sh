#!/bin/sh

are_u_sure()
{
	ANS=z
	while [[ "$ANS" != "y"* ]] && [[ "$ANS" != "Y"* ]] && [[ "$ANS" != "n"* ]] && [[ "$ANS" != "N"* ]] && [[ ! -z $ANS ]]
	do
		read -p "$MSG" ANS
	done

	if [[ "$ANS" = "y"* ]] || [[ "$ANS" = "Y"* ]] ; then
		cp -g $FLAGS $V $DIR_TAR || cp $V $DIR_TAR
	else
		echo "'cp \"$V\" \"$DIR_TAR\"' CANCELED!"
	fi
}

while [[ 1 -lt $# ]]
do
	[[ ${1:0:1} = "-" ]] && FLAGS="$FLAGS $1" || DIR_ORI="$DIR_ORI $1"
	shift
done

DIR_TAR=$1

if [[ "${DIR_TAR:0:1}" = "-" ]] ; then
	FLAGS="$FLAGS $DIR_TAR"
	DIR_TAR=`echo $DIR_ORI|awk '{print $NF}'`
	DIR_ORI=`echo $DIR_ORI|awk '{$NF=""; print}'`
fi

DIR_ORI=`echo $DIR_ORI|sed 's/\/\ /\ /g'|sed 's/\/$//'`
DIR_TAR=`echo $DIR_TAR|sed 's/\/$//'`

while [[ ! -z $DIR_ORI ]]
do
	V=`echo $DIR_ORI|awk '{print $1}'`

	if [[ -e "$DIR_TAR/`echo \"$V\"|awk -F \"/\" '{print $NF}'`" ]] ; then
		MSG="$DIR_TAR/`echo $V|awk -F\"/\" '{print $NF}'` already exists, want to continue? [y/N] "
		are_u_sure

	else
		if [[ `echo $V|awk -F"/" '{print $NF}'` = `echo $DIR_TAR|awk -F "/" '{print $NF}'`  ]] && [[ ! -d `echo $DIR_TAR|awk -F "/" '{print $NF}'` ]] ; then
			MSG="$DIR_TAR already exists, want to continue? [y/N] "
			are_u_sure
		else
			cp -g $FLAGS $V $DIR_TAR || cp $V $DIR_TAR
		fi
	fi

	DIR_ORI=`echo $DIR_ORI|awk '{$1=""; print}'`
done
