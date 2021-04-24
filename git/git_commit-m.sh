#!/bin/sh

[ X"" = X"$@" ]] && echo "You need to type a message for the commit" && exit

args=$@

git commit -m "$args"
