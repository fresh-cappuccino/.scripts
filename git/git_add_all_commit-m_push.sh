#!/bin/sh

args=$@

[ X"" = X"$args" ] && echo "You need to type a message for the commit" && exit

git add .
git commit -m "$args"
git push
