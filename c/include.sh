#!/bin/sh

relative_path=true

# get all the options
#
# e = execute header implementation (true by default)
# l = library path
# n = library name
# r = relative path in include (true by default)
# s = source code path
while getopts h:n:p:r:s: OPTION
do
	case $OPTION in
		'h')
			header_name=$OPTARG
			;;

		'p')
			src=$OPTARG
			;;

		'r')
			relative_path=$OPTARG
			;;

		's')
			source_file=$OPTARG
			;;
	esac
done

# check if the name of the library was passed
# if not, exit the script
[ -z "$header_name" ] && echo "You need to specify a name for the library" && exit

[ -z "$source_file" ] && echo "You need to specify a name for the source file" && exit

# check the the extension of the library (.h) was passed
# if it was, delete the extension
[ `echo "$header_name"|awk -F '.' '{print $NF}'` != "h" ] && header_name=$header_name".h"
[ `echo "$source_file"|awk -F '.' '{print $NF}'` != "c" ] && source_file=$source_file".c"

# check if src is empty
# if it is, so set the default value
[ -z "$src" ] && src=src

header_name=`echo "$header_name"|awk -F '/' '{print $NF}'`
hn=`find $src -maxdepth 100 -type f -name $header_name|head -n1|sed 's/\/'$header_name'$//'`
[ -z "$hn" ] && echo "library \"$header_name\" not found!" && exit

source_file=`echo "$source_file"|awk -F '/' '{print $NF}'`
sf=`find $src -maxdepth 100 -type f -name $source_file|head -n1|sed 's/\/'$source_file'$//'`
[ -z "$sf" ] && echo "source file \"$source_file\" not found!" && exit

lib_path=`cd $hn && pwd || echo "error finding for library"`
source_path=`cd $sf && pwd || echo "error finding for source file"`

[ -z "$lib_path" ] && echo "header name does not exist!" && exit
[ -z "$source_path" ] && echo "source file does not exist!" && exit

# variable responsible to be the relative path for the library included in c file
include=

# if the library path is different from the source code path
# so $include is mount
if [ "$lib_path" != "$source_path" ] && [ "${relative_path%"${relative_path#?}"}" = "t" ] ; then
	num=1

	# while both paths are equal, increment num
	while [ X"`echo "$lib_path"|cut -s -d "/" -f $num`" = X"`echo "$source_path"|cut -s -d "/" -f $num`" ]
	do
		num=$((num + 1))
	done

	num_temp=$num

	# mount the relative path in $include
	while [ X"" != X"`echo "$source_path"|cut -s -d "/" -f $num_temp`" ]
	do
		num_temp=$((num_temp + 1))
		include=$include"../"
	done

	temp=`echo "$lib_path"|cut -s -d "/" -f $num`
	while [ ! -z "$temp" ]
	do
		num=$((num + 1))
		include=$include$temp"/"
		temp=`echo "$lib_path"|cut -s -d "/" -f $num`
	done
fi

include=`echo $include|sed 's/\/$//'`
echo "#include \"$include/$header_name\""
