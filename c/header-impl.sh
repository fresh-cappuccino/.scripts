#!/bin/sh

execute=true
relative_path=true

# get all the options
#
# e = execute header implementation (true by default)
# l = library path
# n = library name
# r = relative path in include (true by default)
# s = source code path
while getopts e:l:n:r:s: OPTION
do
	case $OPTION in
		'e')
			execute=$OPTARG
			;;

		'l')
			lib_path=$OPTARG
			;;

		'n')
			header_name=$OPTARG
			;;

		'r')
			relative_path=$OPTARG
			;;

		's')
			source_path=$OPTARG
			;;
	esac
done

# check if the name of the library was passed
# if not, exit the script
[[ -z $header_name ]] && echo "You need to specify a name for the library implementation" && exit

# check the the extension of the library (.h) was passed
# if it was, delete the extension
[[ `echo $header_name|awk -F '.' '{print $NF}'` = "h" ]] && header_name=${header_name:0:$[${#header_name} - 2]}

# if library path was not passed, so the actual directory is considered to be it
[[ -z $lib_path ]] && lib_path=`pwd`

# if source code path was not passed, so the actual directory is considered to be it
[[ -z $source_path ]] && source_path=`pwd`

# change all paths to absolute paths
actual_path=`pwd`
cd $lib_path
lib_path=`pwd`
cd $actual_path
cd $source_path
source_path=`pwd`
cd $actual_path

# variable responsible to be the relative path for the library include in c file
include=

# if the library path is different from the source code path
# so $include is mount
if [[ "$lib_path" != "$source_path" ]] && [[ "$relative_path" = "t"* ]] ; then
	num=1

	# while both paths are equal, increment num
	while [[ `echo "$lib_path"|cut -s -d "/" -f $num` = `echo "$source_path"|cut -s -d "/" -f $num` ]]
	do
		num=$[$num + 1]
	done

	num_temp=$num

	# mount the relative path in $include
	while [[ ! -z `echo "$source_path"|cut -s -d "/" -f $num_temp` ]]
	do
		num_temp=$[$num_temp + 1]
		include=$include"../"
	done

	temp=`echo "$lib_path"|cut -s -d "/" -f $num`
	while [[ ! -z "$temp" ]]
	do
		num=$[$num + 1]
		include=$include$temp"/"
		temp=`echo "$lib_path"|cut -s -d "/" -f $num`
	done
fi

# number of lines in $header_name.h
header_size=`cat $lib_path/$header_name.h 2>/dev/null|wc -l`

# get the content of $header_name.h (only the implementation)
header_functions=`head -n$[$header_size - 1] $lib_path/$header_name.h 2>/dev/null|tail -n$[$header_size - 3] 2>/dev/null`

# if $header_functions have any content, so takes of all blank lines from the beginning and from the end of the file
if [[ ! -z `echo $header_functions` ]] ; then
	while [[ -z `echo "$header_functions"|head -n1` ]] || [[ `echo $header_functions|head -n1` = "#"* ]]
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

# implement it
echo -n "#include <stdio.h>

#include \"$include$header_name.h\"

$header_functions" >> $source_path/$header_name.c

echo "$header_name.c successfully created in $source_path"

[[ "$execute" = "t"* ]] && nvim "$source_path/$header_name.c" || echo $? >/dev/null
