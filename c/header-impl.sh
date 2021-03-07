#!/bin/sh

[[ -z $1 ]] && echo "You need to specify a name for the library" && exit

header_name=$1
[[ `echo $header_name|awk -F '.' '{print $NF}'` = "h" ]] && header_name=${header_name:0:$[${#header_name} - 2]}

HEADER_NAME=`echo "$header_name"|tr ['a-z'] ['A-Z']|tr ['.'] ['_']`

[[ -z $2 ]] && path=`pwd` || path=$2
header_size=`cat $path/$header_name.h|wc -l`
header_functions=`head -n$[$header_size - 1] $path/$header_name.h|tail -n$[$header_size - 3]`

if [[ ! -z `echo $header_functions` ]] ; then
	while [[ -z `echo "$header_functions"|head -n1` ]]
	do
		header_size=`echo "$header_functions"|wc -l`
		header_functions=`echo "$header_functions"|tail -n$[$header_size - 1]`
	done

	while [[ -z `echo "$header_functions"|tail -n1` ]]
	do
		header_size=`echo "$header_functions"|wc -l`
		header_functions=`echo "$header_functions"|head -n$[$header_size - 1]`
	done
fi

echo -n "#include <stdio.h>

#include \"$header_name.h\"

$header_functions" >> $header_name.c

echo "$header_name.h successfully created"
