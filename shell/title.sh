#!/usr/bin/env bash

_title=$@

[ X"" = X"$_title" ] && exit

_NUM=0

_DASH=
while [[ $_NUM -lt ${#_title} ]] ; do _DASH=$_DASH"─" ; _NUM=$[$_NUM + 1] ; done

echo "┌─$_DASH─┐"
echo "│ $_title │"
echo "  $_DASH"
