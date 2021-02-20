#!/bin/sh

_PATH=
[[ `pwd|cut -d "/" -f 3` = `whoami` ]] && _PATH=`echo -n "/"` && _PATH=$_PATH`echo -en "\033[01;32m~\033[01;36m☕\033[01;32m~$(tput sgr0)"` && _PATH=$_PATH`echo -n "/"` && _PATH=$_PATH`pwd|cut -d "/" -f 4-` || _PATH=$_PATH`pwd`

if [[ ${_PATH:0:2} = "/"[a-zA-Z] ]] || [[ ${_PATH} = "/" ]] ; then
	_NUM=0
else
	_NUM=27
fi

_DASH=
while [[ $_NUM -lt ${#_PATH} ]] ; do _DASH=$_DASH"─" ; _NUM=$[$_NUM + 1] ; done

echo $_DASH
echo $_PATH
echo $_DASH