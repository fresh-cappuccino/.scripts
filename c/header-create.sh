#!/bin/sh

[[ -z $1 ]] && echo "You need to specify a name for the library" && exit

header_name=$1
[[ `echo $header_name|awk -F '.' '{print $NF}'` = "h" ]] && header_name=${header_name:0:$[${#header_name} - 2]}

HEADER_NAME=`echo "$header_name"|tr ['a-z'] ['A-Z']|tr ['.'] ['_']`

echo -n "#ifndef ${HEADER_NAME}_H
#define ${HEADER_NAME}_H

#endif" >> $header_name.h

echo "$header_name.h successfully created"
