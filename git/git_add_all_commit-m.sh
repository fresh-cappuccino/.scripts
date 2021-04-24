#!/bin/sh

[ X"" = X"$@" ] && echo "You need to type a message for the commit" && exit

args=$@

git add .
git commit -m "$args"
