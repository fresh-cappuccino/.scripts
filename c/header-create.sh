#!/bin/sh

execute=true

# get the options
#
# e = execute the created library true by default
# l = library path
# n = name of the library
while getopts e:l:n: OPTION
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
	esac
done

# check if a name for the library was passed, if not, exit the script
[ -z "$header_name" ] && echo "You need to specify a name for the library" && exit

# if a path for the library was not passed, so it considers thw actual directory to be it
[ -z "$lib_path" ] && lib_path=`pwd`

# check if an extension for the library was passed (.h)
# if so, it deletes it
[ `echo "$header_name"|awk -F '.' '{print $NF}'` = "h" ] && header_name=${header_name:0:$[${#header_name} - 2]}

# create a variable to include the constant with the library name (for definition)
HEADER_NAME=`echo "$header_name"|tr ['a-z'] ['A-Z']|tr ['.'] ['_']`

# checks if $lib_path exists, if not, creates it
[ ! -e "$lib_path" ] && mkdir -p "$lib_path"

# implements the library
echo -n "#ifndef _${HEADER_NAME}_H_
#define _${HEADER_NAME}_H_

#endif" >> $lib_path/$header_name.h

echo "$header_name.h successfully created in $lib_path"

[ "${execute%"${execute#?}"}" = "t" ] && nvim "$lib_path/$header_name.h" || echo $? >/dev/null
