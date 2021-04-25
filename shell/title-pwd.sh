#!/usr/bin/env bash

_title=$@

NUM_CHAR=27
# NUM_CHAR=29

[ X"" = X"$_title" ] && exit

cd "$_title"
_title=`pwd`

_PATH=
[[ "/`echo "$_title"|cut -d "/" -f 2-3`" = "/home/`whoami`" ]] && _PATH=`echo -n "/"` && _PATH=$_PATH`echo -en "\033[01;36m~\033[01;32m☕\033[01;36m~$(tput sgr0)"` && _PATH=$_PATH`echo -n "/"` && _PATH=$_PATH`echo "$_title"|cut -d "/" -f 4-` || _PATH=$_PATH`echo "$_title"`

if [[ ${_PATH:0:2} = "/"[a-zA-Z] ]] || [[ ${_PATH} = "/" ]] ; then
	_NUM=0
else
	_NUM=$NUM_CHAR
fi

_DASH=
while [[ $_NUM -lt ${#_PATH} ]] ; do _DASH=$_DASH"─" ; _NUM=$[$_NUM + 1] ; done

echo "┌$_DASH┐"
echo "│$_PATH│"
